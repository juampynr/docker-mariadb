# Start with a builder image to install the database.
FROM ubuntu:18.04 AS build

RUN apt-get update \
  && apt-get install mariadb-server -y

COPY setup.sql /tmp/
COPY dumps/dump.sql /tmp/dumps/dump.sql

# We wait a couple seconds before stopping MariaDB to avoid the following error:
# ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2 "No such file or directory")
RUN service mysql start && \
  mysql < /tmp/setup.sql && \
  sleep 2 && \
  service mysql stop

# Now define another image where we copy the directory that stores databases;
FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install mariadb-server -y

COPY --from=build --chown=mysql:mysql /var/lib/mysql /var/lib/mysql

RUN find /etc/mysql/ -name '*.cnf' -print0 \
    | xargs -0 grep -lZE '^(bind-address|log)' \
    | xargs -rt -0 sed -Ei 's/^(bind-address|log)/#&/'; \
    echo '[mysqld]\nskip-host-cache\nskip-name-resolve' > /etc/mysql/conf.d/docker.cnf

# Clear the mysql socket
RUN service mysql start && \
  sleep 2 && \
  service mysql stop

EXPOSE 3306
CMD ["mysqld"]
