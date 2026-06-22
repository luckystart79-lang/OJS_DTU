FROM php:8.2-apache

# Copy php extension installer from official helper image
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install PHP extensions required by OJS
RUN install-php-extensions gd intl mbstring mysqli pdo_mysql xml xsl zip bcmath opcache apcu

# Enable Apache mod_rewrite for nice URLs in OJS
RUN a2enmod rewrite

# Increase PHP limits for upload size and memory limit to ensure smooth OJS operation
RUN echo "upload_max_filesize = 128M" > /usr/local/etc/php/conf.d/ojs-limits.ini \
    && echo "post_max_size = 128M" >> /usr/local/etc/php/conf.d/ojs-limits.ini \
    && echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/ojs-limits.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/ojs-limits.ini \
    && echo "display_errors = Off" >> /usr/local/etc/php/conf.d/ojs-limits.ini \
    && echo "log_errors = On" >> /usr/local/etc/php/conf.d/ojs-limits.ini \
    && echo "error_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE" >> /usr/local/etc/php/conf.d/ojs-limits.ini

# Cấu hình tối ưu hóa PHP OPcache và APCu cho môi trường phát triển
RUN { \
        echo 'opcache.enable=1'; \
        echo 'opcache.memory_consumption=256'; \
        echo 'opcache.interned_strings_buffer=16'; \
        echo 'opcache.max_accelerated_files=20000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.validate_timestamps=0'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'apc.enabled=1'; \
        echo 'apc.shm_size=128M'; \
        echo 'apc.enable_cli=1'; \
        echo 'apc.ttl=3600'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

WORKDIR /var/www/html

# Copy toàn bộ mã nguồn OJS vào container để chạy trên ổ đĩa Linux tốc độ cao
COPY . /var/www/html/

# Thiết lập quyền sở hữu cho Apache www-data và đảm bảo thư mục cache tồn tại
RUN mkdir -p /var/www/html/cache && chown -R www-data:www-data /var/www/html && chmod -R 775 /var/www/html/cache
