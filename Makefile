nfsometer: Dockerfile .dockerignore docker-compose.yml
	docker-compose build
	docker-compose run --rm nfsometer-build