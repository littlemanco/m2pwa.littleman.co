# Task runner

.PHONY: help build

.DEFAULT_GOAL := help

SHELL := /bin/bash

# http://stackoverflow.com/questions/1404796/how-to-get-the-latest-tag-name-in-current-branch-in-git
APP_VERSION := $(shell git describe --abbrev=0)

PROJECT_NS   := m2pwa-littleman-co
CONTAINER_NS := m2pwa-littleman-co
GIT_HASH     := $(shell git rev-parse --short HEAD)

GCR_NAMESPACE := littleman-co

ANSI_TITLE        := '\e[1;32m'
ANSI_CMD          := '\e[0;32m'
ANSI_TITLE        := '\e[0;33m'
ANSI_SUBTITLE     := '\e[0;37m'
ANSI_WARNING      := '\e[1;31m'
ANSI_OFF          := '\e[0m'

PATH_DOCS                := $(shell pwd)/docs
PATH_BUILD_CONFIGURATION := $(shell pwd)/build

TIMESTAMP := $(shell date "+%s")

help: ## Show this menu
	@echo -e $(ANSI_TITLE)m2pwa.littleman.co$(ANSI_OFF)$(ANSI_SUBTITLE)" - A demonstration of a progressive web app with Magento 2"$(ANSI_OFF)
	@echo -e $(ANSI_TITLE)Commands:$(ANSI_OFF)
	@grep -E '^[a-zA-Z_-%]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "    \033[32m%-30s\033[0m %s\n", $$1, $$2}'

build-frontend-application: ## Builds the polymer application
	cd frontend && bower install
	cd frontend && polymer build

build-frontend-webserver: ## Builds the webserver container
	docker build -f build/docker/nginx/Dockerfile -t ${CONTAINER_NS}-frontend-webserver:${APP_VERSION} .

push-frontend: ## Pushes the webserver container to the gcr bucket
	docker tag ${CONTAINER_NS}-frontend-webserver:${APP_VERSION} gcr.io/${GCR_NAMESPACE}/${CONTAINER_NS}-frontend-webserver:${APP_VERSION}
	docker push gcr.io/${GCR_NAMESPACE}/${CONTAINER_NS}-frontend-webserver:${APP_VERSION}

deploy-frontend-webserver: ## Updates kubernetes to request the current version of the application
	sed "s/{{ APP_VERSION }}/${APP_VERSION}/" build/kubernetes/* | kubectl apply -f -

clean: ## Delete generated files
	- rm -rf frontend/build

do-everything: ## A crap task that means "Rebuild everything from scratch"
	make build-frontend-application
	make build-frontend-webserver
	make push-frontend
