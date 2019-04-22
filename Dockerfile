# Build
FROM ubuntu:18.04 as build
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y build-essential
RUN apt-get install -y git
RUN apt-get install -y curl
RUN apt-get install sudo
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g yarn
WORKDIR /var/app
RUN git clone https://github.com/sayantanhore/writer.git
RUN cd writer
WORKDIR /var/app/writer
RUN yarn install
RUN yarn build

# Deploy to Nginx
FROM nginx:1.15.11-alpine as deploy
COPY --from=build /var/app/writer/build /var/www
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./ssl/server.crt /etc/nginx/ssl/server.crt
COPY ./ssl/server.key /etc/nginx/ssl/server.key
EXPOSE 443
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]