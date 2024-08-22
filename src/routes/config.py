import logging

import azure.functions as func

from monitor.monitor_settings import MonitorSettings

config_bp = func.Blueprint()

settings = MonitorSettings()


@config_bp.route(route="configuration")
def get_config(req: func.HttpRequest):
    try:
        return func.HttpResponse(
            str(settings.MONITORED_QUEUES),
            status_code=200,
        )
    except Exception as e:
        return func.HttpResponse(
            e,
            status_code=500,
        )
