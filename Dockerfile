FROM node:10-alpine

LABEL maintainer="dev.eyemonen@gmail.com"

WORKDIR /home/mdgen

RUN apk add --no-cache openssh-client rsync && \
  npm install -g markdown-styles && \ 
  npm install --unsafe-perm -g backslide && \ 
  addgroup -S mdgen && \
  adduser -S mdgen -G mdgen
  
COPY eyemonen-coursestyle /usr/local/lib/node_modules/markdown-styles/layouts/eyemonen-coursestyle
COPY template /home/mdgen/template

USER mdgen
CMD ["/bin/sh"]
