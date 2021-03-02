#!/usr/bin/env bash

# Bootstrap nginx files with envsubset
printenv
mkdir -p /opt/bitnami/nginx/conf/server_blocks/
mkdir -p /opt/bitnami/nginx/conf/includes/
envsubst '$NGINX_HOST_API $NGINX_HOST_APP' < /opt/bitnami/nginx/templates/server_blocks/default.template > /opt/bitnami/nginx/conf/server_blocks/default.conf
envsubst '$NGINX_PROXY_PHP $NGINX_PROXY_NODE' < /opt/bitnami/nginx/templates/includes/api.include.template > /opt/bitnami/nginx/conf/includes/api.include.conf
envsubst '$NGINX_PROXY_PHP $NGINX_PROXY_NODE' < /opt/bitnami/nginx/templates/includes/app.include.template > /opt/bitnami/nginx/conf/includes/app.include.conf

# Wait for services to be ready
/scripts/wait

# Start nginx
/opt/bitnami/scripts/nginx/run.sh
