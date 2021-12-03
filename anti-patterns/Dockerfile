# Credtis to https://gist.github.com/Faheetah/a2a401a01d2d56fa7d1a9d7ab0d2831b

### Generic Dockerfile demonstrating good practices


### Imports

# Bad-ish, we do not need Ubuntu for this, nor do we want latest if we are using in a build system, predictable is better
FROM ubuntu:latest

# Better, using a small image since our app has no dependency on Ubuntu
FROM alpine:3.3

# Best, use a specific image that is specially built for the needed dependencies if applicable
# This package includes Oracle Java in a 122MB image, versus the 642MB Debian version _/java:8 uses
# Sometimes it is beneficial to build your own for size purposes as well, as some default packages are large
FROM anapsix/docker-alpine-java:8


### Installing packages

# Bad, this leaves package cache files that will persist in the image.
# Also install in one command unless there is a logical separation between commands
RUN apk update
RUN apk add wget
RUN apk add git

# Better, lets update, add, and clean up on one line. Also use --update instead of using a separate build commit
RUN apk add --update wget git && rm -rf /var/cache/apk/*

# Best, avoid caching content if possible
RUN apk add --no-cache wget

### Fetching files

# BAD, do not keep a temporary or unused file between commands, always clean up in the same command
RUN wget http://example.com/my/large/app.tar.gz -O /root/app.tar.gz
RUN mkdir /opt/somedir
RUN mv /root/app.tar.gz /opt/somedir/app.tar.gz
RUN tar -zxvf /opt/somedir/app.tar.gz

# Better, we at least do this as a one liner and piping to tar leaves nothing on the server but the extracted files
# Also run the create or useradd or whathaveyou before, not during, fetching and extracting
RUN mkdir /opt/somedir
RUN wget -q -O- http://example.com/my/large/app.tar.gz | tar -zxv -C /opt/somedir/

# Best, Docker takes care of this for you with the ADD command, which intelligently downloads and extracts
# Can also utilize WORKDIR if further work will be done in the directory
RUN workdir /opt/somedir
ADD http://example.com/my/large/app.tar.gz .
RUN ./bin/initapp.sh


### Config files

# Bad, don't bake configuration into an image as a general rule of thumb, especially with sensitive data
COPY super_secret_database.conf /opt/rails/config/database.yml

# Good, write a wrapper script that will take arguments
COPY entrypoint.sh .
ENTRYPOINT ["/entrypoint.sh"] # where entrypoint takes config information and passes to the app or updates the config

# Also good, use environment variables. Update database.yml to read from ENV and pass them when running
# docker run -e PROD_DB=localhost -e PROD_PASSWD=horriblepassword -e PROD_USER=root myapp


### Allow default arguments with CMD

# Bad, leaves little to no flexibility
ENTRYPOINT ["/entrypoint.sh", "--db localhost", "--pass horriblepassword", "--user root"]

# Good, allows for overriding arguments with "docker run myapp --db 192.0.2.10 --pass horriblepassword --user root"
ENTRYPOINT ["/entrypoint.sh"]
CMD ["--db", "localhost", "--pass", "horriblepassword", "--user", "root"]


### Run applications in the foreground, and utilize external daemons like systemd

# Bad, don't use daemons in the app
# Of note, nginx has no foreground functionality and daemonizes by default, which is still bad
ENTRYPOINT nginx

# Good, capture the output to stdout/stderr and keep it in the foreground
# Run with a systemd script to keep the container running as a service
RUN ln -s /dev/stdout /var/log/nginx/access.log && ln -s /dev/stderr /var/log/nginx/error.log
RUN nginx -g "daemon off"


### Run only one app at once per container and link containers

# bad, running rails with nginx in front of it
RUN apk add --update nginx ruby
RUN /opt/rails/bin/rails s
ENTRYPOINT nginx -g "daemon off"

# good, run two separate containers and point the nginx container to the rails app
# The nginx container will be able to resolve myrailsapp as a hostname
# docker network create --driver bridge mynetwork
# docker run --name myrailsapp --net mynetwork rails
# docker run --name nginxfrontend --net mynetwork -e RAILS_HOST=myrailsapp nginx


### Allow the option to expose persisted data and ports

# good, exposes the volume and port and uses environment variables to point the application to the default directory
ENV ETCD_DATA_DIR /etcd
VOLUME $ETCD_DATA_DIR
EXPOSE 2379
# docker run -e ETCD_DATA_DIR=/root -v /my/data/dir:/root -p 2379:2379 example/myetcdapp