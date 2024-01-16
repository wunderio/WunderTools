# Dockerfile for the Drupal container.
FROM wunderio/silta-php-shell:php7.3-v1

COPY --chown=www-data:www-data . /app
