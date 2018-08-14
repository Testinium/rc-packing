
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


# 
nexus:
	./nexus.sh

docker_save:
	./docker_save.sh ${DOCKER_REG_DOMAIN} ${DOCKER_ID_USER}

docker_rmi:
	./docker_rmi.sh

rm_packages:
	rm -rf ./packages/*.img
	rm -rf ./packages/*.jar

check_sum:
	rm -rf ./packages/check.512sum
	ls ./packages/* | xargs -L1 -I{} sha512sum -b {} > ./check.512sum
	mv ./check.512sum ./packages

tar_packages: check_sum
	./tar_packages.sh

tar_project: check_sum
	rm -rf project.tar
	cd ../ && tar --exclude=$(BASE_DIR)/test_sftp/ssh/* --exclude=$(BASE_DIR)/test_sftp/data/* --exclude=$(BASE_DIR)/.git --exclude=$(BASE_DIR)/.gitignore -cf project.tar `basename $(BASE_DIR)`
	cd ../ && mv project.tar $(BASE_DIR)/

sftp_packages:
	./sftp.sh ${ID_RSA} ${PORT} ${USERNAME} ${HOSTNAME} ${REMOTE_PATH} ${COMMANDS_FILE_PACKAGE}

sftp_project:
	./sftp.sh ${ID_RSA} ${PORT} ${USERNAME} ${HOSTNAME} ${REMOTE_PATH} ${COMMANDS_FILE_PROJECT}

sftp_test:
	./sftp_test.sh

put_project: nexus docker_save tar_project sftp_project

put_packages: nexus docker_save tar_packages sftp_packages

# The following commands can be used in Bank's network. 
# To use them, whole directory need to be tranfered to the destination network
docker_load:
	./docker_load.sh

verify_check_sum:
	sha512sum -c ./packages/check.512sum