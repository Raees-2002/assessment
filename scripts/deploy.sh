#!/bin/bash
IMAGE=$1

CURRENT=$(docker ps --format '{{.Names}}' | grep assessment || true)

if [ "$CURRENT" == "assessment-blue" ]; then
  NEW="assessment-green"
  PORT=3001
else
  NEW="assessment-blue"
  PORT=3000
fi

docker run -d -p $PORT:3000 --name $NEW $IMAGE
sleep 5
curl -f http://localhost:$PORT/health || exit 1

sudo sed -i "s/3000/$PORT/" /etc/nginx/nginx.conf
sudo systemctl reload nginx

docker stop $CURRENT || true
docker rm $CURRENT || true

docker run -d -p 3000:3000 --name assessment $IMAGE