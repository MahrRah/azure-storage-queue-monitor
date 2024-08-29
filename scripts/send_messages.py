import argparse
import random
import time
from azure.storage.queue import QueueServiceClient

CONNECTION_STRING = "AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;DefaultEndpointsProtocol=http;BlobEndpoint=http://127.0.0.1:10000/devstoreaccount1;QueueEndpoint=http://127.0.0.1:10001/devstoreaccount1;TableEndpoint=http://127.0.0.1:10002/devstoreaccount1;"
queues = [
    "demo-queue-1",
    "demo-queue-2",
]


def send_message(queue_name, message):
    queue_service_client = QueueServiceClient.from_connection_string(CONNECTION_STRING)
    queue_client = queue_service_client.get_queue_client(queue_name)
    queue_client.send_message(message)
    print(f"Sent message to {queue_name}: {message}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Send messages to Azure Queue Storage.")
    parser.add_argument("--num_messages", type=int, default=1, help="Number of messages to send.")
    
    args = parser.parse_args()

    for _ in range(args.num_messages):
        for queue in queues:
            send_message(queue, "Hello, world!")
        
        # Wait for a random interval between 1 and 10 minutes before sending the next set of messages
        interval = random.randint(60, 600)
        print(f"Waiting for {interval//60} minutes and {interval%60} seconds.")
        time.sleep(interval)
