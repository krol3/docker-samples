# build docker image
docker build -t krol/nodejs-sample .

# run the image
docker run --name node-sample -p 49160:8080 krol/nodejs-sample

# test
curl -i localhost:49160

# material
https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
