repository=nicholasjackson/nginx-consul
version=v0.1.0

build:
	docker buildx create --use
	docker buildx build \
		-t ${repository}:${version} \
		--platform linux/arm64,linux/amd64 \
		--push \
		.

build_local:
	docker buildx create --use
	docker buildx build \
		-t ${repository}:${version} \
		--platform linux/amd64 \
		--load \
		.
