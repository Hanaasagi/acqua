#!/bin/bash

ARIA2_IMAGE_NAME="aria2"
WEB_IMAGE_NAME="aria2-web"
DATA_IMAGE_NAME="alpine:3.4"

port=

build() {
  (cd ./aria2 && docker build -t ${ARIA2_IMAGE_NAME} .)
  (cd ./web && docker build -t ${WEB_IMAGE_NAME}     .)
}

create_data_volume() {
  docker inspect aria2-data &> /dev/null

  if [[ "$?" == "1" ]]; then
    docker create --name aria2-data                            \
      -v /root/download/                                       \
      ${DATA_IMAGE_NAME}
  fi
}

gen_cert() {
  openssl req -x509 -newkey rsa:4096                           \
    -keyout ./aria2/private-key.pem                            \
    -out ./aria2/cert.pem -days 365 -nodes -subj "/"
}

start() {
  create_data_volume

  docker run -d --name aria2                                   \
    -p 0.0.0.0:6800:6800                                       \
    -v $PWD/aria2/:/root/aria2/                                \
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

clean() {
  volume=$(docker inspect                                      \
             -f '{{with index .Mounts 0}}{{.Name}}{{end}}'     \
             aria2-data)

  docker rm aria2-data 2>/dev/null
  docker volume rm ${volume}
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
  gen-cert) gen_cert ;;
  start   ) start    ;;
  stop    ) stop     ;;
  clean   ) clean    ;;
  *)
    echo "Usage: build | gen-cert | start [-p port1,port2] | stop | clean";;
esac

exit 0
