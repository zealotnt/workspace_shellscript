#!/bin/bash

# [Origin](https://gist.github.com/jrenggli/dc98b8b27584f7abe466)

DOCKER_BACKUP_LIST_FILE=docker-backup-images.txt
rm -f $DOCKER_BACKUP_LIST_FILE
touch $DOCKER_BACKUP_LIST_FILE
docker images | tail -n +2 | grep -v "none" | awk '{printf("%s:%s\n", $1, $2)}' | while read IMAGE; do
	echo $IMAGE
	filename="${IMAGE//\//-}"
	filename="${filename//:/-}.docker-image.gz"
	docker save ${IMAGE} | pigz --stdout --best > $filename
	echo ${IMAGE} >> $DOCKER_BACKUP_LIST_FILE
done
