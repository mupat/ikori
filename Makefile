#binaries
NODEWEBKIT_BIN = ./node_modules/.bin/nodewebkit
BOWER_BIN =  ./node_modules/.bin/bower
COFFEE_BIN = ./node_modules/.bin/coffee
LESS_BIN = ./node_modules/.bin/lessc
KCKR_BIN = ./node_modules/.bin/kckr

#paths for public folder
PUBLIC = public/
PUBLIC_JS = $(PUBLIC)js
PUBLIC_CSS = $(PUBLIC)css/style.css

#paths for source files
COFFEE = coffee/
LESS = less/

LESS_CMD = $(LESS_BIN) $(LESS)main.less > $(PUBLIC_CSS)

watch: create
	$(COFFEE_BIN) -cwo $(PUBLIC_JS) $(COFFEE) &
	$(KCKR_BIN) -e "$(LESS_CMD)" less

build: create
	$(COFFEE_BIN) -co $(PUBLIC_JS) $(COFFEE)
	$(LESS_CMD)

install: create
	npm install
	$(BOWER_BIN) install

create:
	mkdir -p $(PUBLIC)
	mkdir -p $(PUBLIC)/css
	mkdir -p $(PUBLIC_JS)

start:
	$(NODEWEBKIT_BIN) .

.PHONY: build watch