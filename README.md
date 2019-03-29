Dockerfile to build a MariaDB image which contains a database.

# Description

This Dockerfile creates an image that has a database installed in it. 

# Usage

Copy a database dump into dumps/dump.sql.

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

Verify that the container has the database:

```bash
$ docker exec myprojectdb_container mysql -u root -proot myproject -e "select * from mytable;"
 mycolumn
 foo
```

# Hosting images remotely

This GitHub repository is connected to https://quay.io/repository/juampynr/docker-mariadb,
which is used to host the resulting image from the `docker build` command above. However,
you wouldn't want to host your project's database image in a public Docker repository.
Therefore, here are the available optionst that I have found to host images:

## Quay.io

[Quay.io](https://quay.io) costs 15$ per month and let's you host up to 5 repositories. What
I like the most about Quay.io is that it has the concept of
[Robot accounts](https://docs.quay.io/glossary/robot-accounts.html),
which can be used at CI services like [CircleCI](https://circleci.com/docs/2.0/private-images/)
in order to pull images without having to share your Quay.io credentials as environment
variables. Instead, you would create a robot account which has read only permissions on a single
repository at Quay.io.

## Docker hub

[Docker hub](https://hub.docker.com/) lets you have a single private repository for free.
However, it does not have the concept of robot accounts like Quay.io so unless you create
a Docker account just for the project that you are working on, you would have
to store your personal Docker Hub password in third party services like CircleCI
as an environment variable.

## Building and hosting an image remotely

Here is how I build an image and push it to Quay.io so it can be pulled by the team
and third party applications:

I started by creating an account at Quay.io and then creating the https://quay.io/repository/juampynr/docker-mariadb
repository.

Next, I authenticated against Quay.io via the command line:

```bash
$ docker login quay.io
Username: myusername
Password: mypassword 
```

After authenticating, I built an image using a tag name that matches with the repository as 
explained at [Quay.io](https://docs.quay.io/solution/getting-started.html).

```bash
$ docker build --tag quay.io/juampynr/docker-mariadb:2019-02-29-v1 .
```

Then I pushed the image to Quay.io:

```bash
$ docker push quay.io/juampynr/docker-mariadb:2019-02-29-v1
```

From now on, collaborators and third party applications can pull the image via
`docker pull quay.io/juampynr/docker-mariadb:2019-02-29-v1`.

Here is an example where I am starting a container out of the remote image
and then inspecting the database:

```bash
$ docker run -d --rm --name my_container quay.io/juampynr/docker-mariadb:2019-02-29-v1
958314ce55fb24fc0e23ba56e74a8aef26bbacc2704e63b6698b22386dad96ae
$ docker exec my_container mysql -uroot -proot myproject -e "select * from mytable;"
mycolumn
foo
```


