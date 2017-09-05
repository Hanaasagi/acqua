#!/bin/bash

ARIA2_IMAGE_NAME="aria2"
WEB_IMAGE_NAME="aria2-web"
DATA_IMAGE_NAME="alpine:3.4"

port=

build() {
  (cd ./aria2 && docker build -t ${ARIA2_IMAGE_NAME} .)
  (cd ./web && docker build -t ${WEB_IMAGE_NAME}     .)
}

create_data_volume(){
  docker inspect aria2-data &> /dev/null

  if [[ "$?" == "1" ]]; then
    docker create --name aria2-data                            \
      -v /root/download/                                       \
      ${DATA_IMAGE_NAME}
  fi
}

start() {
  create_data_volume

  docker run -d --name aria2                                   \
    -p 0.0.0.0:6800:6800                                       \
    --volumes-from aria2-data                                  \
    ${ARIA2_IMAGE_NAME}

  docker run -d --name aria2-web                               \
    -p 0.0.0.0:${port[0]:-10023}:8888                          \
    -p 0.0.0.0:${port[1]:-10024}:80                            \
    --volumes-from aria2-data                                  \
    ${WEB_IMAGE_NAME}
}

stop() {
  docker stop  aria2 2>/dev/null
  docker rm -v aria2 2>/dev/null

  docker stop  aria2-web 2>/dev/null
  docker rm -v aria2-web 2>/dev/null
}


Action=$1

shift

while [ $# -gt 0 ]
do
    case $1 in
        --port | -p )
            port=($(tr "," " " <<< $2))
            shift    ;;
        -*)
            echo "Unknown option: $1" ;;
        *)
            break    ;;
    esac
    shift
done

case "$Action" in
  build   ) build    ;;
  start   ) start    ;;
  stop    ) stop     ;;
  *)
    echo "Usage: build | start [-p port1,port2] | stop";;
esac

exit 0
