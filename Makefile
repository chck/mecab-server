GCLOUD_PROJECT:=<YOUR_GCLOUD_PROJECT_ID>
IMAGE:=mecab-server
DATE:=$(shell date +"%Y-%m-%d-%H%M%S")

.PHONY: all
all: help

.PHONY: lint ## Run linter
lint:
	flake8 .

.PHONY: fix ## Fix code style based on pep8
fix:
	autopep8 -ivr .

.PHONY: build ## Build image
build:
	docker build . -t $(IMAGE):$(DATE) -t $(IMAGE):latest

.PHONY: dev ## Run server for development
dev:
	docker run --rm -v $(PWD):/app -e PORT=80 -p 8080:80 mecab-server

.PHONY: deploy ## Deploy on Google App Engine
deploy:
	gcloud config set project $(GCLOUD_PROJECT)
	gcloud app deploy --quiet
	gcloud app browse -s $(IMAGE)

.PHONY: help ## View help
help:
	@grep -E '^.PHONY: [a-zA-Z_-]+.*?## .*$$' $(MAKEFILE_LIST) | sed 's/^.PHONY: //g' | awk 'BEGIN {FS = "## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
