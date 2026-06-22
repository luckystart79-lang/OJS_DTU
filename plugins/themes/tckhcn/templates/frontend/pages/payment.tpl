{**
 * plugins/themes/tckhcn/templates/frontend/pages/payment.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief Dynamic VietQR Payment Page for authors.
 *
 * Author: Vo Van Thuan - Trung Tâm CNPM CSE
 *}
{include file="frontend/components/header.tpl" pageTitle="common.payment"}

<div class="container page-container my-5">
	<div class="page page_payment">
		<div class="row justify-content-center">
			<div class="col-lg-10">
				
				{* Header section *}
				<div class="payment-header text-center mb-5 no-print">
					<h1 class="font-weight-bold text-uppercase" style="color: #A32223; font-size: 2rem; margin-bottom: 10px;">
						Hóa Đơn Thanh Toán Lệ Phí
					</h1>
					<p class="text-muted text-uppercase" style="letter-spacing: 2px; font-size: 0.9rem;">
						Article Fee Invoice
					</p>
					<hr style="width: 80px; border-top: 3px solid #A32223; margin: 0 auto;">
				</div>

				<div class="card shadow-sm border-0" style="border-radius: 12px; overflow: hidden; background: #ffffff;">
					{* Top border *}
					<div style="height: 6px; background-color: #A32223;"></div>
					
					<div class="card-body p-4 p-md-5">
						<div class="row">
							
							{* Column 1: Invoice details *}
							<div class="col-md-7 mb-4 mb-md-0">
								<h3 class="mb-4 font-weight-bold text-dark pb-2" style="border-bottom: 2px solid #f0f0f0; font-size: 1.3rem;">
									Thông tin bài báo / <span style="font-size: 0.95rem; color: #888; font-weight: normal;">Details</span>
								</h3>
								
								<table class="table table-borderless table-sm mb-4" style="font-size: 0.95rem;">
									<tbody>
										<tr>
											<td style="width: 30%; font-weight: 600; color: #555;">Mã bài viết:</td>
											<td class="font-weight-bold" style="color: #A32223;">#{$paySubmissionId}</td>
										</tr>
										<tr>
											<td style="font-weight: 600; color: #555;">Tên bài viết:</td>
											<td class="text-dark font-weight-bold" style="line-height: 1.4;">{$payTitle|escape}</td>
										</tr>
										<tr>
											<td style="font-weight: 600; color: #555;">Tác giả:</td>
											<td class="text-muted">{$payAuthors|escape}</td>
										</tr>
										<tr>
											<td style="font-weight: 600; color: #555;">Loại lệ phí:</td>
											<td class="text-dark">
												<span class="badge badge-danger p-2" style="background-color: rgba(163, 34, 35, 0.1); color: #A32223; font-size: 0.85rem; border-radius: 4px;">
													{$payFeeLabelVi}
												</span>
												<div class="text-muted small mt-1">{$payFeeLabelEn}</div>
											</td>
										</tr>
										<tr>
											<td style="font-weight: 600; color: #555; vertical-align: middle;">Số tiền cần nộp:</td>
											<td class="font-weight-bold text-dark" style="font-size: 1.4rem;">
												{$payAmount|number_format:0:",":"."} VND
											</td>
										</tr>
									</tbody>
								</table>

								<h3 class="mb-4 font-weight-bold text-dark pb-2" style="border-bottom: 2px solid #f0f0f0; font-size: 1.3rem;">
									Thông tin tài khoản / <span style="font-size: 0.95rem; color: #888; font-weight: normal;">Bank info</span>
								</h3>

								<table class="table table-borderless table-sm mb-0" style="font-size: 0.95rem;">
									<tbody>
										<tr>
											<td style="width: 30%; font-weight: 600; color: #555;">Ngân hàng:</td>
											<td class="text-dark">{$payBank|escape}</td>
										</tr>
										<tr>
											<td style="font-weight: 600; color: #555;">Số tài khoản:</td>
											<td class="text-dark font-weight-bold">{$payAccountNumber|escape}</td>
										</tr>
										<tr>
											<td style="font-weight: 600; color: #555;">Tên tài khoản:</td>
											<td class="text-dark text-uppercase font-weight-bold">{$payAccountName|escape}</td>
										</tr>
										<tr>
											<td style="font-weight: 600; color: #555;">Nội dung CK:</td>
											<td>
												<span class="badge badge-dark p-2 text-monospace" style="font-size: 1rem; background-color: #2b2b2b; color: #fff; border-radius: 4px; letter-spacing: 0.5px;">
													{$payDescription|escape}
												</span>
											</td>
										</tr>
									</tbody>
								</table>
							</div>

							{* Column 2: QR Code & Transfer instructions *}
							<div class="col-md-5 text-center d-flex flex-column align-items-center justify-content-center" style="border-left: 1px dashed #e2e2e2;">
								
								<div class="qr-container p-3 mb-3 bg-light rounded" style="border: 1px solid #eaeaea;">
									<img src="{$payQrUrl}" alt="VietQR Payment Code" class="img-fluid" style="max-width: 250px; display: block; margin: 0 auto;">
								</div>

								<div class="alert alert-warning text-left p-3 mb-0" style="font-size: 0.8rem; border-radius: 6px; border-left: 4px solid #ffc107; background-color: #fffbeb;">
									<h5 class="alert-heading font-weight-bold mb-1" style="font-size: 0.85rem; color: #856404;">
										<i class="fa fa-exclamation-triangle"></i> LƯU Ý QUAN TRỌNG:
									</h5>
									<p class="mb-0" style="line-height: 1.4; color: #856404;">
										Mã QR đã chứa sẵn số tiền và nội dung chuyển khoản tự động. Vui lòng <strong>không tự ý thay đổi nội dung chuyển khoản</strong> để bộ phận kế toán đối soát giao dịch chính xác.
									</p>
								</div>
							</div>
						</div>

						{* Footer button area *}
						<div class="row mt-5 pt-4 no-print" style="border-top: 1px solid #f0f0f0;">
							<div class="col-12 d-flex justify-content-between flex-wrap gap-2">
								<a href="{url page="index"}" class="btn btn-outline-secondary" style="border-radius: 4px; padding: 10px 20px; font-weight: 600;">
									<i class="fa fa-arrow-left"></i> Quay lại Trang chủ
								</a>
								<button onclick="window.print();" class="btn btn-danger" style="background-color: #A32223; border-color: #A32223; border-radius: 4px; padding: 10px 25px; font-weight: 600;">
									<i class="fa fa-print"></i> In hóa đơn / Lưu PDF
								</button>
							</div>
						</div>

					</div>
				</div>

				{* Printable styling details *}
				<style type="text/css">
					@media print {
						body * {
							visibility: hidden;
						}
						.page_payment, .page_payment * {
							visibility: visible;
						}
						.page_payment {
							position: absolute;
							left: 0;
							top: 0;
							width: 100%;
						}
						.no-print {
							display: none !important;
						}
						.card {
							box-shadow: none !important;
							border: none !important;
						}
						.col-md-5 {
							border-left: none !important;
							margin-top: 30px;
						}
					}
				</style>

			</div>
		</div>
	</div>
</div>

{include file="frontend/components/footer.tpl"}
