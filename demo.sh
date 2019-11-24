#!/bin/bash
#
# Build a single line of containers.
#

# Errors are fatal
set -e

#
# ANSI codes for printing out different colors.
#
RED="\033[0;31m"
GREEN="\033[0;32m"
NC="\033[0m"

function pass() {
	printf "[ ${GREEN}PASS${NC} ] "
}

function fail() {
	printf "[ ${RED}FAIL${NC} ] "
}


#
# Check the value of the first parameter, which should be a return value.
#
function check_retval() {

	VAL=$1
	MESSAGE=$2

	if test ${VAL} != 0
	then
		fail
		echo "Previous command had exit status of ${VAL}"
		exit $VAL

	else
		pass
		echo $MESSAGE

	fi

} # End of check_retval()


docker build -t test_main .
docker build -t test_main_child_1 -f ./Dockerfile-child-1 .
docker build -t test_main_child_1_1 -f ./Dockerfile-child-1-1 .

IMAGE=$(docker images | grep "test_main " | awk '{print $3}')

#docker rmi ${IMAGE} # DEBUG: Test breaking the script

echo "# "
echo "# The Main Docker image is: ${IMAGE}"
echo "# "

echo "# Running Alpine so we'll have a stopped container for testing..."
set +e
docker run alpine
check_retval $? "Alpine container ran successfully!"
set -e

echo "# Current images: "
docker images | grep "test_main" | sort

echo
echo "##### ##### ##### ##### ##### ##### ##### ##### "
echo

set +e
./docker-remove-image ${IMAGE}
check_retval $? "Root image removed successfully!"
set -e

pass 
echo "Test complete!"



