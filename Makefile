image-part = $(word $2,$(subst -, ,$1))

test:
ifndef IMAGE
$(error Usage: make test IMAGE=<image>)
endif
	$(eval ts := $(shell date +'%s'))
	$(eval dir := $(call image-part,${IMAGE},1))
	$(eval ext := $(call image-part,${IMAGE},2))
	docker build -t test-img:$(ts) -f $(dir)/Dockerfile.$(ext) $(dir)
	#docker rmi --force test-img:$(ts)
	ls -l

release:
ifndef VERSION
	$(error Usage: make upgrade IMAGE=<image> VERSION=<version>)
endif
	$(eval dir := $(call image-part,${IMAGE},1))
	$(eval ext := $(call image-part,${IMAGE},2))

	@if ! test -f $(dir)/Dockerfile.$(ext); \
		then echo "Cannot release $(IMAGE): $(dir)/Dockerfile.$(ext) does not exist"; \
		else bash -i -c "./release.sh $(IMAGE) $(VERSION)"; \
	fi
