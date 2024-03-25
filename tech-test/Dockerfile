#FROM alpine:3.8

#RUN addgroup www
#RUN adduser -D -g 'www' nginx

#RUN apk update && apk add nginx

#RUN mkdir /www && \
#    chown -R nginx:www /var/lib/nginx && \
#    chown -R nginx:www /www

#COPY nginx/default.conf /etc/nginx/conf.d/default.conf

#ENTRYPOINT nginx -g 'daemon off;'

FROM alpine:3.8

# Create a dedicated group and user for Nginx
# This helps with better permissions management and security
RUN addgroup -S www && adduser -S -G www nginx

# Update package repositories and install Nginx
RUN apk update && apk add nginx

# Create the /www directory for serving website files
# Set appropriate permissions for the nginx user and group
RUN mkdir /www && \
    chown -R nginx:www /var/lib/nginx && \
    chown -R nginx:www /www

# Create /run/nginx directory and set permissions
# This directory is used by Nginx for runtime data
RUN mkdir -p /run/nginx && chown -R nginx:www /run/nginx

# Copy the website files to the /www directory
COPY www /www

# Copy the Nginx configuration file
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Start Nginx in the foreground mode
ENTRYPOINT ["nginx", "-g", "daemon off;"]

