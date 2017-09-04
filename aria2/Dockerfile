FROM alpine:3.4

WORKDIR /home/

COPY aria2.conf ./aria2.conf

RUN apk update && \
    apk add --no-cache aria2

EXPOSE 6800

ENTRYPOINT ["aria2c", "--conf-path=./aria2.conf"]
