#binaries
COFFEE_BIN = ./node_modules/.bin/coffee
NODEWEBKIT_BIN = ./node_modules/.bin/nodewebkit
BOWER_BIN =  ./node_modules/.bin/bower

watch: 
	$(COFFEE_BIN) -cwo js coffee

build:
	$(COFFEE_BIN) -co js coffee

install:
	npm install
	$(BOWER_BIN) install

start:
	$(NODEWEBKIT_BIN) .

.PHONY: build