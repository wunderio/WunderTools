# Dockerfile for the Drupal container.
FROM wunderio/silta-php-fpm:7.3-fpm-v1

COPY --chown=www-data:www-data . /app

