import json
from uuid import UUID

from azure.servicebus import ServiceBusClient, ServiceBusMessage

from app.config import settings


# Create Service Bus Client
servicebus_client = ServiceBusClient.from_connection_string(
    conn_str=settings.SERVICE_BUS_CONNECTION_STRING
)


def send_image_job_to_queue(
    *,
    job_id: UUID,
    email: str,
    prompt: str,
    size: str,
    quality: str,
    model: str,
) -> None:
    """
    Send image generation request to Azure Service Bus Queue.
    """

    body = {
        "job_id": str(job_id),
        "email": email,
        "prompt": prompt,
        "size": size,
        "quality": quality,
        "model": model,
    }

    message = ServiceBusMessage(
        body=json.dumps(body),
        message_id=str(job_id),          # Similar to SQS DeduplicationId
        subject="image-generation",      # Optional
        session_id=email.lower(),        # Similar to FIFO MessageGroupId
    )

    with servicebus_client:
        sender = servicebus_client.get_queue_sender(
            queue_name=settings.SERVICE_BUS_QUEUE_NAME
        )

        with sender:
            sender.send_messages(message)
