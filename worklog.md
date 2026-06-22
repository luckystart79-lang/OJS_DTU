# Nhật ký Công việc (Worklog) - Dự án OJS TCKHCN

Tài liệu này ghi lại toàn bộ tiến độ, các công việc đã thực hiện, trạng thái hiện tại và định hướng phát triển tiếp theo cho hệ thống Tạp chí Khoa học và Công nghệ (TCKHCN).

---

## 1. Công việc Đã Hoàn Thành (Done)

### A. Thiết lập Môi trường Docker
*   **Dockerfile:** Triển khai container PHP 8.2-Apache cài đặt đầy đủ các PHP extensions yêu cầu bởi OJS (`gd`, `intl`, `mbstring`, `mysqli`, `xml`, `xsl`, `zip`, `opcache`, `apcu`).
*   **Docker Compose:** Cấu hình chạy ứng dụng trên cổng `8181` để tránh xung đột với các dịch vụ cục bộ khác (như XAMPP, Redmine). Cơ sở dữ liệu sử dụng MariaDB 10.6 trên cổng `33066` của host.
*   **Named Volumes:** Sử dụng named volumes `ojs_cache` và `ojs_db_data` chạy trực tiếp trên phân vùng Linux native của WSL2 để cải thiện tốc độ I/O.
*   **Cơ chế bảo mật file:** Tạo thư mục lưu trữ file an toàn `/var/www/files` nằm ngoài thư mục web root, liên kết với thư mục host `volumes/files/`.

### B. Khởi tạo Website & Dữ liệu Demo
*   **Cài đặt OJS thành công:** Đăng ký tài khoản Admin và kết nối DB tự động.
*   **Khởi tạo Journal `tckhcn`:** Cấu hình tạp chí chính thức có định danh là `tckhcn`.
*   **Nhập dữ liệu mẫu:** Nhập thành công tệp tin dữ liệu mẫu chuẩn của PKP (`sample-data.xml`), tạo sẵn 1 số xuất bản (Issue) và 2 bài báo mẫu (Submissions) giúp hiển thị giao diện đầy đủ thông tin, không bị trắng trang.

### C. Khởi tạo Child Theme `tckhcn`
*   Tạo bộ khung theme tùy biến tại thư mục `plugins/themes/tckhcn/` kế thừa cấu trúc từ `default` theme của OJS.
*   Thiết lập bảng màu học thuật hiện đại: màu chủ đạo xanh đậm `#0056b3`, font chữ hiện đại Google Fonts "Inter", tùy biến các nút bấm (`.pkp_button`) và phần chân trang (Footer).

### D. Tối ưu hóa Hiệu năng (Đặc biệt quan trọng)
*   **Tốc độ tăng ~32 lần:** Thời gian phản hồi trang giảm từ **3.5 giây** xuống còn **~100 mili-giây**.
*   **Giải pháp đĩa I/O:** Chuyển mã nguồn lõi OJS sang lưu trữ trực tiếp trong image container. Chỉ mount thư mục theme tùy biến ra ngoài máy host để lập trình viên chỉnh sửa.
*   **Giải pháp Cache:** 
    - Tắt kiểm tra cập nhật file PHP OPcache (`opcache.validate_timestamps=0`).
    - Viết bộ polyfill cho các hàm `apc_*` chuyển hướng sang `apcu_*` trong `lib/pkp/includes/functions.php`, giúp hệ thống kích hoạt thành công bộ nhớ đệm đối tượng (Object Cache).

### E. Seeding Dữ liệu 10 Bài báo Khoa học Tiêu chuẩn Quốc tế (Mới)
*   **Dữ liệu thực tế và chi tiết:** Nhập thành công 10 bài báo khoa học thực tế từ các trường/tạp chí lớn (Đại học Duy Tân, Đại học Cần Thơ, Đại học Toronto) thông qua công cụ dòng lệnh Native ImportExport CLI của OJS.
*   **Thông số tiêu chuẩn quốc tế:**
    - Cấu hình đầy đủ **bilingual metadata** (tiêu đề và tóm tắt song ngữ Anh - Việt).
    - Tích hợp mã định danh số **DOI** thực tế của các bài báo tương ứng.
    - Cung cấp danh sách trích dẫn đầy đủ (**References/Citations**) được chuẩn hóa theo định dạng **APA** hiển thị rõ ràng trên trang chi tiết bài viết.
    - Gắn kèm file PDF galleys đầy đủ hiển thị nút tải PDF trên trang chủ.
*   **Vá lỗi liên kết cơ sở dữ liệu:** Sửa lỗi thiếu liên kết `current_publication_id` trong bảng `submissions` sau khi nạp dữ liệu bằng script PHP CLI tự động để trang chủ OJS không bị lỗi 500.

### F. Tái cấu trúc Giao diện Trang chủ Đồng bộ Tạp chí Duy Tân (Mới)
*   **Bố cục hai cột "Số mới nhất":** Thiết kế lại khối `issue_toc.tpl` chia làm hai cột rõ rệt: cột trái (`col-sm-3` tương đương) chứa ảnh bìa và thông tin tập/số phát hành; cột phải (`col-sm-9` tương đương) hiển thị danh sách bài báo phân theo Chuyên mục.
*   **Bổ sung Khung Chuyên mục Tạp chí (Categories Grid):** Thêm khu vực hiển thị 6 chuyên mục khoa học đặc trưng ở trang chủ với ảnh minh họa học thuật chất lượng cao, có hiệu ứng hover mượt mà và nút liên kết tìm kiếm bài báo tương ứng.
*   **Lưu trữ tài nguyên cục bộ:** Tải thành công ảnh bìa chính thức từ máy chủ cục bộ (`638901484318742172-Bia.png`) và logo của Đại học Duy Tân vào gói theme để làm tài nguyên hiển thị nội bộ ổn định.
*   **Bố cục full-width & Loại bỏ Sidebar trang chủ:** Duy Tân không sử dụng Sidebar ở trang chủ. Chúng tôi đã thiết lập `$isFullWidth = true` tại `indexJournal.tpl` để ẩn hoàn toàn Sidebar ở trang chủ (chỉ giữ ở các trang con). Giao diện trang chủ lúc này hiển thị 3 khối lớn (Giới thiệu, Số mới nhất, Chuyên mục) rộng 100% cực kỳ thoáng đãng và đồng bộ 100% với website Duy Tân.
*   **Đồng bộ Header & Ảnh nền banner chính (Official Banner & Header):** Tải ảnh nền banner chính `banner2.png` từ máy chủ Duy Tân về cục bộ. Tái thiết kế khối đầu trang (`header.tpl`) theo cấu trúc lưới 2 cột: cột trái chứa logo, tên miền và chỉ số ISSN dạng pill viền trắng; cột phải chứa Tiêu đề chính và Subtitle **"ĐẠI HỌC DUY TÂN"** chữ vàng cam nổi bật trên nền banner đỏ của trường.

### G. Cập nhật Ảnh Giới thiệu & Màu nền Menu điều hướng (Mới)
*   **Tải ảnh giới thiệu (About banner) chính thức:** Tải ảnh từ địa chỉ nội bộ `http://10.80.80.11:8045/svruploads//journal-science/upload/images/638888621029669238-about.jpg` và lưu cục bộ tại `plugins/themes/tckhcn/images/journal_about_banner.jpg` thay cho tệp ảnh cũ.
*   **Cấu hình template:** Cập nhật `indexJournal.tpl` để trỏ đến tệp ảnh `.jpg` mới trong khối giới thiệu tạp chí.
*   **Thay đổi phong cách Menu điều hướng:**
    - Chuyển màu nền thanh menu `.navigation-bar` từ màu đen sang màu trắng (`#ffffff`), thêm viền mờ (top và bottom border) và giảm độ đậm bóng đổ (box-shadow).
    - Đổi màu chữ liên kết menu thành màu đen (`#2b2b2b`) và đổi thành màu đỏ đô Duy Tân (`#A32223`) trên nền xám nhạt (`#f8f9fa`) khi di chuột qua (hover).
    - Tùy biến lại ô tìm kiếm (Search bar) trong thanh menu để hòa hợp với tông màu nền trắng mới (nền xám nhạt, viền mờ, chuyển trắng khi focus).
*   **Xóa bộ nhớ đệm và biên dịch lại:** Xóa cache CSS/Template trong container Docker và thực hiện gọi các tệp tin để OJS tự động biên dịch lại tệp CSS.

*   **Kích hoạt các Plugin học thuật chuẩn quốc tế quan trọng (Mới)**
    - Đã kích hoạt trực tiếp trong cơ sở dữ liệu các plugin hỗ trợ quy trình học thuật, bao gồm: `crossrefplugin` (cấp mã DOI), `orcidprofileplugin` (xác thực ORCID tác giả/phản biện), `googleanalyticsplugin` (theo dõi truy cập), `staticpagesplugin` (quản trị trang tĩnh), `announcementfeedplugin` (bản tin thông báo), `recommendbysimilarityplugin` và `recommendbyauthorplugin` (tăng đề xuất đọc bài), cùng với `citationstylelanguageplugin` (tạo hộp trích dẫn chuẩn APA/MLA).
    - Đã làm sạch cache hệ thống trong container và xác nhận chạy thành công, kiểm thử các trang không xảy ra lỗi.

### I. Cấu hình Dữ liệu động cho Giới thiệu & Tái cấu trúc Menu Thả xuống (Dropdown) (Cập nhật)
*   **Dữ liệu động khối Giới thiệu:**
    - Loại bỏ văn bản mô tả cứng trong tệp template `indexJournal.tpl`.
    - Chèn bản dịch phần giới thiệu chính thức cho cả 2 ngôn ngữ (Tiếng Việt và Tiếng Anh) vào trường `description` trong bảng `journal_settings`.
*   **Menu điều hướng thả xuống động:**
    - Tạo các liên kết custom "Trang chủ" và "Số tạp chí" động trong DB.
    - Nhóm các mục liên quan vào menu con dạng thả xuống (dropdown) động: *Giới thiệu* (chứa Giới thiệu chung, Ban biên tập, Liên hệ) và *Số tạp chí* (chứa Số hiện hành, Số đã xuất bản) giúp sắp xếp gọn gàng và khoa học.
    - Thay đổi bộ chọn CSS từ `ul.sub-menu` sang bộ chọn tổng quát `ul` lồng trong `.menu-item` tại [index.less](file:///d:/OJS_TCKHCN/plugins/themes/tckhcn/styles/index.less) để nhận diện và hiển thị hiệu ứng dropdown đúng theo cấu trúc HTML mặc định của OJS.
*   **Cấu hình bản địa hóa đầy đủ cho OJS:**
    - Cập nhật các trường cấu hình `supportedFormLocales` và `supportedSubmissionLocales` thành `["vi","en"]` (trước đây bị thiếu `"vi"` khiến hệ thống không biên dịch nhãn menu). Các nhãn menu hệ thống hiện tại đã hiển thị chuẩn ngôn ngữ tự động (Tiếng Việt / Tiếng Anh) khi chuyển đổi.
    - Biên dịch và cập nhật trực tiếp trong DB toàn bộ các mã giữ chỗ dạng `##default.contextSettings.authorGuidelines##` sang văn bản hướng dẫn gửi bài bằng Tiếng Việt hoàn chỉnh, tránh hiển thị lỗi mã thô ở trang nộp bài.

### J. Tái thiết kế Chân trang (Footer) màu đỏ Duy Tân (Mới)
*   **Đồng bộ giao diện Footer:**
    - Tái cấu hình tệp `footer.tpl` sang bố cục 2 cột gọn gàng và cân đối (Cột trái: Thông tin Xuất bản kèm Logo trắng chính thức của trường; Cột phải: Thông tin Liên hệ chi tiết).
    - Thay đổi màu nền chân trang sang màu đỏ đô học thuật (`@primary-color`), đổi toàn bộ chữ sang màu trắng tương phản và cập nhật hiệu ứng hover của các liên kết.
    - Đặt các biểu tượng mạng xã hội (Facebook, Twitter, Youtube) trong các ô vuông bo góc viền trắng, tự động đổi màu nền trắng chữ đỏ khi hover để giống hệt giao diện gốc.
*   **Tích hợp Giấy phép CC BY 4.0:**
    - Gắn biểu tượng bản quyền mở Creative Commons BY 4.0 dạng âm bản trắng ở khu vực dưới thông tin xuất bản để đáp ứng chính xác tiêu chuẩn học thuật của các tạp chí quốc tế mà không gây ảnh hưởng đến thẩm mỹ chung của website.








---

## 2. Công việc Đang Thực Hiện (In Progress)
*   **Không có** (Tất cả các đầu việc đã được triển khai và xác nhận hoàn tất thành công).

---

## 3. Kế hoạch Tiếp theo (Next Steps / Plan)
*   **Tối ưu hóa sâu giao diện & các khối phụ:**
    - Thiết lập slide trình chiếu các bài báo tiêu biểu (Feature Slider).
    - Tạo các trang tĩnh cho Ban biên tập (Editorial Board) và Điểm công trình.


