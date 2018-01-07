#!/bin/bash
set -e
VERSION=$1

if [ -z ${VERSION} ]
then
    echo "Packages an arbitrary Factorio release."
    echo
    echo "Usage: ./release.sh 0.14.15"
    exit 1
fi

LOCAL_FILENAME=factorio_headless_x64_${VERSION}.tar.xz
DOWNLOAD_URL=https://www.factorio.com/get-download/${VERSION}/headless/linux64

# Attempt to grab the requested release.

if [ ! -f $LOCAL_FILENAME ] 
then
    wget  ${DOWNLOAD_URL} -O ${LOCAL_FILENAME} || rm -f ${LOCAL_FILENAME}
    if [ $? -ne 0 ]
    then
        echo "Found errors while downloading the asset."
        exit 1
    fi
fi


docker build --build-arg factorio_version=${VERSION} \
    -t dbarranco/factorio:${VERSION} .
# Run/Test the container
docker run --rm -it dbarranco/factorio:${VERSION}

while true; do
    read -p "Publish the built image? (y/n) " yn
    case $yn in
        [Yy]* )
            docker push dbarranco/factorio:${VERSION}
            break;;
        [Nn]* )
            exit;;
        * )
            echo "Please answer y or n.";;
    esac
done
