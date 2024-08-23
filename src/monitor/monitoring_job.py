import logging

import azure.functions as func
from opentelemetry.metrics import get_meter_provider

from .metric_setup import (create_azure_storage_queue_clients,
                           create_metric_gauge, get_queue_gauge_name)
from .monitor_settings import MonitorSettings

queue_metrics_monitor_blueprint = func.Blueprint()

logger = logging.getLogger(__name__)

METER_NAME = "storage-account-queue-meter"
settings = MonitorSettings()

meter = get_meter_provider().get_meter(METER_NAME)
gauges = create_metric_gauge(settings.MONITORED_QUEUES, meter)
clients = create_azure_storage_queue_clients(settings.MONITORED_QUEUES)


@queue_metrics_monitor_blueprint.timer_trigger(
    schedule=settings.MONITORING_SCHEDULE_CRON, arg_name="timer", run_on_startup=False
)
def storage_queue_monitor_job(timer: func.TimerRequest) -> None:
    if timer.past_due:
        logger.info("Queue monitor triggered late. Metrics might be delayed")

    for queue_info in settings.MONITORED_QUEUES:
        client = clients[queue_info.queue_name]

        message_count = None
        try:
            properties = client.get_queue_properties()
            message_count = properties.approximate_message_count
        except Exception as e:
            logger.exception(e)

        if message_count is not None:
            gauge_name = get_queue_gauge_name(queue_info.queue_name)
            gauges[gauge_name].set(message_count)
        else:
            logger.warning(
                "Message count for queue %s in storage account with url %s could not be retrieved.",
                queue_info.queue_name,
                queue_info.storage_account_url,
            )
