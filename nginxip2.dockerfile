# build environment
FROM node:14.18.1 as build
WORKDIR /app
COPY package*.json ./
COPY . .
RUN npm ci
RUN npm run build

# production environment
FROM nginx:1.21.4-alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf
#COPY --from=build /app/nginx/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD [ "nginx","-g", "daemon off;"]
