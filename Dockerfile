# from https://hub.docker.com/_/node and https://github.com/nodejs/docker-node
FROM node:18-buster-slim as node
# replace this with your application's default port
EXPOSE 8888

RUN mkdir /webapp
WORKDIR /webapp

ADD package.json /webapp/
ADD package-lock.json /webapp/
RUN npm ci

CMD ["npm", "run", "dev", "run", "--debugger", "--host=0.0.0.0", "--reload"]
