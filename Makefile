.PHONY: test-build test-base

image-part = $(word $2,$(subst -, ,$1))

define get_tag
	git --no-pager tag --contains HEAD "$(1)-[0-9.]*" | head -n $(2) | tail -n 1 | cut -d '-' -f 3
endef

define increment_version
	@if test $(2) -eq 'major'; then $(call get_tag,$(1),1) | awk -F '.' '{print $$1+1"."$$2"."$$3}'; \
	elif test $(2) -eq 'minor'; then $(call get_tag,$(1),2) | awk -F '.' '{print $$1"."$$2+1"."$$3}'; \
	elif test $(2) -eq 'patch'; then $(call get_tag,$(1),3) | awk -F '.' '{print $$1"."$$2"."$$3+1}'; \
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
	docker build -t $($*) -f $(dir)/Dockerfile.$(ext) .

test-%:
	$(eval ts := $(shell date +'%s'))
	$(eval dir := $(call image-part,$*,1))
	$(eval ext := $(call image-part,$*,2))
	docker build -t test-img:$(ts) -f $(dir)/Dockerfile.$(ext) .
	docker rmi --force test-img:$(ts)

test-build: test-build-node test-build-python test-build-postgres
test-base: test-base-node test-base-python test-base-java test-base-kafka

test: test-build test-base

release-major-%:
	$(call tag_and_push,$*,$(shell $(call increment_version,$*,major)))

release-minor-%:
	$(call tag_and_push,$*,$(shell $(call increment_version,$*,minor)))

release-patch-%:
	$(call tag_and_push,$*,$(shell $(call increment_version,$*,patch)))
