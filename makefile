CURRENT_DIR = ${CURDIR}
PACKAGE_BIN = node_modules/.bin
COMPOSER_BIN = vendor/bin
SRC_DIR = $(CURRENT_DIR)/app/client
PRODUCTION_DIR = $(CURRENT_DIR)/public
WEBAPP_DIR = $(CURRENT_DIR)/webapp

default: help
docker-build: ## Build docker files
	./.docker/build.sh
docker-which: ## Check lastest docker version
	cat ./.docker/build/public/release-id.txt
help: ## Display a list of commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
