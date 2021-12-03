# Run Sonar analysis
FROM newtmitch/sonar-scanner AS sonar
COPY src src
RUN sonar-scanner
# Build application
FROM node:11 AS build
WORKDIR /usr/src/app
COPY . .
RUN yarn install \
 yarn run lint \
 yarn run build \
 yarn run generate-docs
LABEL stage=build
# Run unit test
FROM build AS unit-tests
RUN yarn run unit-tests
LABEL stage=unit-tests
# Push docs to S3
FROM containerlabs/aws-sdk AS push-docs
ARG push-docs=false
COPY --from=build docs docs
RUN [[ "$push-docs" == true ]] && aws s3 cp -r docs s3://my-docs-bucket/
# Build final app
FROM node:11-slim
EXPOSE 8080
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/node_modules node_modules
COPY --from=build /usr/src/app/dist dist
USER node
CMD ["node", "./dist/server/index.js"]