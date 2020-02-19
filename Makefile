.PHONY: test-build test-base release-major-% release-minor-% release-patch-% release-build-% release-base-%

INITIAL_VERSION=1.0.0
image-part = $(word $2,$(subst -, ,$1))

define get_tag
	git --no-pager tag -l "$(1)-[0-9.]*" \
		| cut -d '-' -f 3                  \
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

build-%:
	$(eval dir := $(call image-part,$*,1))
	$(eval ext := $(call image-part,$*,2))
	DOCKERFILE_PATH=${dir}/Dockerfile.${ext} \
	IMAGE_NAME=$*                            \
		${dir}/hooks/build

test-%:
	$(eval timestamp := $(shell date +'%s'))
	$(eval dir := $(call image-part,$*,1))
	$(eval ext := $(call image-part,$*,2))
	DOCKERFILE_PATH=${dir}/Dockerfile.${ext} \
	IMAGE_NAME=$*                            \
		${dir}/hooks/build
	docker rmi --force test-image:${timestamp}

test-build: test-build-node test-build-python test-build-postgres test-build-go
test-base: test-base-node test-base-python test-base-java test-base-kafka test-base-go

test: test-build test-base

release-major-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,major)), $(INITIAL_VERSION)))

release-minor-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,minor)), $(INITIAL_VERSION)))

release-patch-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,patch)), $(INITIAL_VERSION)))

release-build-%:
	$(MAKE) release-$*-build-node release-$*-build-python release-$*-build-postgres release-$*-build-go

release-base-%:
	$(MAKE) release-$*-base-node release-$*-base-python release-$*-base-go

release-%:
	$(MAKE) release-build-$* release-base-$*

release: release-patch
