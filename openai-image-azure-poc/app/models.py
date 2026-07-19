import uuid

from sqlalchemy import (
    Column,
    DateTime,
    ForeignKey,
    Index,
    String,
    Text,
    Uuid,
    func,
)
from sqlalchemy.orm import relationship

from app.database import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Uuid, primary_key=True, default=uuid.uuid4)

    email = Column(
        String(320),
        unique=True,
        nullable=False,
        index=True,
    )

    created_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    jobs = relationship(
        "ImageJob",
        back_populates="user",
        cascade="all, delete-orphan",
    )


class ImageJob(Base):
    __tablename__ = "image_jobs"

    id = Column(Uuid, primary_key=True, default=uuid.uuid4)

    user_id = Column(
        Uuid,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    prompt = Column(Text, nullable=False)

    size = Column(
        String(32),
        nullable=False,
        default="1024x1024",
    )

    quality = Column(
        String(32),
        nullable=False,
        default="high",
    )

    # Azure OpenAI deployment name
    model = Column(
        String(100),
        nullable=False,
        default="gpt-image",
    )

    status = Column(
        String(30),
        nullable=False,
        default="QUEUED",
        index=True,
    )

    # Azure Blob Storage object name
    blob_name = Column(Text, nullable=True)

    # Optional Blob URL
    blob_url = Column(Text, nullable=True)

    error = Column(Text, nullable=True)

    created_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )

    updated_at = Column(
        DateTime(timezone=True),
        server_default=func.now(),
        onupdate=func.now(),
        nullable=False,
    )

    user = relationship(
        "User",
        back_populates="jobs",
    )


Index(
    "idx_image_jobs_user_created",
    ImageJob.user_id,
    ImageJob.created_at.desc(),
)
