image-part = $(word $2,$(subst -, ,$1))

.PHONY: build

build:
	$(or ${IMAGE},$(error Usage: make $@ IMAGE=<image>))
	$(eval dir := $(call image-part,${IMAGE},1))
	$(eval ext := $(call image-part,${IMAGE},2))
	docker build -t $(IMAGE) -f $(dir)/Dockerfile.$(ext) .

test:
	$(or ${IMAGE},$(error Usage: make $@ IMAGE=<image>))
	$(eval ts := $(shell date +'%s'))
	$(eval dir := $(call image-part,${IMAGE},1))
	$(eval ext := $(call image-part,${IMAGE},2))
	docker build -t test-img:$(ts) -f $(dir)/Dockerfile.$(ext) .
	docker rmi --force test-img:$(ts)

release:
	$(or ${IMAGE},$(error Usage: make $@ IMAGE=<image>))
	$(or ${IMAGE},$(error Usage: make $@ VERSION=<version>))
	$(eval dir := $(call image-part,${IMAGE},1))
	$(eval ext := $(call image-part,${IMAGE},2))

	@if ! test -f $(dir)/Dockerfile.$(ext); \
		then echo "Cannot release $(IMAGE): $(dir)/Dockerfile.$(ext) does not exist"; \
		else ./release.sh $(IMAGE) $(VERSION); \
	fi
