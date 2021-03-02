#!/usr/bin/env bash

# Dump env, force to .env file (skip lines that begin with _ character or numbers)
printenv | sed '/^[_0-9]/d' >/app/.env # this is important; Cron tasks cannot see normal env, so use a file
cat /app/.env

# Start cron
cron f

# Start PHP
php-fpm -F --pid /opt/bitnami/php/tmp/php-fpm.pid -y /opt/bitnami/php/etc/php-fpm.conf
