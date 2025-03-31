#Use nginx official image
FROM nginx:alpine

#Remove default config
RUN rm /etc/nginx/conf.d/default.conf

#Copy custom nginx config
COPY nginx.conf /etc/nginx/nginx.conf

#Copy PHP files
COPY public /var/www/html

EXPOSE 80
