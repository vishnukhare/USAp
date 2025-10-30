#  RECOMMENDED: Use a currently supported PHP version for security and performance
FROM php:8.2-apache

# Install necessary PHP extensions for MySQL connection
# Note: pdo_mysql is generally preferred for new development, but mysqli is common too.
# The command is the same.
RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && a2enmod rewrite # Optional: Enable Apache's rewrite module if you use clean URLs

# Copy the entire project into the web root
COPY . /var/www/html/

# Set permissions for the Apache user
RUN chown -R www-data:www-data /var/www/html

# Expose port (mostly informational)
EXPOSE 80

# Command to start Apache (default for this base image)
CMD ["apache2-foreground"]
