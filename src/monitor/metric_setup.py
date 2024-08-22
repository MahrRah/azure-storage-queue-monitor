from typing import List

from azure.identity import DefaultAzureCredential
from azure.storage.queue import QueueClient
from opentelemetry.metrics import Meter
from opentelemetry.metrics._internal.instrument import Gauge

from monitor.monitor_settings import MonitorQueueInformation

default_credential = DefaultAzureCredential()


def create_azure_storage_queue_clients(
    monitoring_queues: List[MonitorQueueInformation | None],
) -> dict[str, QueueClient]:
    clients = {}
    for queue_info in monitoring_queues:
        credentials = queue_info.storage_account_key or default_credential
        client = QueueClient(
            queue_info.storage_account_url,
            queue_name=queue_info.queue_name,
            credential=credentials,
        )
        clients[f"{queue_info.queue_name}"] = client
    return clients


def create_metric_gauge(
    monitoring_queues: List[MonitorQueueInformation] | None, meter: Meter
) -> dict[str, Gauge]:
    gauges = {}
    for queue_info in monitoring_queues:
        gauge_name = get_queue_gauge_name(queue_info.queue_name)
        gauge_description = f"Message count in the {queue_info.queue_name}."
        gauge = meter.create_gauge(
            name=gauge_name, description=gauge_description, unit="messages"
        )
        gauges[gauge_name] = gauge
    return gauges


def get_queue_gauge_name(queue_name: str) -> str:
    return f"{queue_name}-length"
