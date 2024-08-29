
-include .env
export
.SHELLFLAGS = -e

all: start

setup:
	python -m venv .venv && poetry install && python  scripts/azurite_setup.py

send-message:
	python scripts/send_messages.py --num_messages 5

start:
	cd src && poetry run func host start --port 7071 --verbose

build-push:
	cd src && docker build -t storage-queue-monitor:latest . && docker tag storage-queue-monitor qmsampleacr.azurecr.io/storage-queue-monitor && az acr login --name qmsampleacr && docker push qmsampleacr.azurecr.io/storage-queue-monitor:latest

run-container:
	cd src && docker run --env-file ./.env storage-queue-monitor:latest 

format:
	black . 
	isort . 