.PHONY: release-major-% release-minor-% release-patch-%

INITIAL_VERSION=1.0.0
image-part = $(word $2,$(subst -, ,$1))

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

build-%:
	$(eval dir := $(call image-part,$*,1))
	$(eval ext := $(call image-part,$*,2))
	DOCKERFILE_PATH=${dir}/Dockerfile.${ext} \
	IMAGE_NAME=$*                            \
		hooks/build

release-major-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,major)), $(INITIAL_VERSION)))

release-minor-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,minor)), $(INITIAL_VERSION)))

release-patch-%:
	$(call tag_and_push,$*,$(or $(shell $(call increment_version,$*,patch)), $(INITIAL_VERSION)))
