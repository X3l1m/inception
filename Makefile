NAME = inception
SRCS = ./srcs
COMPOSE = $(SRCS)/docker-compose.yml
DATA_DIR = ./data

all: setup $(NAME)

$(NAME):
	docker-compose -f $(COMPOSE) up --build -d

setup:
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@sudo chmod 777 $(DATA_DIR)/wordpress
	@sudo chmod 777 $(DATA_DIR)/mariadb
	@if ! grep -q "seyildir.42.fr" /etc/hosts; then \
		echo "127.0.0.1 seyildir.42.fr" | sudo tee -a /etc/hosts; \
		echo "Host added to /etc/hosts"; \
	fi
	@echo "Data directories created and permissions set"

down:
	docker-compose -f $(COMPOSE) down
	

logs:
	docker-compose -f $(COMPOSE) logs

clean:
	docker-compose -f $(COMPOSE) down

eval:
	@docker stop $$(docker ps -qa) 2>/dev/null || true
	@docker rm $$(docker ps -qa) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true

fclean: clean
	docker system prune -af
	sudo rm -rf $(DATA_DIR)
	docker volume prune -f

re: fclean all

.PHONY: all setup clean fclean re $(NAME) eval
