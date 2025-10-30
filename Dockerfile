# RECOMMENDED: Use a currently supported PHP version for security and performance
FROM php:8.2-apache

# Install necessary PHP extensions for MySQL connection
RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && a2enmod rewrite # Optional: Enable Apache's rewrite module if you use clean URLs

# --- START: K8s Dependency Addition ---
# Install wget to fetch the script, then download and set permissions for wait-for-it.sh
RUN apt-get update && apt-get install -y wget \
    && wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/bin/wait-for-it.sh \
    && chmod +x /usr/bin/wait-for-it.sh \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# --- END: K8s Dependency Addition ---

    
# Copy the entire project into the web root
COPY . /var/www/html/

# Set permissions for the Apache user
RUN chown -R www-data:www-data /var/www/html

# Expose port (mostly informational)
EXPOSE 80

# Command to start Apache (default for this base image)
CMD ["apache2-foreground"]