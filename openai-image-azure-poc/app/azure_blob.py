from datetime import datetime, timedelta

from azure.storage.blob import (
    BlobSasPermissions,
    BlobServiceClient,
    generate_blob_sas,
)

from app.config import settings


# Blob Service Client
blob_service_client = BlobServiceClient.from_connection_string(
    settings.AZURE_STORAGE_CONNECTION_STRING
)


def create_blob_sas_url(blob_name: str) -> str:
    """
    Generate a temporary SAS URL for downloading an image
    stored in Azure Blob Storage.
    """

    sas_token = generate_blob_sas(
        account_name=settings.AZURE_STORAGE_ACCOUNT_NAME,
        container_name=settings.AZURE_STORAGE_CONTAINER_NAME,
        blob_name=blob_name,
        account_key=blob_service_client.credential.account_key,
        permission=BlobSasPermissions(read=True),
        expiry=datetime.utcnow()
        + timedelta(seconds=settings.BLOB_URL_EXPIRE_SECONDS),
    )

    return (
        f"https://{settings.AZURE_STORAGE_ACCOUNT_NAME}.blob.core.windows.net/"
        f"{settings.AZURE_STORAGE_CONTAINER_NAME}/"
        f"{blob_name}?{sas_token}"
    )
