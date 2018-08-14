keys:
	./keys.sh

up: keys
	docker-compose up -d

down:
	docker-compose down
	
clean: down
	rm -rf ssh
	sudo rm -rf data
