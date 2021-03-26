FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt install git ca-certificates --no-install-recommends -y
RUN dpkg-reconfigure dash
