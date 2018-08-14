
# SFTP Configurations
# ========================================
ID_RSA :=./test_sftp/ssh/id_rsa
PORT :=22
USERNAME :=foo
HOSTNAME :=localhost
REMOTE_PATH :=/share
COMMANDS_FILE_PACKAGE :=./commands_packages.txt
COMMANDS_FILE_PROJECT :=./commands_project.txt

# Docker Registry Configurations
# ========================================
DOCKER_ID_USER :=dckrer
DOCKER_REG_DOMAIN :=https://index.docker.io/v1/

BASE_DIR :=$(CURDIR)

# OPERATIONS at LOCAL NETWORK ===========================================================================

# Downloads dependecies over Nexus. 
# To add a new dependecy, you can add its full link into `nexus.list`
nexus:
	./nexus.sh

# Dowloads and save Docker images on local disk.
# You need to define your registry service and username. 
# When it prompts password, please, enter your username for Docker
# To extend docker images, you added Docker Image's TAG into `docker.list`
# You can added public or private Docker Image's name into the same file, `docker.list`
# Please, note that, you need to enter your password to reach your private Docker images
docker_save:
	./docker_save.sh ${DOCKER_REG_DOMAIN} ${DOCKER_ID_USER}

# Removes all pulled images you asked in `docker.list` over local Docker engine
docker_rmi:
	./docker_rmi.sh

# Nexus's dependecies and Docker Images are saving under directory `packages`.
# It removes those files on your local disk
rm_packages:
	rm -rf ./packages/*.img
	rm -rf ./packages/*.jar

# Creates check sums for each dependecies and Docker Images, to verify transfered files subsequently their check sums
# under to remote network
check_sum:
	rm -rf ./packages/check.512sum
	ls ./packages/* | xargs -L1 -I{} sha512sum -b {} > ./check.512sum
	mv ./check.512sum ./packages

# Before transfering desired files, it creates a tar for directory packages.
tar_packages: check_sum
	./tar_packages.sh

# Creates whole projects except for a few directories, ssh, data, .git, .gitignore
tar_project: check_sum
	rm -rf project.tar
	cd ../ && tar --exclude=$(BASE_DIR)/test_sftp/ssh/* --exclude=$(BASE_DIR)/test_sftp/data/* --exclude=$(BASE_DIR)/.git --exclude=$(BASE_DIR)/.gitignore -cf project.tar `basename $(BASE_DIR)`
	cd ../ && mv project.tar $(BASE_DIR)/

# Transfers tar file (packages.tar) of directory packages to remote network via sftp connection.
# To make a secure establishment, you need to define RSA file on your local disk.
# You can modify `commands_packages.txt` to define batch operations for SFTP connection
sftp_packages:
	./sftp.sh ${ID_RSA} ${PORT} ${USERNAME} ${HOSTNAME} ${REMOTE_PATH} ${COMMANDS_FILE_PACKAGE}

# Transfers tar file (projects.tar) of whole project to remote network via sftp connection.
# You can modify `commands_project.txt` to define batch operations for SFTP connection
sftp_project:
	./sftp.sh ${ID_RSA} ${PORT} ${USERNAME} ${HOSTNAME} ${REMOTE_PATH} ${COMMANDS_FILE_PROJECT}

# Tests sftp connection and transfers on local computer by using Docker and Docker-Compose.
sftp_test:
	./sftp_test.sh

# Puts `projects.tar` to remote network
put_project: nexus docker_save tar_project sftp_project

# Puts `packages.tar` to remote network
put_packages: nexus docker_save tar_packages sftp_packages

# OPERATIONS at REMOTE NETWORK ===========================================================================

# The following commands can be used in Bank's network. 
# To use them, whole directory need to be tranfered to the destination network
docker_load:
	./docker_load.sh

# Verifies check sums of transfered files on the remote network.
verify_check_sum:
	sha512sum -c ./packages/check.512sum