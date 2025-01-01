# Define variables
ROS_DISTRO := humble
CONTAINER_NAME := orca-auv-simulation-ros2-container
WORKSPACE := orca_auv_simulation_ros2_ws
DOCKER_IMAGE := ros:$(ROS_DISTRO)

.PHONY: all build_container start_container exec_container clean

all: build_container

build_container:
	@echo "Creating and starting a new container: $(CONTAINER_NAME)"
	docker run -dit \
	    --net=host \
	    -v /dev:/dev \
	    -v $(PWD)/$(WORKSPACE):/$(WORKSPACE) \
	    --privileged \
	    --name $(CONTAINER_NAME) \
	    $(DOCKER_IMAGE) \
	    bash

start_container:
	@echo "Starting existing container: $(CONTAINER_NAME)"
	docker start $(CONTAINER_NAME)

exec_container:
	@echo "Executing a shell inside container: $(CONTAINER_NAME)"
	docker exec -it $(CONTAINER_NAME) bash

clean:
	docker rm -f $(CONTAINER_NAME) || true
	rm -rf $(WORKSPACE)/build $(WORKSPACE)/install $(WORKSPACE)/log
