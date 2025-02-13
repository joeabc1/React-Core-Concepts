FROM node:14

ENV JQ_VERSION=1.6
#RUN wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64
#RUN cp /tmp/jq-linux64 /usr/bin/jq
#RUN chmod +x /usr/bin/jq

WORKDIR /app
COPY . .
#RUN jq 'to_entries | map_values({ (.key) : ("$" + .key) }) | reduce .[] as $item ({}; . + $item)' ./src/config.json > ./src/config.tmp.json && mv ./src/config.tmp.json ./src/config.json
RUN npm install && npm run build

FROM nginx:1.17
ENV JSFOLDER=/opt/app/static/js/main*.js
#COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf
#joelCOPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./config/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /opt/app && chown -R nginx:nginx /opt/app && chmod -R 775 /opt/app
RUN touch /var/run/nginx.pid
RUN mkdir -p /var/cache/nginx/client_temp
RUN  chmod -R 777 /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid  /var/cache/nginx/client_temp

RUN chown -R nginx:nginx /var/cache && \
   chown -R nginx:nginx /var/log/nginx && \
   chown -R nginx:nginx /etc/nginx/conf.d
RUN chown -R nginx:nginx /var/run  
 
#RUN chown -R nginx:nginx /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid /var/cache/nginx/client_temp

#RUN chgrp -R nginx /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid && \
 # chmod -R 775 /var/cache/nginx /var/run /var/log/nginx /var/run/nginx.pid
COPY ./start-nginx.sh /usr/bin/start-nginx.sh
RUN chmod +x /usr/bin/start-nginx.sh

EXPOSE 8080
WORKDIR /opt/app
COPY --from=0 --chown=nginx /app/build .
RUN chmod -R a+rw /opt/app
USER nginx
ENTRYPOINT [ "start-nginx.sh" ]
