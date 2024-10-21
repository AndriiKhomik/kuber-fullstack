FROM node:14.5.0-alpine AS build

WORKDIR /app
COPY package.json /app/package.json

RUN npm install 

COPY . /app

RUN npm run build

FROM nginx:stable-alpine

COPY ../nginx/default.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /srv/www/

CMD [ "nginx", "-g", "daemon off;" ]