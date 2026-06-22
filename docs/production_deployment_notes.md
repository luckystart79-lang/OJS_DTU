# Tài liệu Cấu hình & Tối ưu hóa khi Triển khai OJS lên Server Public (Production)

Tài liệu này ghi lại chi tiết các giải pháp tối ưu hóa hiệu năng đã áp dụng trên môi trường local và cách thực hiện tương tự khi bạn đưa hệ thống lên máy chủ chính thức (Production Server) để đảm bảo tốc độ tối đa và bảo mật.

---

## 1. Bản chất của các bước tối ưu đã thực hiện

Khi chạy Docker trên Windows (qua WSL2), hiệu năng bị nghẽn nghiêm trọng nhất ở **Disk I/O** (do PHP phải truy cập hàng chục nghìn file qua ranh giới Windows-Linux) và **Bộ nhớ đệm đối tượng (Object Cache)** của OJS bị lỗi. Chúng ta đã tối ưu bằng cách:

### A. Tách biệt Môi trường Phát triển (Theme) và Lõi hệ thống (OJS Core)
*   **Local (Đã làm):** Đưa toàn bộ code lõi vào trong Docker image (`COPY . /var/www/html/`). Chỉ dùng bind-mount cho thư mục theme `plugins/themes/tckhcn/` và file cấu hình `config.inc.php`.
*   **Khi lên Server Public:**
    - **Khuyến nghị:** Vẫn nên tiếp tục sử dụng mô hình Docker này (Build code vào image). Điều này giúp việc triển khai (deploy) cực kỳ sạch sẽ, nhất quan và bảo mật (không sợ lộ file nguồn).
    - Nếu bạn deploy bằng VPS truyền thống (không dùng Docker mà cài trực tiếp Apache/Nginx + PHP trên Ubuntu): Do Linux có hệ thống tệp tin native (`ext4`) cực nhanh, bạn sẽ không bị lỗi trễ đĩa như trên Windows. Tuy nhiên, các bước cấu hình OPcache và APCu bên dưới vẫn **bắt buộc** phải áp dụng.

### B. Cấu hình OPcache tối ưu cho Production
OPcache lưu trữ mã PHP đã biên dịch (Opcode) vào RAM. Trên môi trường Production, chúng ta thiết lập:
```ini
opcache.enable=1
opcache.memory_consumption=256      ; Cấp 256MB RAM cho OPcache (mặc định chỉ có 64-128MB)
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=20000 ; Tăng giới hạn số lượng file cache (OJS có >15.000 file)
opcache.validate_timestamps=0       ; QUAN TRỌNG: Tắt kiểm tra file thay đổi trên đĩa
opcache.fast_shutdown=1
```
*   **Lưu ý khi vận hành:** Khi thiết lập `opcache.validate_timestamps=0`, mỗi khi bạn upload code mới hoặc chỉnh sửa file PHP trực tiếp, PHP sẽ **không** nhận diện ngay lập tức. Bạn cần reload hoặc restart dịch vụ Apache/PHP-FPM để xóa cache cũ và nạp code mới:
    ```bash
    # Nếu dùng Docker:
    docker compose restart app
    
    # Nếu dùng Nginx/Apache trực tiếp trên Ubuntu VPS:
    sudo systemctl reload php8.2-fpm  # hoặc service apache2 reload
    ```

### C. Kích hoạt bộ nhớ đệm APCu (Object Cache)
OJS lưu trữ cấu hình hệ thống, bản dịch ngôn ngữ và danh sách plugin đã kích hoạt vào Object Cache để tránh truy vấn cơ sở dữ liệu liên tục.
1.  **Cài đặt APCu:** Trên server, đảm bảo extension `APCu` được cài đặt và kích hoạt trong PHP (`apt-get install php-apcu` hoặc tương đương).
2.  **Cấu hình trong `config.inc.php`:**
    ```ini
    [cache]
    object_cache = apc
    ```
3.  **Polyfill tương thích ngược (Bắt buộc):** Do OJS 3.4 vẫn sử dụng các hàm `apc_fetch`, `apc_store` vốn đã bị loại bỏ ở PHP 8.2 (chỉ còn `apcu_*`), bạn cần giữ lại bộ Polyfill chúng ta đã chèn ở đầu tệp tin `lib/pkp/includes/functions.php`:
    ```php
    // Polyfill for APCu backwards compatibility in OJS
    if (!function_exists('apc_fetch') && function_exists('apcu_fetch')) {
        function apc_fetch($key, &$success = null) { return apcu_fetch($key, $success); }
        function apc_store($key, $var, $ttl = 0) { return apcu_store($key, $var, $ttl); }
        function apc_delete($key) { return apcu_delete($key); }
        function apc_cache_info($type = null) { return apcu_cache_info(); }
        function apc_clear_cache($type = null) { return apcu_clear_cache(); }
    }
    ```

---

## 2. Các cấu hình bổ sung bắt buộc khi Public Server (Bảo mật & Vận hành)

Khi đưa dự án lên chạy thực tế trên Internet, hãy đảm bảo bạn thay đổi các cấu hình sau trong file `config.inc.php` để bảo mật hệ thống:

### A. Tắt chế độ hiển thị lỗi (Display Errors)
Không được hiển thị lỗi trực tiếp ra màn hình vì hacker có thể dựa vào đó để khai thác đường dẫn hệ thống.
```ini
[debug]
show_stacktrace = Off
display_errors = Off
deprecation_warnings = Off
log_web_service_info = Off
```

### B. Cấu hình bảo mật Session & HTTPS
Nếu máy chủ chạy HTTPS (SSL), hãy bật các cấu hình sau:
```ini
[security]
force_ssl = On        ; Bắt buộc dùng HTTPS toàn trang
force_login_ssl = On  ; Bắt buộc HTTPS khi đăng nhập
```

### C. Thay đổi mã khóa bảo mật (Salt & Secrets)
Bạn phải thay đổi chuỗi bảo mật mặc định để tránh bị giả mạo cookie session hoặc token API:
```ini
[security]
salt = "Một_Chuỗi_Ký_Tự_Ngẫu_Nhiên_Dài_Và_Bảo_Mật_Chỉ_Bạn_Biết"
api_key_secret = "Một_Chuỗi_Khóa_Bảo_Mật_Khác_Cho_API"
```

### D. Giới hạn host được phép truy cập (Allowed Hosts)
Khai báo tên miền chính thức của bạn để tránh tấn công giả mạo tiêu đề Host (Host Header Injection):
```ini
[general]
allowed_hosts = '["yourdomain.com", "www.yourdomain.com"]'
```
