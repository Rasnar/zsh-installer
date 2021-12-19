FROM ubuntu:20.04
RUN apt-get update && apt-get install -y \
   curl \
   git
WORKDIR /data
CMD bash