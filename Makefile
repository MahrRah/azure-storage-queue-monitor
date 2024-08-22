
include .env
export

all: start

start:
	cd src && poetry run func host start --port 7071 --verbose

format:
	black . 
	isort . 