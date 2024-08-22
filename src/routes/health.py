import logging

import azure.functions as func

from settings import MonitorSettings

health_bp = func.Blueprint()


@health_bp.route(route="health")
def health(req: func.HttpRequest):
    logging.info("Health endpoint called.")
    return func.HttpResponse(
        "This HTTP triggered function executed successfully and Azure function is healthy",
        status_code=200,
    )


@health_bp.route(route="get_config")
def ping(req: func.HttpRequest):
    try:
        settings = MonitorSettings()
        return func.HttpResponse(
            str(settings.MONITORED_QUEUES),
            status_code=200,
        )
    except Exception as e:
        return func.HttpResponse(
            e,
            status_code=500,
        )
