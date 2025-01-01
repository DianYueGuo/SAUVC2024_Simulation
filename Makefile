# Define variables
CONTAINER_NAME := orca-auv-simulation-container
DOCKER_IMAGE := ubuntu:jammy

.PHONY: all build_container start_container stop_container exec_container clean

all: build_container

build_container:
	@echo "Creating and starting a new container: $(CONTAINER_NAME)"
	docker run -dit \
	    --net=host \
	    --name $(CONTAINER_NAME) \
	    --env="DISPLAY=docker.for.mac.host.internal:0" \
	    $(DOCKER_IMAGE) \
	    bash
	@echo "Initializing container: $(CONTAINER_NAME)"
	docker exec -it $(CONTAINER_NAME) bash -c "\
	    apt-get update && \
		apt-get install -y lsb-release gnupg && \
		\
		apt-get install -y curl && \
		curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
		echo \"deb [arch=\$$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable \$$(lsb_release -cs) main\" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
		apt-get update && \
		apt-get install -y ignition-fortress"

start_container:
	@echo "Starting existing container: $(CONTAINER_NAME)"
	docker start $(CONTAINER_NAME)

stop_container:
	@echo "Stopping existing container: $(CONTAINER_NAME)"
	docker stop $(CONTAINER_NAME)

exec_container:
	@echo "Executing a shell inside container: $(CONTAINER_NAME)"
	docker exec -it $(CONTAINER_NAME) bash

clean:
	docker rm -f $(CONTAINER_NAME) || true
