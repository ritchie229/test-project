# ----By Rishat Mukhtarov-----------

FROM nginx:alpine

COPY ./data/* /usr/share/nginx/html/.

#EXPOSE 80

