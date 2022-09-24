# Dockerized Lambda RIC and RIE for Python

* A generic implementation for these docker images for Lambda

# Config

* Create a .env with the env vars

```properties
# The base image that can build the RIC images
BASE_IMAGE_BUILD=user/build-python:3.9-alpine

# Tag for the built implementation of https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html for python code
AWS_RIC_IMAGE=user/aws-lambda-ric:python-3.9

# The for the built implementation of https://docs.aws.amazon.com/lambda/latest/dg/images-test.html#images-test-limitations
AWS_RIE_IMAGE=user/aws-lambda-rie-emulator:python-3.9
```

# Dockerfile

* This includes a generic version of the python version
* Specify a docker image that contains python, pip, pipenv, etc

1. The interface is that you need to use these base images and add the functions
under the directory `/functions` during the build process.

2. Create a base image of the emulator image, also adding the functions
under the directory `/functions` during the build process.

## RIC

* Provide the CMD configuration as a parameter to run a given function
* This is the image to upload to AWS ECR.

## RIE

* This has the basic settings to run a python image locally with the emulator

# Build

* Build all images to be used in your projects!

```console
docker compose build
```
