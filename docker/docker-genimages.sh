#!/usr/bin/bash

# Generates docker images of running ssh servers on various distros

set -xue

for IMAGE in fedora ubuntu ; do
    docker pull $IMAGE
done

for IMAGE in fedora:20 ubuntu:12.10 ; do
    CONTAINER=tmp-${IMAGE//:/-}
    CONTAINER=${CONTAINER//./-}
    sed -e "s%\%SSHKEY\%%$(cat ~/.ssh/id_rsa.pub)%g" $(dirname $(realpath $0))/setup_container.sh | docker run -i -a stdin -a stdout -a stderr --name $CONTAINER $IMAGE /bin/bash -x
    docker commit -run='{"Cmd": ["/usr/sbin/sshd", "-D"]}' $CONTAINER derekh/${IMAGE//:/-}
    docker rm $CONTAINER
done
