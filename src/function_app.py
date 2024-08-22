import azure.functions as func
from azure.monitor.opentelemetry import configure_azure_monitor

from monitor.monitoring_job import queue_metrics_monitor_blueprint
from routes.config import config_bp
from routes.health import health_bp

# Configure OpenTelemetry to use Azure Monitor with the
# APPLICATIONINSIGHTS_CONNECTION_STRING environment variable.
configure_azure_monitor()

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)
app.register_functions(health_bp)
app.register_functions(config_bp)
app.register_functions(queue_metrics_monitor_blueprint)
