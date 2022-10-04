# Custom lambda runtime image to serve functions based on 
# The AWS Runtime API interface. This version is for python
# https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html

ARG BASE_IMAGE_BUILD
FROM ${BASE_IMAGE_BUILD} AS custom-aws-lambda-ric-runtime-base-python

# All all dependencies to install the
# https://www.slim.ai/blog/containerized-lambda-in-python-language.html
# autoreconf: not found
# Can't exec "aclocal"
#  Can't exec "libtoolize"
# https://github.com/ddopson/node-segfault-handler/issues/70#issuecomment-774479875
# fatal error: execinfo.h: No such file or directory
RUN apk update && apk add cmake make unzip g++ autoconf automake libtool libexecinfo-dev libexecinfo

# Just the regular functions dir
WORKDIR /functions

# Just install the AWS Lambda interface for Python (opens new window)
# https://www.slim.ai/blog/containerized-lambda-in-python-language.html
# https://aripalo.com/blog/2020/aws-lambda-container-image-support/
# https://pypi.org/project/awslambdaric/
RUN pip install --target /functions awslambdaric

# https://www.slim.ai/blog/containerized-lambda-in-python-language.html
# https://stackoverflow.com/questions/71127088/facing-issue-keyerror-aws-lambda-runtime-api
# https://docs.aws.amazon.com/lambda/latest/dg/runtimes-api.html
ARG BASE_IMAGE_BUILD
FROM ${BASE_IMAGE_BUILD} AS custom-aws-lambda-rie-runtime-base-python

WORKDIR /aws-lambda

RUN curl -Lo /aws-lambda/aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie && \
    chmod +x /aws-lambda/aws-lambda-rie

# Just the regular functions dir switched because
WORKDIR /functions

# ATTENTION: YOU MUST PLACE FUNCTIONS IN THE /functions dir

# The port number in which the emulator runs on
EXPOSE 8080
ENTRYPOINT ["/aws-lambda/aws-lambda-rie"]

# Default example from the docker image. Make sure to provide the command when running the image
# That is, the directory /functions/supercash/platform/services/tickets contains ticket_status.py with function "lambdaHandler"
#CMD ["python", "-m", "awslambdaric", "supercash/platform/services/tickets/ticket_status.lambdaHandler"]
