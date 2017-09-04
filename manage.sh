ARIA2_IMAGE_NAME="aria2"
WEBUI_IMAGE_NAME="aria2-webui"
DATA_IMAGE_NAME="aria2-data"

build() {
    (cd ./aria2 && docker build -t ${ARIA2_IMAGE_NAME} .)
    (cd ./webui && docker build -t ${WEBUI_IMAGE_NAME} .)
    (cd ./data  && docker build -t ${DATA_IMAGE_NAME}  .)
}

create_data_volume(){
    #docker create -v /download-data --name data alpine:3.4
    docker run -d --name aria2-data \
        -v /root/download/          \
        -p 0.0.0.0:10024:80         \
        ${DATA_IMAGE_NAME}
}

start() {
    create_data_volume

    docker run -d --name aria2 \
        -p 0.0.0.0:6800:6800   \
        --volumes-from aria2-data    \
        ${ARIA2_IMAGE_NAME}

    docker run -d --name aria2-webui \
        -p 0.0.0.0:10023:8888         \
        --volumes-from aria2-data          \
        ${WEBUI_IMAGE_NAME}
}

stop() {
    docker stop  aria2 2>/dev/null
    docker rm -v aria2 2>/dev/null

    docker stop  aria2-webui 2>/dev/null
    docker rm -v aria2-webui 2>/dev/null
}

Action=$1

shift

case "$Action" in
  build   ) build    ;;
  start   ) start    ;;
  stop    ) stop     ;;
  *)
    echo "Usage: build | start | stop";;
esac

exit 0
