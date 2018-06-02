
include env_make

NS       = bodsch

REPO     = docker-nginx
NAME     = nginx
INSTANCE = default

BUILD_DATE    := $(shell date +%Y-%m-%d)
BUILD_VERSION := $(shell date +%y%m)
NGINX_VERSION ?= $(shell curl \
  --silent \
  --location \
  --retry 3 \
  http://dl-cdn.alpinelinux.org/alpine/latest-stable/main/x86_64/APKINDEX.tar.gz | \
  gunzip | \
  strings | \
  grep -A1 "P:nginx" | \
  tail -n1 | \
  cut -d ':' -f2 | \
  cut -d '-' -f1)


.PHONY: build push shell run start stop rm release

default: build

params:
	@echo ""
	@echo " NGINX_VERSION: $(NGINX_VERSION)"
	@echo " BUILD_DATE   : $(BUILD_DATE)"
	@echo ""

build:
	docker build \
		--force-rm \
		--compress \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg BUILD_VERSION=$(BUILD_VERSION) \
		--build-arg NGINX_VERSION=$(NGINX_VERSION) \
		--tag $(NS)/$(REPO):$(NGINX_VERSION) .

clean:
	docker rmi \
		--force \
		$(NS)/$(REPO):$(NGINX_VERSION)

history:
	docker history \
		$(NS)/$(REPO):$(NGINX_VERSION)

push:
	docker push \
		$(NS)/$(REPO):$(NGINX_VERSION)

shell:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		--interactive \
		--tty \
		--entrypoint '' \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(NGINX_VERSION) \
		/bin/sh

run:
	docker run \
		--rm \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(NGINX_VERSION)

exec:
	docker exec \
		--interactive \
		--tty \
		$(NAME)-$(INSTANCE) \
		/bin/sh

start:
	docker run \
		--detach \
		--name $(NAME)-$(INSTANCE) \
		$(PORTS) \
		$(VOLUMES) \
		$(ENV) \
		$(NS)/$(REPO):$(NGINX_VERSION)

stop:
	docker stop \
		$(NAME)-$(INSTANCE)

rm:
	docker rm \
		$(NAME)-$(INSTANCE)

release: build
	make push -e VERSION=$(NGINX_VERSION)

default: build


