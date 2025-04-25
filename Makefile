NAME = inception
CURRENT_DIR := $(shell pwd)
HOSTS_FILE := /etc/hosts
DOMAIN := seyildir.42.fr

all: hosts up

hosts:
	@if ! grep -q "$(DOMAIN)" /etc/hosts; then \
		echo "\033[33mSudo may be required to add: echo '127.0.0.1 $(DOMAIN)' >> /etc/hosts\033[0m"; \
	else \
		echo "\033[32m$(DOMAIN) found in hosts file\033[0m"; \
	fi

up:
	@echo "Starting $(NAME)..."
	@cd srcs && docker-compose up -d --build

logs:
	@echo "Showing logs..."
	@cd srcs && docker-compose logs -f

down:
	@echo "Stopping $(NAME)..."
	@cd srcs && docker-compose down

clean:
	@echo "Cleaning $(NAME)..."
	@cd srcs && docker-compose down -v || true
	@docker system prune -a --force || true

fclean: clean
	@echo "Full cleaning..."
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker network rm $$(docker network ls -q) 2>/dev/null || true
	@docker system prune --volumes --all --force || true

re: fclean all

restart: down up

rebuild: down up

debug:
	@echo "=== Docker Containers ==="
	@docker ps -a
	@echo "=== Docker Networks ==="
	@docker network ls
	@echo "=== Docker Volumes ==="
	@docker volume ls

.PHONY: all hosts up logs down clean fclean re restart rebuild debug
