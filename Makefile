NAME = inception
CURRENT_DIR := $(shell pwd)
DATA_PATH := $(CURRENT_DIR)/srcs/data

all: prepare up

prepare:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@sudo echo "127.0.0.1 seyildir.42.fr" >> /etc/hosts || true

clean_volumes:
	@echo "Cleaning volumes..."
	@sudo docker volume rm srcs_wordpress_data srcs_mariadb_data 2>/dev/null || true

up:
	@echo "Starting $(NAME)..."
	@cd srcs && docker-compose up -d --build

# Add detached mode to run in the background
# -d option does this job

logs:
	@echo "Showing logs..."
	@cd srcs && docker-compose logs -f

# Add new rebuild command
rebuild: clean_volumes prepare up

down:
	@echo "Stopping $(NAME)..."
	@cd srcs && docker-compose down

# Fix the clean target - by adding sudo
clean:
	@echo "Cleaning $(NAME)..."
	@cd srcs && sudo docker-compose down -v || true
	@sudo docker system prune -a --force || true
	@sudo rm -rf $(DATA_PATH)/wordpress/* || true
	@sudo rm -rf $(DATA_PATH)/mariadb/* || true

# Fix the fclean target - by adding sudo
fclean: clean
	@echo "Full cleaning..."
	@sudo docker volume rm $$(sudo docker volume ls -q) 2>/dev/null || true
	@sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null || true
	@sudo docker system prune --volumes --all --force || true

# Fix the re target - completely clean and restart
re: fclean all

# Debug target for troubleshooting - adding sudo
debug:
	@echo "=== Docker Containers ==="
	@sudo docker ps -a
	@echo "=== Docker Networks ==="
	@sudo docker network ls
	@echo "=== Docker Volumes ==="
	@sudo docker volume ls

.PHONY: all prepare up down clean clean_volumes fclean re rebuild logs debug
