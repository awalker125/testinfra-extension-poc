# Project variables

#local dev only
export ORG_NAME ?= localdev
export APPLICATION ?= some-app

export DOCKER_REGISTRY ?= localdev:443
DOCKER_REGISTRY_AUTH ?= localdev:443


MAKEFILE_DIR=$(dir $(firstword $(MAKEFILE_LIST)))
# Filenames
DOCKER_FILE := Dockerfile

#something for local dev
export COMMIT := changeme
export VERSION := latest


.PHONY: help build clean publish dev package test unit venv

help:
	@echo "This project assumes that an active Python virtualenv is present."
	@echo "The following make targets are available:"
	@echo "	 venv 	create a venv in the users home dir"
	@echo "	 dev 	install all deps for dev env"
	@echo "	 test	run all tests with coverage"
	@echo "	 build	the docker image"


venv:
	${INFO} "venv..."
	if [ -d ~/venv/ ]; then rm -rf ~/venv/*; fi
	virtualenv ~/venv
	. ~/venv/bin/activate
	
dev:
	${INFO} "dev..."
	pip install -r requirements-dev.txt

test:
	${INFO} "test..."
	pwd
	$(eval DOCKER_ID=$(shell sh -c "docker run -d $(DOCKER_REGISTRY)/$(ORG_NAME)/$(APPLICATION):$(VERSION) tail -f /dev/null"))
	py.test -v --host="docker://${DOCKER_ID}" tests

build:
	${INFO} "Building images..."
	docker build \
	--build-arg application=$(APPLICATION) \
	-t $(DOCKER_REGISTRY)/$(ORG_NAME)/$(APPLICATION):$(VERSION) \
	-f $(DOCKER_FILE) \
	.

clean:
	${INFO} "killing containers"
	@ docker ps -q -f label=com.github.awalker125.application=$(APPLICATION) | xargs -I ARGS docker kill ARGS
	${INFO} "deleting containers"
	@ docker ps -a -q -f label=com.github.awalker125.application=$(APPLICATION) | xargs -I ARGS docker rm ARGS
	${INFO} "Clean complete"

# Cosmetics
YELLOW := "\e[1;33m"
NC := "\e[0m"

# Shell Functions
INFO := @bash -c '\
  printf $(YELLOW); \
  echo "=> $$1"; \
  printf $(NC)' SOME_VALUE


