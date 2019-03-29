Dockerfile to build a MariaDB image which contains a database.

# Description

This Dockerfile creates an image that has a database installed in it: 

# Usage

Start by placing the database that you want the image to host at the
dumps directory under the name myproject.sql. If you want a different
database name, then edit `setup.sql` and `Dockerfile`.

Clone this repository and build the image with the following command:

```bash
git clone git@github.com:juampynr/docker-mariadb.git
cd docker-mariadb
docker build --tag myprojectdb_image .
```

Start a container:

```bash
docker run -d --rm --name myprojectdb_container myprojectdb_image

```

2. Verify that the database has been installed:

```bash
docker exec -it myprojectdb_image bash

mysql

show databases;
```

# Where to host the image

This GitHub repository is connected to a public repository at Docker Hub as
a demonstration. However, you wouldn't want to host your project's
database image in a public Docker repository. The options that I have found
to host the images are:

## Quay.io

[Quay.io](https://quay.io) costs 15$ per month and let's you host up to 5 repositories. What
I like the most about it is that it has the concept of [Robot accounts](https://docs.quay.io/glossary/robot-accounts.html)
which can be used at CI services like [CircleCI](https://circleci.com/docs/2.0/private-images/) in order to pull images
without having to share your Quay.io credentials. Instead, you would
create a robot account which has read only permissions on a single
repository at Quay.io.

## Docker hub

[Docker hub](https://hub.docker.com/) let's you have a single private repository for free.
However, it does not have the concept of robot accounts so unless you create
a Docker account which just manages your project's repository, you would have
to store your personal Docker Hub password in third party services like CircleCI
as an environment variable so it can pull the image.
