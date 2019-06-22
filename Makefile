# https://www.gnu.org/software/make/

DEVD ?= devd
HUGO ?= hugo
MODD ?= modd
PERU ?= peru
RSYNC ?= rsync

SRC_DIR = .
BLD_DIR = public

env:
	-$(DEVD) --version
	-$(HUGO) version
	-$(MODD) --version
	-$(PERU) --version
	-$(RSYNC) --version

deps:
	$(PERU) sync

dev-server:
	$(DEVD) $(DEVD_OPTS)

build: env
	mkdir -p $(BLD_DIR)
	$(RSYNC) -avP --delete $(SRC_DIR)/static/* $(BLD_DIR)/
	$(HUGO) $(HUGO_OPTS)

watch:
	$(MODD)

clean:
	rm -rf $(BLD_DIR)
