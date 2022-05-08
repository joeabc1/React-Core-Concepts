# stage1 as builder
FROM node:12-alpine as builder

# copy the package.json to install dependencies
COPY package.json package-lock.json ./

# Install the dependencies and make the folder
RUN npm install && mkdir /react-ui && mv ./node_modules ./react-ui

WORKDIR /react-ui

COPY . .

# Build the project and copy the files
RUN npm run build


FROM nginx:alpine

#!/bin/sh
COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf
#COPY ./.nginx/nginx.conf /etc/nginx/nginx.conf

#ADD ./scripts/* /scripts/
#RUN chmod +x /scripts/*
#VOLUME /scripts
VOLUME /etc/nginx
VOLUME /user/share/nginx
VOLUME /var/log/nginx/log
VOLUME /var/cache/nginx

## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*
RUN chmod -R 777 /var/log/nginx
RUN chmod -R 777 /var/cache/nginx
RUN chmod -R 777 /user/share/nginx
RUN chmod -R 777 /etc/nginx

# Copy from the stahg 1
COPY --from=builder /react-ui/build /usr/share/nginx/html


EXPOSE 3000 3001 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]
