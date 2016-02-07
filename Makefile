all:
	docker-compose up

build:
	docker-compose -f build.yml build
	docker-compose -f build.yml up
