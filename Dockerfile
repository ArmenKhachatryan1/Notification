# Используем официальный образ PHP-FPM 8.2
FROM php:8.2-fpm

# Устанавливаем системные зависимости и расширения PHP
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Создаем рабочую директорию
WORKDIR /var/www

# Копируем файлы проекта
COPY . /var/www

# Даем права на запись (важно для Laravel)
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Порт, который будет использовать PHP-FPM
EXPOSE 9000

# Команда по умолчанию
CMD ["php-fpm"]
