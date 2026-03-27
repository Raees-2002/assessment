#!/bin/bash

docker pull $IMAGE

docker stop assessment || true
docker rm assessment || true

docker run -d -p 3000:3000 --name assessment $IMAGE