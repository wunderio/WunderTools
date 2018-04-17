# Dockerfile for the Drupal container.
FROM wodby/drupal-php:7.1-3.3.1

COPY --chown=www-data:www-data . /var/www/html
RUN chown -R www-data:www-data /var/www/html/web/sites/default/files
USER www-data

