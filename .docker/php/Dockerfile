FROM bitnami/php-fpm:7.2
LABEL maintainer="damian.mooyman@isobar.com"
ENV DEBIAN_FRONTEND=noninteractive
ENV SS_VENDOR_METHOD=copy

# Ensure all system dependencies are installed
RUN apt-get update && apt-get install -y zip unzip git cron sed

# Copy various ini settings
COPY ./php/conf.d/* /opt/bitnami/php/etc/conf.d/
COPY ./php/php-fpm.d/* /opt/bitnami/php/etc/php-fpm.d/

# Copy content from build into app webroot
COPY ./build /app

# Install startup script
WORKDIR /scripts
COPY ./php/scripts/* /scripts/

# Install composer, install app files with composer
WORKDIR /app
RUN /scripts/install-composer.sh
RUN /app/composer.phar --version
RUN /app/composer.phar install --prefer-dist --no-dev --optimize-autoloader

# Setup cron tasks
# https://github.com/bitnami/bitnami-docker-php-fpm/issues/133
RUN mkdir -p /etc/cron.minutely /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d
COPY ./php/cron.d/* /etc/cron.d/
RUN chmod -R 0755 /etc/cron.minutely /etc/cron.hourly /etc/cron.daily /etc/cron.weekly /etc/cron.monthly /etc/cron.d
RUN touch /var/log/cron.log
RUN touch /var/log/cron_lastrun.log
RUN crontab /etc/cron.d/cron-tasks

# Start the app
CMD ["/scripts/startup.sh"]
