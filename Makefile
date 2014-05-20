#binaries
NODEWEBKIT_BIN = ./node_modules/.bin/nodewebkit
BOWER_BIN =  ./node_modules/.bin/bower
GULP_BIN = ./node_modules/.bin/gulp

watch:
	$(GULP_BIN) watch

build:
	$(GULP_BIN) build

install:
	npm install
	$(BOWER_BIN) install
	$(GULP_BIN) build

start:
	$(NODEWEBKIT_BIN) .

.PHONY: build watch