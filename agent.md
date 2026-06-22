# Hướng dẫn Phát triển Dự án cho AI Agent & Lập trình viên (agent.md)

Chào mừng bạn đến với dự án tùy biến giao diện OJS cho Tạp chí Khoa học và Công nghệ (TCKHCN). Tài liệu này cung cấp toàn bộ thông tin kiến trúc, cấu trúc thư mục, quy tắc ghi đè template và quy trình làm việc để bạn tiếp tục phát triển giao diện riêng cho tạp chí.

---

## 1. Tổng quan Kiến trúc Giao diện OJS

*   Hệ thống chạy trên nền tảng **OJS 3.4.0-10**.
*   Giao diện của TCKHCN được xây dựng dưới dạng **Child Theme** (Theme con), kế thừa toàn bộ cấu trúc từ Parent Theme (Theme mặc định của OJS).
*   **Thư mục Theme nằm tại:** `plugins/themes/tckhcn/` (đã được bind-mount trực tiếp từ Windows vào container `/var/www/html/plugins/themes/tckhcn`).
*   **Theme cha kế thừa:** `defaultthemeplugin` (mã nguồn gốc nằm trong container tại `/var/www/html/plugins/themes/default`).

---

## 2. Các tệp tin quan trọng của Theme

*   [index.php](file:///d:/OJS_TCKHCN/plugins/themes/tckhcn/index.php): Khởi tạo và nạp class plugin.
*   [TckhcnThemePlugin.php](file:///d:/OJS_TCKHCN/plugins/themes/tckhcn/TckhcnThemePlugin.php): File logic chính của theme. Định nghĩa theme cha, nạp CSS/LESS, và đăng ký các hook tùy biến dữ liệu.
*   [styles/index.less](file:///d:/OJS_TCKHCN/plugins/themes/tckhcn/styles/index.less): Tệp stylesheet chính chứa các biến LESS tùy chỉnh (Màu sắc, phông chữ Inter).
*   [version.xml](file:///d:/OJS_TCKHCN/plugins/themes/tckhcn/version.xml): Cấu hình phiên bản của theme để OJS nhận diện.

---

## 3. Quy trình Tùy biến Template (HTML/Smarty)

OJS sử dụng công cụ render **Smarty Template Engine** với định dạng tệp tin `.tpl`. Để thay đổi giao diện HTML, hãy thực hiện theo các quy tắc sau:

### A. Quy tắc ghi đè (Override) tệp tin `.tpl`
1.  Xem cấu trúc thư mục `templates/` của theme cha tại `/var/www/html/plugins/themes/default/templates/` (hoặc các file tpl lõi tại `/var/www/html/lib/pkp/templates/`).
2.  Tạo thư mục `templates` tương ứng bên trong theme con: `plugins/themes/tckhcn/templates/`.
3.  Sao chép tệp `.tpl` muốn sửa đổi từ theme cha sang theme con với **đúng cấu trúc đường dẫn**.
    *   *Ví dụ:* Để tùy biến trang chủ tạp chí (`indexJournal.tpl`), bạn copy file:
        Từ: `/var/www/html/plugins/themes/default/templates/frontend/pages/indexJournal.tpl`
        Sang: `plugins/themes/tckhcn/templates/frontend/pages/indexJournal.tpl`
4.  Tiến hành chỉnh sửa tệp tin `.tpl` mới tạo ở theme con. OJS sẽ tự động ưu tiên nạp tệp này.

### B. Một số template quan trọng thường tùy biến:
*   `frontend/components/header.tpl`: Đầu trang (Logo, thanh điều hướng chính).
*   `frontend/components/footer.tpl`: Chân trang (Thông tin liên hệ, bản quyền).
*   `frontend/pages/indexJournal.tpl`: Trang chủ tạp chí (Hiển thị số mới nhất, mô tả tạp chí).
*   `frontend/pages/article.tpl`: Trang chi tiết bài báo (Hiển thị tóm tắt, PDF link, tác giả).

---

## 4. Quy trình làm việc & Đồng bộ hóa Cache (Rất quan trọng)

Do chúng ta đã cấu hình hệ thống tối ưu hóa hiệu năng tối đa trên môi trường Docker, lập trình viên cần lưu ý các cơ chế cache sau:

1.  **Khi sửa file CSS/LESS (`styles/*.less`):**
    *   Thay đổi được biên dịch lại tự động. Chỉ cần xóa cache trình duyệt (nhấn `Ctrl + F5`) để xem kết quả.
2.  **Khi sửa file Template Smarty (`templates/**/*.tpl`):**
    *   Smarty biên dịch `.tpl` thành file PHP trong thư mục `/var/www/html/cache/t_compile`.
    *   Nếu không thấy thay đổi hiển thị, hãy vào trang quản trị OJS: **Administration > Clear Template Cache** để làm mới.
3.  **Khi sửa file PHP (`TckhcnThemePlugin.php` hoặc `index.php`):**
    *   Do bật `opcache.validate_timestamps=0` để tăng tốc độ phản hồi, PHP sẽ **không tự động nhận diện** thay đổi trong file `.php` trên host.
    *   **Bắt buộc** phải khởi động lại container Apache để giải phóng bộ nhớ OPcache:
        ```bash
        docker compose restart app
        ```

---

## 5. Kế hoạch Phát triển Giao diện Tiếp theo (Plan)

*   [ ] **Tạo trang chủ tạp chí riêng (Custom Homepage):** Thay đổi bố cục trang chủ TCKHCN. Bổ sung slide/carousel giới thiệu ảnh bìa tạp chí, bài báo nổi bật và thông báo mới nhất.
*   [ ] **Thiết kế Footer chuyên nghiệp:** Cấu hình chân trang chứa thông tin chi tiết về cơ quan chủ quản, Giấy phép xuất bản, Chỉ số ISSN, địa chỉ liên hệ và liên kết tới các hệ thống chỉ mục (Google Scholar, VCAD...).
*   [ ] **Tùy biến Khung thông tin bài báo (Article Page Layout):** Tách biệt rõ ràng phần Tóm tắt (Abstract), Thông tin tác giả, Tài liệu tham khảo (References) và nút tải PDF/HTML tiện lợi.
