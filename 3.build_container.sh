sudo docker build --no-cache --pull -t $CONTAINER_NAME --build-arg SERVER_ARCH=$(uname -m) .
