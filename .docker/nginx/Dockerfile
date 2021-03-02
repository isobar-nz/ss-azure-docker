FROM bitnami/nginx:1.19
LABEL maintainer="damian.mooyman@isobar.com"

# Default environment variables
ENV DEBIAN_FRONTEND=noninteractive

EXPOSE 8080

# install gettext for envsubst
USER root
RUN install_packages gettext-base
USER 1001

# Copy all configuration
COPY ./nginx/templates /opt/bitnami/nginx/templates

# Copy content from build into app webroot
COPY ./build /app

# Make sure there is no /app/public/assets (will be mounted later)
RUN rm -rf ./app/public/assets

# Install startup script
WORKDIR /scripts
COPY ./nginx/scripts/* /scripts/

# Start the app
WORKDIR /app
CMD ["/scripts/startup.sh"]
