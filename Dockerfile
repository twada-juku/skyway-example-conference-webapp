# from https://hub.docker.com/_/node
FROM node:20-buster-slim as node
RUN mkdir /webapp
WORKDIR /webapp

ADD package.json /webapp/
ADD package-lock.json /webapp/
RUN npm ci

CMD ["npm", "run", "dev", "run", "--debugger", "--host=0.0.0.0", "--reload"]
