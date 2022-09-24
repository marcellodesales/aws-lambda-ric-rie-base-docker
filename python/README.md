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

## Dockerfile

* This includes a generic version of the python version
* Specify a docker image that contains python, pip, pipenv, etc

1. The interface is that you need to use these base images and add the functions
under the directory `/functions` during the build process.

2. Create a base image of the emulator image, also adding the functions
under the directory `/functions` during the build process.

### RIC

* Provide the CMD configuration as a parameter to run a given function
  * Provide the values for the base image as a docker image that can build python code
  * This image must create functions and place them into the `/functions` dir
* This is the image to upload to AWS ECR.

```dockerfile
ARG BASE_IMAGE_BUILD
FROM ${BASE_IMAGE_BUILD} AS aws-lambda-functions-custom-runtime-python

COPY --from=aws-lambda-functions-build /functions /functions

# Just the regular functions dir
WORKDIR /functions

ENTRYPOINT [ "python", "-m", "awslambdaric" ]
```

### RIE

* This has the basic settings to run a python image locally with the emulator
* The Base Image Emulator is the image built by this repo

```dockerfile
# https://www.slim.ai/blog/containerized-lambda-in-python-language.html
# https://stackoverflow.com/questions/71127088/facing-issue-keyerror-aws-lambda-runtime-api
# https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html
ARG BASE_IMAGE_EMULATOR
ARG BASE_IMAGE_BUILD
FROM ${BASE_IMAGE_EMULATOR} AS local-lambda-functions-emulator

COPY --from=aws-lambda-functions-build /functions /functions

# Default example from the docker image. Make sure to provide the command when running the image
CMD ["python", "-m", "awslambdaric", "supercash/platform/services/tickets/status.lambdaHandler"]
```

# Build

* Build all images to be used in your projects!

```console
docker compose build
```

# Running Locally

* Just run the Emulator version of the image

