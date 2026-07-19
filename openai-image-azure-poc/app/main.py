from contextlib import asynccontextmanager
from uuid import UUID

from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from sqlalchemy import text
from sqlalchemy.orm import Session

from app.config import settings
from app.database import Base, engine, get_db
from app.models import ImageJob, User
from app.schemas import (
    GenerateImageRequest,
    GenerateImageResponse,
    JobResponse,
)

from app.azure_blob import create_blob_sas_url
from app.azure_servicebus import (
    send_image_job_to_queue,
    servicebus_client,
)


@asynccontextmanager
async def lifespan(app: FastAPI):
    # For production use Alembic migrations
    Base.metadata.create_all(bind=engine)
    yield


app = FastAPI(
    title=settings.APP_NAME,
    lifespan=lifespan,
)


origins = (
    ["*"]
    if settings.CORS_ORIGINS == "*"
    else [o.strip() for o in settings.CORS_ORIGINS.split(",")]
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# ------------------------------------------------------------------
# Health Check
# ------------------------------------------------------------------
@app.get("/api/health")
def health():

    checks = {}

    # Database
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))

        checks["database"] = "ok"

    except Exception:
        checks["database"] = "error"

    # Azure Service Bus
    try:
        with servicebus_client:

            receiver = servicebus_client.get_queue_receiver(
                queue_name=settings.SERVICE_BUS_QUEUE_NAME
            )

            receiver.close()

        checks["service_bus"] = "ok"

    except Exception:
        checks["service_bus"] = "error"

    overall_status = (
        "ok"
        if all(value == "ok" for value in checks.values())
        else "degraded"
    )

    return JSONResponse(
        status_code=200 if overall_status == "ok" else 503,
        content={
            "status": overall_status,
            "service": settings.APP_NAME,
            "environment": settings.ENVIRONMENT,
            "checks": checks,
        },
    )


# ------------------------------------------------------------------
# Convert DB Model
# ------------------------------------------------------------------
def to_job_response(job: ImageJob, email: str):

    image_url = None

    if job.status == "COMPLETED" and job.blob_name:
        image_url = create_blob_sas_url(job.blob_name)

    return JobResponse(
        job_id=job.id,
        email=email,
        prompt=job.prompt,
        size=job.size,
        quality=job.quality,
        model=job.model,
        status=job.status,
        image_url=image_url,
        blob_name=job.blob_name,
        error=job.error,
        created_at=job.created_at,
        updated_at=job.updated_at,
    )


# ------------------------------------------------------------------
# Generate Image
# ------------------------------------------------------------------
@app.post(
    "/api/generate",
    response_model=GenerateImageResponse,
)
def generate_image(
    payload: GenerateImageRequest,
    db: Session = Depends(get_db),
):

    email = payload.email.lower()

    user = db.query(User).filter(User.email == email).first()

    if not user:
        user = User(email=email)
        db.add(user)
        db.flush()

    job = ImageJob(
        user_id=user.id,
        prompt=payload.prompt,
        size=payload.size,
        quality=payload.quality,
        model=settings.AZURE_OPENAI_DEPLOYMENT_NAME,
        status="QUEUED",
    )

    db.add(job)
    db.commit()
    db.refresh(job)

    try:

        send_image_job_to_queue(
            job_id=str(job.id),
            email=email,
            prompt=payload.prompt,
            size=payload.size,
            quality=payload.quality,
            model=settings.AZURE_OPENAI_DEPLOYMENT_NAME,
        )

    except Exception as exc:

        job.status = "FAILED"
        job.error = f"Azure Service Bus enqueue failed: {exc}"

        db.commit()

        raise HTTPException(
            status_code=500,
            detail="Unable to queue image generation request",
        )

    return GenerateImageResponse(
        job_id=job.id,
        status=job.status,
        message="Image generation request submitted successfully.",
    )


# ------------------------------------------------------------------
# Get Job
# ------------------------------------------------------------------
@app.get(
    "/api/jobs/{job_id}",
    response_model=JobResponse,
)
def get_job(
    job_id: UUID,
    db: Session = Depends(get_db),
):

    job = db.query(ImageJob).filter(
        ImageJob.id == job_id
    ).first()

    if not job:
        raise HTTPException(
            status_code=404,
            detail="Job not found",
        )

    user = db.query(User).filter(
        User.id == job.user_id
    ).first()

    return to_job_response(job, user.email)


# ------------------------------------------------------------------
# List User Images
# ------------------------------------------------------------------
@app.get(
    "/api/users/{email}/images",
    response_model=list[JobResponse],
)
def list_user_images(
    email: str,
    db: Session = Depends(get_db),
):

    email = email.lower()

    user = db.query(User).filter(
        User.email == email
    ).first()

    if not user:
        return []

    jobs = (
        db.query(ImageJob)
        .filter(ImageJob.user_id == user.id)
        .order_by(ImageJob.created_at.desc())
        .limit(100)
        .all()
    )

    return [
        to_job_response(job, user.email)
        for job in jobs
    ]
