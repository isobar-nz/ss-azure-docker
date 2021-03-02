# Isobar NZ Azure Docker Template

This can be used as a base for hosting a nextjs app running SilverStripe as a headless CMS.

This should be deployed to Azure using an app service configured with a docker-compose configuration.

# Path mappings

Public assets should be created as an Azure Storage (files) share, and mounted as below.

Name: assetsmount
Mount Path: /app/public/assets
Type: AzureFiles

# Configuration

See the example docker-compose.yml, which should be customised for your app.

## SilverStripe

The PHP installation will need the following variables set

```
SS_ENVIRONMENT_TYPE
SS_TRUSTED_PROXY_IPS
SS_DEFAULT_ADMIN_USERNAME
SS_DEFAULT_ADMIN_PASSWORD
SS_DATABASE_SERVER
SS_DATABASE_USERNAME
SS_DATABASE_PASSWORD
SS_DATABASE_NAME
SS_BASE_URL
```

And also you can specify a custom variable for setting the frontend hostname. E.g. https://www.mysite.com

```
SS_APP_URL
```

In the CMS you could use this to override page-preview urls, since the frontend is no longer on the
same hostname as the CMS.

## Nginx

The nginx instance, which serves all web content to either node or silverstripe, needs the following
variables set

```
NGINX_HOST_API # Hostname for the silverstripe headless URL. E.g. api.mysite.com
NGINX_HOST_APP # Hostname for the frontend URL. E.g. www.mysite.com
```

## Node

The node instance will server and render frontend content. This uses the following variables:

``` 
API_URL # URL the frontend should use for accessing the backend API. e.g. https://api.mysite.com/graphql
```
