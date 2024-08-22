import logging

import azure.functions as func

health_bp = func.Blueprint()


@health_bp.route(route="health")
def health(req: func.HttpRequest):
    logging.info("Health endpoint called.")
    return func.HttpResponse(
        "This HTTP triggered function executed successfully and Azure function is healthy",
        status_code=200,
    )


# @health_bp.route(route="get_config")
# def ping(req: func.HttpRequest):
#      return func.HttpResponse(
#             status_code=200,
#         )
