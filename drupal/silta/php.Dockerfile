# Dockerfile for the Drupal container.
FROM wunderio/silta-php-fpm:v0.1

COPY --chown=www-data:www-data . /app

