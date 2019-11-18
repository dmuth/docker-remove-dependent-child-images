#!/bin/bash
#
# Build our test docker containres
#

# Errors are fatal
set -e

docker build -t test_main .

docker build -t test_main_child_1 -f ./Dockerfile-child-1 .
docker build -t test_main_child_2 -f ./Dockerfile-child-1 .
docker build -t test_main_child_3 -f ./Dockerfile-child-1 .

docker build -t test_main_child_1_1 -f ./Dockerfile-child-1-1 .
docker build -t test_main_child_1_2 -f ./Dockerfile-child-1-1 .

IMAGE=$(docker images | grep "test_main " | awk '{print $3}')

echo "# "
echo "# The Main Docker image is: ${IMAGE}"
echo "# "

echo "# Running Alpine so we'll have a stopped container for testing..."
docker run alpine

echo "# Now removing that image..."


./docker-remove-image ${IMAGE}

echo "# Test complete!"

