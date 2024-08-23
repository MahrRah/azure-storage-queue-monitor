import logging
import os

import azure.functions as func
from azure.monitor.opentelemetry import configure_azure_monitor

from monitor.monitoring_job import queue_metrics_monitor_blueprint
from routes.config import config_bp
from routes.health import health_bp

# root_logger = logging.getLogger()
# for handlers in root_logger.handlers[:]:
#     root_logger.removeHandler(handlers)

logging.getLogger("azure.core").setLevel(logging.WARNING)


configure_azure_monitor(
    connection_string=os.environ["APPLICATIONINSIGHTS_CONNECTION_STRING"]
)

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)
app.register_functions(health_bp)
app.register_functions(config_bp)
app.register_functions(queue_metrics_monitor_blueprint)
