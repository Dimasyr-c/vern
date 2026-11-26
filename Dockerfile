FROM php:8.3-cli-alpine

# Install system dependencies and Postgres library
RUN apk add --no-cache \
    postgresql-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_pgsql bcmath

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy project files
COPY . .

# Install dependencies and build assets
RUN composer install --no-dev --optimize-autoloader --no-interaction
RUN npm install && npm run build

ENV PORT=10000
EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=${PORT}
