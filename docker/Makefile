
build:
	docker build -t postman-clientcert:latest .

run: build stop-rm
	docker run --name postman-clientcert -t -i -p 443:443 --rm postman-clientcert

stop-rm:
	-@docker ps -a --filter "name=postman-clientcert" --format "{{.ID}}" | xargs docker stop
	-@docker ps -a --filter "name=postman-clientcert" --format "{{.ID}}" | xargs docker rm

clean: stop-rm
	-docker rmi postman-clientcert
