
-include .env
export
.SHELLFLAGS = -e

all: start

setup:
	python -m venv .venv && poetry install && python  scripts/azurite_setup.py

send-message:
	python  scripts/send_message.py

start:
	cd src && poetry run func host start --port 7071 --verbose

format:
	black . 
	isort . 