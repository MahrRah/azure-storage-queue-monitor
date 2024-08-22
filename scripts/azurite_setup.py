from azure.storage.queue import QueueServiceClient
from azure.core.exceptions import ResourceExistsError


CONNECTION_STRING = "AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;DefaultEndpointsProtocol=http;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;TableEndpoint=http://127.0.0.1:10002/devstoreaccount1;"


def create_queue(queue_name):
    queue_service_client = QueueServiceClient.from_connection_string(CONNECTION_STRING)
    queue_client = queue_service_client.get_queue_client(queue_name)

    try:
        queue_client.create_queue()
        print(f"Queue '{queue_name}' created successfully.")
    except ResourceExistsError as e:
        print(f"Queue '{queue_name}' already exist")


if __name__ == "__main__":
    queue_names = [
        "demo-queue-1",
        "demo-queue-2",
    ]
    for queue_name in queue_names:
        create_queue(queue_name)
