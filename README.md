# azure-storage-queue-monitor

## Description

This is a small sample to monitor the length of Azure storage queues and emit the length as a metric to alerts on.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running Locally](#running-locally)
- [Infrastructure](#infrastructure)
- [Deployment](#deployment)

## Pre-requisits

- Python 3.11
- Azure subscription
- Azurite 
- Azure Function Core Tools
- App Insights (if you don't have one yu can use the Infra section to create it amongst the other infra)
- Terraform

## Installation

The make file has a simple command called `setup` that will get you going 🚀

```bash 
make setup
```
It will  do the following things:

1. Create a virtual environments `.venv`
1. Activate said `.venv`
1. Install all dependencies using  `poetry`
1. Create the Azurite demo queues

> Note: Important make sure you have started Azurite up!

## Running Locally

### 1. Environment variables

Copy the `local.settings.sample.json` in the `src/` directory to `local.settings.json`.
Replace the placeholders with your Application Insights Connection string and the list of queues to be monitored.

### 2. Run

To run it use

```bash
make start
```

This will navigate into the `src/` folder and run `func host start`

## Infrastructure

To deploy the solution onto Azure the folder `infra` contains the needed `Terraform` script to create all necessary resources.


Navigate to the `infra`.

```bash
terraform init
terraform plan
```

This will show you the changes that Terraform will make to your infrastructure. If the plan looks good, run the following command to apply the changes:

```bash
terraform apply
```

## Deployment

Instructions on how to deploy the project to a live system.
