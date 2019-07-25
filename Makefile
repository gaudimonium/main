# https://www.gnu.org/software/make/

DEVD ?= devd
HUGO ?= hugo
MODD ?= modd
PERU ?= peru

RSYNC ?= rsync
RSYNC_OPTS ?= -avP --delete

SRC_DIR = .
BLD_DIR = public
CONTENT_SRC = content_src
CONTENT_DIR = content

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

# https://stackoverflow.com/questions/40621451/makefile-automatically-compile-all-c-files-keeping-o-files-in-separate-folde
CONTENT_FILES := $(wildcard $(CONTENT_SRC)/*.md)

.PHONY: content
content: $(CONTENT_FILES)
	$(RSYNC) $(RSYNC_OPTS) $(CONTENT_SRC)/_global $(CONTENT_DIR)/
	$(RSYNC) $(RSYNC_OPTS) $(CONTENT_SRC)/_index $(CONTENT_DIR)/
	$(foreach file, $^,(mkdir -p $(CONTENT_DIR)/$(notdir $(basename $(file))) && cp -v $(file) $(CONTENT_DIR)/$(notdir $(basename $(file)))/index.md) &&) :

build: env content
	mkdir -p $(BLD_DIR)
	$(RSYNC) $(RSYNC_OPTS) $(SRC_DIR)/static/* $(BLD_DIR)/
	$(HUGO) $(HUGO_OPTS)

watch:
	$(MODD)

clean:
	rm -rf $(CONTENT_DIR)
	rm -rf $(BLD_DIR)
