services = $(addprefix services/,$(patsubst %.yaml,%,$(notdir $(wildcard ./data/oniontree/unsorted/*.yaml))))
tags = $(addprefix tags/,$(addsuffix .html,$(notdir $(wildcard ./data/oniontree/tagged/*))))
HUGO_OUTPUT_PATH = ./public/
HUGO_ENVIRONMENT = onion
HUGO = hugo -c "./content" -d "$(HUGO_OUTPUT_PATH)" --environment "$(HUGO_ENVIRONMENT)"

.PHONY: all
all:

.PHONY: serve
serve:
	@$(HUGO) serve

.PHONY: build
build: build/content/services \
	build/content/download
	@$(HUGO)

.PHONY: build/content/index
build/content/index: _index.html
_index.html:
	@$(HUGO) new --kind homepage "$@"

##
### Services
##
.PHONY: build/content/services
build/content/services: $(addsuffix .md,$(services))
services/%.md:
	@$(HUGO) new --kind service "$@"

##
### OnionTree Bookmarks
##
.PHONY: build/content/bookmarks
build/content/bookmarks: bookmarks.html
bookmarks.html:
	@$(HUGO) new --kind bookmarks "$@"

.PHONY: build/content/download
build/content/download: download.html
download.html:
	@$(HUGO) new --kind download "$@"

##
## Miscellaneous
##

.PHONY: download
download:
	dst=$$(mktemp -d) && git clone https://github.com/onionltd/oniontree "$$dst" \
	&& rsync -avzh --include "*.yaml" --exclude ".*" --exclude "*.*" "$$dst/" data/oniontree/

.PHONY: purge
purge: clean
	$(RM) -r data/oniontree/*

.PHONY: clean
clean:
	$(RM)    content/_index.html
	$(RM)    content/download.html
	$(RM)    content/bookmarks.html
	$(RM) -r content/services/
	$(RM) -r content/tags/
	$(RM) -r public/*
