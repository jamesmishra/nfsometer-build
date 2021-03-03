nfsometer: Dockerfile .dockerignore docker-compose.yml
	docker-compose build
	UID=$$(id -u) GID=$$(id -g) docker-compose run --rm nfsometer-build

clean:
	rm -fv nfsometer

.PHONY: clean
