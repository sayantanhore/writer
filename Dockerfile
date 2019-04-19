# Build
FROM node:10-alpine as build
RUN npm install -g yarn
COPY . /var/app
WORKDIR /var/app
RUN yarn install
RUN yarn build

# Deploy to Nginx
FROM nginx:1.15.11-alpine as deploy
COPY --from=build /var/app/build /var/www
COPY nginx.conf /etc/nginx/nginx.conf
COPY ./ssl/server.crt /etc/nginx/ssl/server.crt
COPY ./ssl/server.key /etc/nginx/ssl/server.key
EXPOSE 443
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]