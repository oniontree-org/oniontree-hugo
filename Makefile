services = $(addprefix services/,$(patsubst %.yaml,%,$(notdir $(wildcard ./data/oniontree/unsorted/*.yaml))))
tags = $(addprefix tags/,$(addsuffix .html,$(notdir $(wildcard ./data/oniontree/tagged/*))))
HUGO_ENVIRONMENT = onion
HUGO = hugo --environment "$(HUGO_ENVIRONMENT)"

.PHONY: all
all:

.PHONY: build
build: build/content/index \
		build/content/services \
		build/content/services/index \
		build/content/tags \
		build/content/tags/index \
		build/content/bookmarks \
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
build/content/services: $(addsuffix .html,$(services))
services/%.html:
	@$(HUGO) new --kind service "$@"

.PHONY: build/content/services/index
build/content/services/index: services/_index.html
services/_index.html:
	@$(HUGO) new --kind services "$@"

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
### Tags
##
.PHONY: build/content/tags
build/content/tags: $(tags)
tags/%.html:
	@$(HUGO) new --kind tag "$@"

.PHONY: build/content/tags/index
build/content/tags/index: tags/_index.html
tags/_index.html:
	@$(HUGO) new --kind tags "$@"

##
## Miscellaneous
##

.PHONY: download
download:
	dst=$$(mktemp -d) && git clone https://github.com/onionltd/oniontree "$$dst" \
	&& rsync -avzh --include "*.yaml" --exclude ".*" --exclude "*.*" "$$dst/" data/oniontree/

.PHONY: purge
purge:
	$(RM) -r data/oniontree/*

.PHONY: clean
clean:
	$(RM)    content/_index.html
	$(RM)    content/download.html
	$(RM)    content/bookmarks.html
	$(RM) -r content/services/
	$(RM) -r content/tags/
	$(RM) -r public/*
