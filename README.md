
# RC-Packing

This project is collecting some dependecies over exteral resources and Docker Images over public or private Docker Registry Service.

After saving on local network, the package is being transferred to remote network via a SFTP connection.

# Settings

You can see some configurable settings, in the first couple lines of `makefile` file like below:

```makefile
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
```

1. Please, update those variables in `makefile` according to your demands and system.
2. Please, modify the following files to add a new dependecy and Docker Image name. To extend your batch operations for SFTP, Please, change commands files, below.
    - nexus.list
    - docker.list
    - commands_project.txt
    - commands_packages.txt


# Commands
We created a bunch of commands in `makefile` to help you and speed up your filing operations local and remote network. Those commands are like below.


## Commands at Local Network

To apply sequantialy commands in a pipeline, you can directly use `make put_packages`. If you want to apply steps individually on command prompt, you take use the following commands whatever you want to do at local or remote network.

make nexus
---

Downloads dependecies over Nexus. 
To add a new dependecy, you can add its full link into `nexus.list`

make docker_save
---

Dowloads and save Docker images on local disk.
You need to define your registry service and username. 
When it prompts password, please, enter your username for Docker
To extend docker images, you added Docker Image's TAG into `docker.list`
You can added public or private Docker Image's name into the same file, `docker.list`
Please, note that, you need to enter your password to reach your private Docker images

make check_sum
---

Creates check sums for each dependecies and Docker Images, to verify transfered files subsequently their check sums
under to remote network

make tar_packages
---

Before transfering desired files, it creates a tar for directory packages.

make tar_project
---

Creates whole projects except for a few directories, ssh, data, .git, .gitignore

make sftp_packages
---

Transfers tar file (packages.tar) of directory packages to remote network via sftp connection.
To make a secure establishment, you need to define RSA file on your local disk.
You can modify `commands_packages.txt` to define batch operations for SFTP connection

make sftp_project
---

Transfers tar file (projects.tar) of whole project to remote network via sftp connection.
You can modify `commands_project.txt` to define batch operations for SFTP connection

make sftp_test
---

Tests sftp connection and transfers on local computer by using Docker and Docker-Compose.

make put_project
---

Puts `projects.tar` to remote network

make put_packages
---

Puts `packages.tar` to remote network

make docker_rmi
---

Removes all pulled images you asked in `docker.list` over local Docker engine

make rm_packages
---

Nexus's dependecies and Docker Images are saving under directory `packages`.
It removes those files on your local disk

## Commands at Remote Network

make docker_load
---

The following commands can be used in remote network. 
To use them, whole directory need to be tranfered to the destination network

make verify_check_sum
---

Verifies check sums of transfered files on the remote network.

To get further information about make commands,please,check out once `makefile` to see details about make commands.


