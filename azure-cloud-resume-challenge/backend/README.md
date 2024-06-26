# CRC backend CICD statuses

* Build azure function and Deploy to Staging Environment:

[![Build](https://github.com/colossus06/crc-backend/actions/workflows/backend.stage.main.yml/badge.svg)](https://github.com/colossus06/crc-backend/actions/workflows/backend.stage.main.yml)

* Python/Terraform Test and Deploy


[![Test-Deploy-Cypress](https://github.com/colossus06/crc-backend/actions/workflows/tf-unit-tests.yml/badge.svg)](https://github.com/colossus06/crc-backend/actions/workflows/tf-unit-tests.yml)

* Download Build Artifact and and Deploy to Prod Environment:

[![Prod deploy](https://github.com/colossus06/crc-backend/actions/workflows/backend.prod.main.yml/badge.svg)](https://github.com/colossus06/crc-backend/actions/workflows/backend.prod.main.yml)

* Cypress Azure Function Reports:

https://colossus06.github.io/crc-backend/


![image](https://github.com/colossus06/crc-backend/assets/96833570/54501a68-2acb-477c-92f9-b0401adfedec)


![image](https://github.com/colossus06/crc-backend/assets/96833570/a126a3fa-6952-4ffb-8250-ceec46bb7b63)


![image](https://github.com/colossus06/crc-frontend/assets/96833570/ec3b8474-a2cc-4780-9c56-f2063484415f)


## Validation




[validation-2-crc.webm](https://github.com/colossus06/crc-backend/assets/96833570/3b5ceafc-3c92-447a-9aec-ad6790ef6027)



Visit the Resume Site: https://crctopcug.devtechops.dev/

## Summary

Building my resume website from the ground up with using utilizing a wide variety of Microsoft Azure's Cloud services such as Azure CosmosDB Table API, Azure Functions, Azure SDK, Azure Blob Storage, Azure CDN, Azure DNS zones.

Other tools used for automation and CI CD are Cypress, Github Actions, bicep and Terraform.

## Cloud Resume Challenge on Azure

Building my resume website from the ground up with using utilizing a wide variety of Microsoft Azure's Cloud services such as the following:

* Azure CosmosDB Table API serverless mode to store a visitor count value.
* Azure Functions with an HTTP trigger to communicate with CosmosDB from the Javascript code.
* Azure SDK to interact with the database and update counter value.
* Azure Blob Storage for Static Website for serving HTML, CSS, JavaScript, and image files
* Azure CDN to secure version of HTTP, enable custom domain and to cache the content for low latency.
* Azure DNS zones to create and delegate `crctopcug` subdomain point to static website.


Other Tools for Automation/Test/CI-CD:

* Cypress for smoke tests
* Github Actions to update back and frontend on code changes.
* Postman to test API.
* Javascript to display a counter value in main page.
* HTML, CSS, JavaScript.

IaaC

* Terraform to control the state of the resources.


