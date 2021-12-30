FROM ubuntu:20.04
RUN apt-get update && apt-get upgrade -y

# Install R
RUN apt-get install -y --no-install-recommends r-base

# Install magrittr
RUN apt-get install -y --no-install-recommends make gcc libc-dev
RUN R -e "install.packages('magrittr')"
