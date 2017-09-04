FROM alpine:3.4

RUN apk update && \
    apk add --no-cache git nodejs && \
    git clone https://github.com/ziahamza/webui-aria2.git

EXPOSE 8888

WORKDIR /webui-aria2/

CMD ["node", "node-server.js"]
