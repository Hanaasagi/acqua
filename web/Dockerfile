FROM alpine:3.4

COPY ./init.sh /root/init.sh

RUN apk update && \
    apk add --no-cache git nodejs darkhttpd && \
    cd /root/ && \
    git clone https://github.com/ziahamza/webui-aria2.git

EXPOSE 80
EXPOSE 8888

VOLUME ["/root/download"]

ENTRYPOINT ["sh", "/root/init.sh"]
