from azure.storage.queue import QueueServiceClient

CONNECTION_STRING = "AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;DefaultEndpointsProtocol=http;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;TableEndpoint=http://127.0.0.1:10002/devstoreaccount1;"
queues = [
    "demo-queue-1",
    "demo-queue-2",
]


def send_message(queue_name):
    queue_service_client = QueueServiceClient.from_connection_string(CONNECTION_STRING)
    queue_client = queue_service_client.get_queue_client(queue_name)

    message = "Hello, world!"
    queue_client.send_message(message)


if __name__ == "__main__":

    for queue in queues:
        send_message(queue)
