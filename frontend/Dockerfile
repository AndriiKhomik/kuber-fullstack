FROM node:14.5.0-alpine

WORKDIR /code
COPY package.json /code/package.json
# COPY package-lock.json /code/package-lock.json

RUN npm install
COPY . /code

EXPOSE 3000

CMD [ "npm", "start" ]