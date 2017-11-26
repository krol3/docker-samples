FROM node:boron
MAINTAINER guillen.carolina@gmail.com

WORKDIR /usr/src/app

# Install app dependencies
ADD src/package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/

WORKDIR /opt/app
ADD src /opt/app

EXPOSE 8080

CMD [ "npm", "start" ]