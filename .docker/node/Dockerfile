FROM bitnami/node:10
LABEL maintainer="damian.mooyman@isobar.com"
ENV DEBIAN_FRONTEND=noninteractive
ENV PORT=3000
ENV NODE_PORT=3000
EXPOSE 3000

# Install startup script
WORKDIR /scripts
COPY ./node/scripts/* /scripts/

WORKDIR /app

# Install and build app
COPY ./build/webapp /app
RUN npm install --unsafe-perm=true --allow-root

# Start the app
CMD ["/scripts/startup.sh"]

