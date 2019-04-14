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
EXPOSE 80
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]