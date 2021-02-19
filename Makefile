#### Build system for docker images
### Initial setup
## Default target
.PHONY: all
all: help

## Define handy macros for managing verison numbers, &c.
INITIAL_VERSION=1.0.0
image-part = $(word $2,$(shell perl -e'$$_="$1";s/-/ /;print;'))

define get_tag
	git --no-pager tag -l "$(1)-[0-9.]*" \
		| rev                              \
		| cut -d '-' -f 1                  \
		| rev                              \
		| ./semversort.sh                  \
		| head -n $(2)                     \
		| tail -n 1
endef

define increment_version
	if   [[ $(2) == major ]]; then              \
		$(call get_tag,$(1),1)                    \
		| awk -F '.' '{print $$1+1".0.0"}';       \
	elif [[ $(2) == minor ]]; then              \
		$(call get_tag,$(1),2)                    \
		| awk -F '.' '{print $$1"."$$2+1".0"}';   \
	elif [[ $(2) == patch ]]; then              \
		$(call get_tag,$(1),3)                    \
		| awk -F '.' '{print $$1"."$$2"."$$3+1}'; \
	fi
endef

define tag_and_push
	$(eval dir := $(call image-part,$(1),1))
	$(eval ext := $(call image-part,$(1),2))

	@if ! test -f $(dir)/Dockerfile.$(ext); \
		then echo "Cannot release $(1): $(dir)/Dockerfile.$(ext) does not exist"; \
		else ./release.sh $(1) $(2); \
	fi
endef

### Define build system
## Build pattern to build an image
.PHONY: build-%
build-%: DOCKERFILE_PATH = $(call image-part,$*,1)/Dockerfile.$(call image-part,$*,2)
build-%: IMAGE_NAME = $*
build-%:
	@echo "\033[1;3;38;2;255;255;0mMake parameters\033[0m"
	@echo "\033[1;3;38;2;255;255;0m===============\033[0m"
	@echo "\033[1;3;38;2;255;255;0mDockerfile path\033[0;2m ... \033[0;1;3m$(DOCKERFILE_PATH)\033[0m"
	@echo "\033[1;3;38;2;255;255;0mImage name\033[0;2m ........ \033[0;1;3m$(IMAGE_NAME)\033[0m"
	@echo
	@DOCKERFILE_PATH=$(DOCKERFILE_PATH) \
	IMAGE_NAME=$(IMAGE_NAME) \
	hooks/build

## Release pattern to bump version numbers and publish a tag
.PHONY: release-major-%
release-major-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,major)), $(INITIAL_VERSION)))

.PHONY: release-minor-%
release-minor-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,minor)), $(INITIAL_VERSION)))

.PHONY: release-patch-%
release-patch-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,patch)), $(INITIAL_VERSION)))

### Define convenience targets
## Build system for all python images
.PHONY: build-all-python-images
build-all-python-images: build-build-python build-build-python-postgres build-build-python.tox build-base-python

### Help targets
.PHONY: help
help:
	@ echo 'To build an image: make build-imagename'
	@ echo 'To clean an image: make clean-imagename'
	@ echo 'To release an image: make release-{major,minor,patch}-imagename'
	@ echo 'To build all python images: make build-all-python-images'
	@ echo 'For more information, c.f. README.'
	@ echo
	@ echo 'Make targets'
	@ echo '============'
	@ echo
	@ perl -ne 'print if /^[^\s]*:/' Makefile | grep -v .PHONY | cut -d':' -f1 | sort -u
	@ echo
	@ echo 'Phony make targets'
	@ echo '=================='
	@ echo
	@ make -np | grep \^.PHONY: | sed 's/^\.PHONY: *//' | tr " " "\n" | sort -u
