# Dockerfile for the Drupal container.
FROM wunderio/silta-php-shell:v0.1

COPY --chown=www-data:www-data . /app
