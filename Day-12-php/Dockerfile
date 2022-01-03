FROM ubuntu:20.04
RUN apt-get update && apt-get upgrade -y

# Settings needed for tzdata
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London

# Install php
RUN apt-get install -y --no-install-recommends php php-ds
