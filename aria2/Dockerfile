FROM alpine:3.4


RUN apk update && \
    apk add --no-cache aria2

EXPOSE 6800

ENTRYPOINT ["aria2c", "--conf-path=/root/aria2/aria2.conf"]
