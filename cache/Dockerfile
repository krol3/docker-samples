FROM node:10.15-jessie

RUN apt-get update && apt-get install -y mysql-client && rm -rf /var/lib/apt

RUN mysql -u root --password="" < test/prepare-db-for-tests.sql

WORKDIR /app

COPY package.json ./package.json
COPY package-lock.json ./package-lock.json
RUN npm install
COPY . .

RUN npm integration-test

EXPOSE 8080
CMD [ "npm", "start" ]
