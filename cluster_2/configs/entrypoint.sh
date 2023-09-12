#!/bin/sh

# This script configures Nginx and starts it in the foreground.
envsubst < /nginx.conf.template > /etc/nginx/nginx.conf && exec nginx -g 'daemon off;'