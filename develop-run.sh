#!/bin/sh

#Launches the container with the shell in other to test
docker run -it --rm -v $(pwd):$(pwd):z --name cci-php-dev circleci-php828-composer-deploy sh
