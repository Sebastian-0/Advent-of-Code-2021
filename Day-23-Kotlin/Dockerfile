FROM ubuntu:20.04
RUN apt-get update && apt-get upgrade -y

# Install kotlin
RUN apt-get install -y --no-install-recommends default-jdk
RUN apt-get install -y --no-install-recommends wget
RUN apt-get install -y --no-install-recommends unzip

RUN wget https://github.com/JetBrains/kotlin/releases/download/v1.7.21/kotlin-compiler-1.7.21.zip && \    
    unzip kotlin-compiler-1.7.21.zip

ENV PATH="$PATH:$PWD/kotlinc/bin"
