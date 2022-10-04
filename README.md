# ☁️ AWS Lambda RIC & RIE base docker images 🐳

The images to run a Serverless in AWS and locally with an Emulator.

# 🎌 Languages

> **NOTE**: Different languages require different handlers.

* [x] [python](./python)
* [ ] nodejs
* [ ] golang
* [ ] java

# 🔧 Generic Config

* Create a new `docker-compose.yaml`
  * It points to this repo at a given version `v0.1.0`
* Choose a version of the language by choosing the path to the `dockerfile`
  * Default values will be used from the Dockerfile image used.

```yaml
version: "3.8"

x-aws-lambda-build-params: &aws-lambda-build-params
  # Loading the context from a public git repo as this is Open-source
  context: https://github.com/marcellodesales/aws-lambda-ric-rie-base-docker.git#${RICRIE_DOCKERFILE_VERSION}
  dockerfile: python/Dockerfile
  args:
    BASE_IMAGE_BUILD: ${BASE_IMAGE_BUILD}

services:

  # Base Runtime Container
  # Base implementation of https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html for python code
  aws-lambda-ric-runtime-python:
    image: ${AWS_RIC_IMAGE}
    build: 
      <<: [ *aws-lambda-build-params ]
      target: custom-aws-lambda-ric-runtime-base-python
      cache_from:
        - ${AWS_RIC_IMAGE}

  # Base Runtime Interface Emulator
  # https://docs.aws.amazon.com/lambda/latest/dg/images-test.html#images-test-limitations
  aws-lambda-rie-runtime-emulator-python:
    image: ${AWS_RIE_IMAGE}
    build:
      <<: [ *aws-lambda-build-params ]
      target: custom-aws-lambda-rie-runtime-base-python
      cache_from:
        - ${AWS_RIE_IMAGE}
```

* Provide the variables above in a `.env` file

```properties
# A release version of this repo
RICRIE_DOCKERFILE_VERSION=v0.1.0

# The base image that can build the RIC images
BASE_IMAGE_BUILD=artifactory.company.com/build/python:3.9-alpine

# Tag for the built implementation of https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html for python code
AWS_RIC_IMAGE=artifactory.company.com/runtime/aws-lambda-ric:python-3.9

# The for the built implementation of https://docs.aws.amazon.com/lambda/latest/dg/images-test.html#images-test-limitations
AWS_RIE_IMAGE=artifactory.company.com/runtime/aws-lambda-rie-emulator:python-3.9
```

# 🏗️ Build

* Profit by executing the build
  * Notice that it does a git pull from the given version

```console
$ docker compose build
[+] Building 15.7s (12/12) FINISHED                                                                                                                                                                                                                                                                                                                                            
 => CACHED [artifactory.company.com/runtime/aws-lambda-rie-emulator:python-3.9 internal] load git source https://github.com/marcellodesales/aws-lambda-ric-rie-base-docker.git#v0.1.0
...
...  
```
