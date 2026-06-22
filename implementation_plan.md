# Kế Hoạch Custom Nâng Cấp Hệ Thống Tạp Chí Khoa Học Và Công Nghệ Đại Học Duy Tân

Kế hoạch này vạch ra lộ trình kỹ thuật chi tiết để nâng cấp hệ thống OJS của Tạp chí Khoa học và Công nghệ Đại học Duy Tân (DTU TCKHCN) nhằm hướng tới sự chuyên nghiệp, tự động hóa quy trình xuất bản, và đáp ứng đầy đủ cả hai tiêu chí: **Chuẩn hóa Quốc tế** (phục vụ mục tiêu lập chỉ mục Google Scholar, DOAJ, Scopus, WoS) và **Quy định Việt Nam** (đáp ứng tiêu chuẩn của Hội đồng Giáo sư Nhà nước - HĐGSNN).

Tất cả các thay đổi sẽ được phát triển dưới dạng **Theme custom** và **Generic Plugins** độc làm, đảm bảo giữ mã nguồn lõi OJS nguyên bản, an toàn và dễ dàng nâng cấp (upgrade-safe).

---

## 1. Kế Hoạch Chi Tiết Các Hạng Mục Custom

### Hạng mục 1: Chuẩn Hóa Quốc Tế (International Indexing)

#### A. Tối ưu hóa Metadata & SEO (Google Scholar, DOAJ, Scopus)
*   **Mục tiêu**: Đảm bảo các hệ thống thu thập thông tin tự động (Web scrapers/Crawlers) của Google Scholar và Scopus có thể lập chỉ mục chính xác 100%.
*   **Giải pháp**:
    *   Cấu hình chính xác plugin `Dublin Core` và `Google Scholar` mặc định của OJS.
    *   Tối ưu hóa file template chi tiết bài báo [article_details.tpl](file:///d:/OJS_TCKHCN/plugins/themes/tckhcn/templates/frontend/objects/article_details.tpl) để in ra đầy đủ các thẻ meta chứa thông tin: Tên tác giả, Học hàm/Học vị, Đơn vị công tác, Tóm tắt (Abstract), Từ khóa (Keywords) bằng cả 2 ngôn ngữ.
*   **Tính năng bổ sung**: Tích hợp mã định danh quốc tế **ORCID** trực tiếp vào hồ sơ tác giả khi nộp bài để tự động đồng bộ hồ sơ khoa học toàn cầu.

#### B. Tự động hóa đăng ký và cấp phát DOI (Crossref)
*   **Mục tiêu**: Tự động hóa hoàn toàn việc đẩy siêu dữ liệu (metadata) lên tổ chức Crossref để đăng ký số định danh số DOI cho từng bài viết.
*   **Giải pháp**:
    *   Kích hoạt và cấu hình plugin `Crossref Reference Linking` và `Crossref XML Export Plugin` trong quản trị OJS.
    *   Cấu hình tiền tố DOI (Prefix) do Đại học Duy Tân cung cấp.
    *   Thiết lập cơ chế tự động gửi (Auto-deposit) metadata lên hệ thống Crossref ngay khi một Số (Issue) mới được xuất bản.

---

### Hạng mục 2: Chuẩn Hóa Theo Quy Định Việt Nam (HĐGSNN)

#### A. Trang Hội Đồng Biên Tập (Editorial Board) Động & Chuyên Nghiệp
*   **Mục tiêu**: Hiển thị danh sách Hội đồng Biên tập khoa học một cách trang trọng, khoa học và dễ dàng cập nhật thông qua admin.
*   **Giải pháp**:
    *   Tận dụng hệ thống nhóm người dùng (User Groups) trong OJS để phân loại thành viên Hội đồng Biên tập (ví dụ: Tổng biên tập, Phó tổng biên tập, Ủy viên hội đồng).
    *   Viết code template để tự động truy vấn danh sách này từ database và hiển thị ra trang riêng biệt ở Frontend.
    *   Mỗi thành viên hiển thị kèm: Học hàm/Học vị, Chức vụ khoa học, Cơ quan công tác, liên kết hồ sơ Google Scholar/ORCID và email liên hệ.

#### B. Mẫu Phiếu Phản Biện Online Chuẩn HĐGSNN
*   **Mục tiêu**: Loại bỏ việc trao đổi file Word phản biện thủ công qua email, chuẩn hóa phiếu đánh giá trực tiếp trực tuyến.
*   **Giải pháp**:
    *   Cấu hình hệ thống **Review Forms** của OJS 3.4.
    *   Xây dựng các bộ câu hỏi phản biện chuẩn bao gồm cả dạng chấm điểm (Rating) và dạng nhận xét tự do (Open text) theo biểu mẫu của Hội đồng Giáo sư Nhà nước.
    *   Hỗ trợ song ngữ (Anh/Việt) tự động tùy thuộc vào ngôn ngữ của người phản biện.

---

### Hạng mục 3: Tính Năng Nâng Cao Vượt Trội

#### A. Quy Trình Kiểm Tra Đạo Văn (Plagiarism Workflow)
*   **Mục tiêu**: Đảm bảo mọi bài viết trước khi đưa vào phản biện đều được kiểm tra độ trùng lặp và lưu trữ lịch sử kiểm định.
*   **Giải pháp**:
    *   *Tích hợp quy trình*: Thêm bước tải lên Báo cáo Đạo văn (Plagiarism Report) trong phần điều phối bài viết của Biên tập viên (Editor Submission Workflow). Bài viết chỉ được duyệt chuyển sang phản biện khi đã đính kèm file báo cáo đạo văn đạt chỉ số cho phép (ví dụ: <20%).
    *   *Tích hợp tự động*: Phát triển hoặc tích hợp API kết nối trực tiếp với Turnitin/iThenticate hoặc hệ thống quét đạo văn do trường lựa chọn để tự động chấm điểm trùng lặp ngay khi file bài báo được upload lên hệ thống.

#### B. Tích Hợp QR Code Thanh Toán Phí Đăng Bài Tự Động (VietQR)
*   **Mục tiêu**: Giảm thiểu việc tác giả chuyển khoản nhầm số tiền hoặc ghi sai nội dung chuyển khoản, giúp bộ phận kế toán tạp chí đối soát giao dịch tức thì.
*   **Giải pháp**:
    *   Viết một Block Plugin hoặc bổ dung vào luồng gửi bài/phê duyệt của tác giả.
    *   Khi có thông báo đóng lệ phí phản biện hoặc phí xuất bản, hệ thống sẽ tự động tính toán số tiền và tạo mã **VietQR** (chuẩn NAPAS 247).
    *   Mã QR chứa:
        *   Tài khoản nhận tiền của Tạp chí Duy Tân.
        *   Số tiền chính xác.
        *   Nội dung chuyển khoản tự động được sinh ra theo định dạng: `TCKHCN [Mã bài báo] [Tên tác giả]`.

#### C. Thống Kê Số Liệu Khoa Học Trực Quan (Advanced Metrics)
*   **Mục tiêu**: Tăng tính tương tác, minh chứng cho sức ảnh hưởng của bài báo đối với cộng đồng nghiên cứu.
*   **Giải pháp**:
    *   Phát triển widget thống kê trực quan (sử dụng Chart.js hoặc thư viện đồ họa tối ưu) hiển thị:
        *   Số lượt xem bài viết (Abstract views).
        *   Số lượt tải file PDF bài viết (PDF downloads).
    *   Tích hợp API của **Crossref Event Data** hoặc **Dimensions** để hiển thị số lượt bài viết được trích dẫn (Citations count) trên thế giới.

---

## 2. Lộ Trình Triển Khai (Roadmap)

### Pha 1: Cấu Hình Chuẩn Hóa Hệ Thống & Giao Diện (Tuần 1)
1. Cấu hình hoàn chỉnh đa ngôn ngữ hệ thống thư viện và email tự động trong OJS.
2. Thiết lập cấu trúc Chuyên mục (Sections) và cấu hình phân vai người dùng (Hội đồng biên tập).
3. Thiết lập các mẫu biểu mẫu phản biện (Review Forms) online trực tiếp trên admin.

### Pha 2: Cài Đặt & Phát Triển Plugins Tích Hợp (Tuần 2)
1. Kích hoạt và cấu hình DOI/Crossref Plugin, nạp file XML thử nghiệm lên Crossref.
2. Viết plugin tự động tạo mã VietQR thanh toán phí phản biện/xuất bản cho tác giả.
3. Chỉnh sửa Theme custom để hiển thị trang Hội Đồng Biên Tập động và tối ưu hóa các thẻ meta Google Scholar.

### Pha 3: Triển Khai Tính Năng Nâng Cao & Kiểm Thử (Tuần 3)
1. Cài đặt các widget thống kê lượt truy cập, lượt tải bài viết.
2. Tích hợp quy trình kiểm soát đạo văn vào workflow.
3. Chạy thử toàn trình (Từ khâu Tác giả nộp bài -> Biên tập viên kiểm tra đạo văn & QR phí -> Gửi phản biện điền form online -> Biên tập duyệt -> Xuất bản tự động cấp DOI -> Lập chỉ mục).

---

## 3. Câu Hỏi Mở Cần Ý Kiến Từ Anh/Chị

> [!IMPORTANT]
> **1. Tài khoản đăng ký DOI (Crossref):**
> Trường Đại học Duy Tân đã có sẵn tài khoản thành viên (Membership) với tổ chức Crossref chưa? Nếu đã có, chúng ta chỉ cần điền mã tiền tố (Prefix), username và password của trường vào cấu hình OJS là có thể kích hoạt tính năng tự động cấp DOI.
> 
> **2. Dịch vụ Kiểm tra đạo văn (Plagiarism Checker):**
> Trường hiện tại đang sử dụng công cụ kiểm tra đạo văn nào chính thức (Turnitin, iThenticate, DoMetis hay công cụ nào khác)? Chúng ta sẽ căn cứ vào đây để đưa ra giải pháp tích hợp API tự động hoặc xây dựng luồng đính kèm báo cáo thủ công.
