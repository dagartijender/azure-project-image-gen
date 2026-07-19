import base64
import json
import logging
import signal
import sys
import time
from uuid import UUID

from azure.servicebus import ServiceBusClient
from azure.storage.blob import BlobServiceClient
from openai import AzureOpenAI
from sqlalchemy.orm import Session

from app.config import settings
from app.database import Base, SessionLocal, engine
from app.models import ImageJob

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)

logger = logging.getLogger("image-worker")

running = True


# -------------------------------------------------------------------
# Azure Clients
# -------------------------------------------------------------------

servicebus_client = ServiceBusClient.from_connection_string(
    settings.SERVICE_BUS_CONNECTION_STRING
)

blob_service_client = BlobServiceClient.from_connection_string(
    settings.AZURE_STORAGE_CONNECTION_STRING
)

container_client = blob_service_client.get_container_client(
    settings.AZURE_STORAGE_CONTAINER_NAME
)

openai_client = AzureOpenAI(
    api_key=settings.AZURE_OPENAI_API_KEY,
    api_version=settings.AZURE_OPENAI_API_VERSION,
    azure_endpoint=settings.AZURE_OPENAI_ENDPOINT,
)


# -------------------------------------------------------------------
# Shutdown
# -------------------------------------------------------------------

def shutdown_handler(signum, frame):
    global running
    logger.info("Stopping worker...")
    running = False


signal.signal(signal.SIGTERM, shutdown_handler)
signal.signal(signal.SIGINT, shutdown_handler)


# -------------------------------------------------------------------
# Azure OpenAI
# -------------------------------------------------------------------

def generate_image_bytes(
    *,
    prompt: str,
    size: str,
    quality: str,
    model: str,
) -> bytes:

    result = openai_client.images.generate(
        model=model,
        prompt=prompt,
        size=size,
        quality=quality,
        n=1,
    )

    return base64.b64decode(result.data[0].b64_json)


# -------------------------------------------------------------------
# Azure Blob Storage
# -------------------------------------------------------------------

def upload_image(
    *,
    job: ImageJob,
    image_bytes: bytes,
) -> str:

    extension = settings.OPENAI_IMAGE_OUTPUT_FORMAT

    blob_name = (
        f"generated-images/"
        f"{job.user_id}/"
        f"{job.id}.{extension}"
    )

    blob_client = container_client.get_blob_client(blob_name)

    blob_client.upload_blob(
        image_bytes,
        overwrite=True,
        content_type="image/png",
    )

    return blob_name


# -------------------------------------------------------------------
# Database
# -------------------------------------------------------------------

def mark_failed(
    db: Session,
    job_id: UUID,
    error: str,
):

    job = db.query(ImageJob).filter(
        ImageJob.id == job_id
    ).first()

    if job:
        job.status = "FAILED"
        job.error = error[:2000]
        db.commit()


# -------------------------------------------------------------------
# Process Message
# -------------------------------------------------------------------

def process_message(message, receiver):

    body = json.loads(str(message))

    job_id = UUID(body["job_id"])

    db = SessionLocal()

    try:

        job = db.query(ImageJob).filter(
            ImageJob.id == job_id
        ).first()

        if not job:
            receiver.complete_message(message)
            return

        if job.status == "COMPLETED":
            receiver.complete_message(message)
            return

        job.status = "PROCESSING"
        job.error = None

        db.commit()

        image = generate_image_bytes(
            prompt=job.prompt,
            size=job.size,
            quality=job.quality,
            model=job.model,
        )

        blob_name = upload_image(
            job=job,
            image_bytes=image,
        )

        job.status = "COMPLETED"
        job.blob_name = blob_name

        db.commit()

        receiver.complete_message(message)

        logger.info(
            "Completed Job %s",
            job.id,
        )

    except Exception as ex:

        db.rollback()

        logger.exception(ex)

        mark_failed(
            db,
            job_id,
            str(ex),
        )

        receiver.abandon_message(message)

    finally:
        db.close()


# -------------------------------------------------------------------
# Poll Queue
# -------------------------------------------------------------------

def poll_once():

    with servicebus_client:

        receiver = servicebus_client.get_queue_receiver(
            queue_name=settings.SERVICE_BUS_QUEUE_NAME,
            max_wait_time=5,
        )

        with receiver:

            for message in receiver:

                process_message(
                    message,
                    receiver,
                )


# -------------------------------------------------------------------
# Main
# -------------------------------------------------------------------

def main():

    Base.metadata.create_all(bind=engine)

    logger.info(
        "Azure Worker Started..."
    )

    while running:

        try:

            poll_once()

        except Exception:

            logger.exception(
                "Polling Error"
            )

            time.sleep(5)

    logger.info("Worker stopped")


if __name__ == "__main__":
    sys.exit(main())
