# docker-trax-lrs

A minimalist docker setup to test and develop on trax-lrs

## deployment

```
docker compose up
```

An admin account admin/thetotoro will be created for trax (see docker-compose.yml).

Acces with your browser to http://localhost:8899, and log in.

## Customization

### LAX LRS Environment

See the trax service environment in docker-compose.yml.

APP_NAME, APP_ENV, APP_URL, DB_HOST,DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD are the Laravel mandatory variables used by Trax LRS.

APP_DEBUG is an optional Laravel variable that can be set to true

APP_KEY and DB_CONNECTION are two other Laravel variables used by Trax LRS, given for documentation, but they should not be defined here

ADMIN_MAIL and ADMIN_PASSWORD are the initialization variable that will be used at first launch to create the Trax LRS admin account.

### php.ini and Apache httpd configuration

You can use your own configution at these paths:
- php.ini:  /usr/local/etc/php/php.ini (default given in images/trax/trax-php.ini)
- site.conf: /etc/apache2/sites-available/trax.conf (default given in images/trax/trax-apache.conf)

### admin CLI commands

Once the services started, you can execute laravel administration commands within a lax service shell:

```
docker compose exec -ti trax bash
```

Exemple of admin commands:

- `php artisan admin:create`
- `php artisan admin:list`
- `php artisan admin:update`
- `php artisan admin:delete`

