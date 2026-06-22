<?php

/**
 * @file plugins/themes/tckhcn/TckhcnThemePlugin.php
 *
 * Main class for TCKHCN theme.
 *
 * Author: Vo Van Thuan - Trung Tâm CNPM CSE
 */

namespace APP\plugins\themes\tckhcn;

use PKP\facades\Locale;
use PKP\plugins\Hook;

class TckhcnThemePlugin extends \PKP\plugins\ThemePlugin
{
    /** @var bool Recursion guard for payment page display */
    protected static $_isProcessingPayment = false;

    /**
     * @copydoc ThemePlugin::register
     */
    public function register($category, $path, $mainContextId = null)
    {
        $success = parent::register($category, $path, $mainContextId);
        if ($success) {
            // Register backend styles hook ALWAYS, even if this theme is not active in the current context
            // so that the admin dashboard layout is customized site-wide.
            \PKP\plugins\Hook::add('TemplateManager::display', [$this, 'addAdminStyles']);
        }
        return $success;
    }

    /**
     * Khởi tạo theme. Kế thừa từ default theme và nạp thêm file CSS/LESS tùy biến.
     */
    public function init()
    {
        // Load parent theme manually if it is not registered (OJS 3.4 context loading workaround)
        if (!\PKP\plugins\PluginRegistry::getPlugin('themes', 'defaultthemeplugin')) {
            \PKP\plugins\PluginRegistry::loadPlugin('themes', 'default');
        }

        // Kế thừa toàn bộ giao diện, cấu trúc và tính năng từ theme mặc định
        $this->setParent('defaultthemeplugin');




        // Nạp phông chữ Inter hiện đại
        $this->addStyle('fontInter', 'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap', ['contexts' => 'frontend', 'baseUrl' => '']);

        // Nạp stylesheet tùy biến để chỉnh sửa màu sắc, phông chữ, bố cục
        $this->addStyle('tckhcn-styles', 'styles/index.less');

        // Hook để nạp dữ liệu đa ngôn ngữ và danh sách chuyên mục
        Hook::add('TemplateManager::display', [$this, 'loadTemplateData']);

        // Cấu hình các tùy chọn (Theme Options) cho VietQR
        $this->addOption('vietqrBank', 'FieldText', [
            'label' => 'VietQR Bank Code (e.g. mbbank, vietcombank, bidv, acb)',
            'description' => 'Tên viết tắt của ngân hàng nhận lệ phí (theo chuẩn VietQR.io).',
            'default' => 'mbbank',
        ]);
        $this->addOption('vietqrAccountNumber', 'FieldText', [
            'label' => 'VietQR Account Number',
            'description' => 'Số tài khoản ngân hàng nhận lệ phí.',
            'default' => '1234567890',
        ]);
        $this->addOption('vietqrAccountName', 'FieldText', [
            'label' => 'VietQR Account Name',
            'description' => 'Tên chủ tài khoản (VIẾT HOA KHÔNG DẤU).',
            'default' => 'TAP CHI KHCN DTU',
        ]);
        $this->addOption('vietqrReviewFee', 'FieldText', [
            'label' => 'Peer Review Fee (VND)',
            'description' => 'Lệ phí phản biện bài báo (ví dụ: 500000).',
            'default' => '500000',
        ]);
        $this->addOption('vietqrPublishFee', 'FieldText', [
            'label' => 'Publication Fee (VND)',
            'description' => 'Lệ phí xuất bản bài báo (ví dụ: 1000000).',
            'default' => '1000000',
        ]);
    }

    /**
     * Load custom data for templates (multilingual locales & sections)
     */
    public function loadTemplateData($hookName, $args)
    {
        $templateMgr = $args[0];
        $template = $args[1];

        // Check if we are in the frontend context and not a console/cron request
        if (!defined('SESSION_DISABLE_INIT') && php_sapi_name() !== 'cli') {
            $request = \Application::get()->getRequest();
            $context = $request->getContext();

            // List of backend administration page names
            $backendPages = [
                'submissions', 'management', 'manager', 'settings', 'stats', 'dois',
                'workflow', 'decision', 'authorDashboard', 'reviewer'
            ];

            $router = $request->getRouter();
            $page = $request->getRequestedPage();
            
            $isBackend = ($router instanceof \PKP\core\PKPComponentRouter)
                || ($router instanceof \PKP\core\APIRouter)
                || in_array($page, $backendPages);

            if (!$isBackend) {
                // We are in frontend context!
                
                // Check if user has requested to set the frontend locale
                $setFrontendLocale = $request->getUserVar('setFrontendLocale');
                if ($setFrontendLocale && in_array($setFrontendLocale, ['vi', 'en'])) {
                    // Set frontend locale cookie for 30 days
                    if (!headers_sent()) {
                        setcookie('frontendLocale', $setFrontendLocale, time() + 30 * 86400, '/');
                    }
                    $_COOKIE['frontendLocale'] = $setFrontendLocale;

                    // Clean URL by removing the setFrontendLocale query param to keep it neat
                    $uri = $_SERVER['REQUEST_URI'] ?? '/';
                    $cleanUri = preg_replace('/[?&]setFrontendLocale=[^&]*/', '', $uri);
                    $cleanUri = rtrim($cleanUri, '?');
                    if (empty($cleanUri)) {
                        $cleanUri = '/';
                    }
                    $request->redirectUrl($cleanUri);
                    exit;
                }

                // Determine locale from cookie, fallback to 'vi'
                $frontendLocale = $_COOKIE['frontendLocale'] ?? 'vi';
                
                // Explicitly set the OJS runtime locale for this request
                Locale::setLocale($frontendLocale);

                // Override template manager variables
                $templateMgr->assign('currentLocale', $frontendLocale);
                $templateMgr->assign('currentLocaleLangDir', Locale::getMetadata($frontendLocale)?->isRightToLeft() ? 'rtl' : 'ltr');
            }

            // 1. Assign languageToggleLocales for the language switcher
            $locales = $context ? $context->getSupportedLocaleNames() : $request->getSite()->getSupportedLocaleNames();
            $templateMgr->assign('languageToggleLocales', $locales);

            // Build dynamic toggle URLs for frontend flags
            $currentUrl = $_SERVER['REQUEST_URI'] ?? '/';
            $currentUrl = preg_replace('/[?&]setFrontendLocale=[^&]*/', '', $currentUrl);
            $separator = (strpos($currentUrl, '?') === false) ? '?' : '&';
            $templateMgr->assign('toggleUrlVi', $currentUrl . $separator . 'setFrontendLocale=vi');
            $templateMgr->assign('toggleUrlEn', $currentUrl . $separator . 'setFrontendLocale=en');

            // 2. Assign sections if rendering the homepage
            if ($template === 'frontend/pages/indexJournal.tpl' && $context) {
                $sections = \APP\facades\Repo::section()->getCollector()
                    ->filterByContextIds([$context->getId()])
                    ->getMany()
                    ->all();
                $templateMgr->assign('homepageSections', $sections);
            }

            // 2b. Assign statistics if rendering the article detail page
            if ($template === 'frontend/pages/article.tpl') {
                $article = $templateMgr->getTemplateVars('article');
                if ($article) {
                    $articleId = (int) $article->getId();
                    
                    $stats = \Illuminate\Support\Facades\DB::select(
                        "SELECT 
                            DATE_FORMAT(date, '%Y-%m') AS month_str,
                            SUM(CASE WHEN assoc_type = 1048585 THEN metric ELSE 0 END) AS views,
                            SUM(CASE WHEN assoc_type = 521 THEN metric ELSE 0 END) AS downloads
                         FROM metrics_submission
                         WHERE submission_id = ?
                         GROUP BY month_str
                         ORDER BY month_str ASC",
                        [$articleId]
                    );
                    
                    $labels = [];
                    $views = [];
                    $downloads = [];
                    $totalViews = 0;
                    $totalDownloads = 0;
                    
                    foreach ($stats as $row) {
                        $parts = explode('-', $row->month_str);
                        $formattedMonth = $parts[1] . '/' . $parts[0]; // e.g. 06/2026
                        $labels[] = $formattedMonth;
                        $views[] = (int) $row->views;
                        $downloads[] = (int) $row->downloads;
                        $totalViews += (int) $row->views;
                        $totalDownloads += (int) $row->downloads;
                    }
                    
                    // Fallback: If no stats found, show last 6 months as 0
                    if (empty($labels)) {
                        for ($i = 5; $i >= 0; $i--) {
                            $time = strtotime("-{$i} months");
                            $labels[] = date('m/Y', $time);
                            $views[] = 0;
                            $downloads[] = 0;
                        }
                    }
                    
                    $templateMgr->assign([
                        'tckhcnStatsLabels' => $labels,
                        'tckhcnStatsViews' => $views,
                        'tckhcnStatsDownloads' => $downloads,
                        'tckhcnTotalViews' => $totalViews,
                        'tckhcnTotalDownloads' => $totalDownloads,
                    ]);
                }
            }

            // 3. Assign Editorial Board members if rendering the editorial team page
            if ($template === 'frontend/pages/editorialTeam.tpl' && $context) {
                $members = [];
                
                // Fetch user groups in this context with Role ID 16 (Manager/Editor-in-Chief) and 17 (Sub Editor/Editorial Board)
                $userGroups = \Illuminate\Support\Facades\DB::select(
                    "SELECT ug.user_group_id, ugs.setting_value AS group_name 
                     FROM user_groups ug 
                     JOIN user_group_settings ugs ON ug.user_group_id = ugs.user_group_id 
                     WHERE ug.context_id = ? AND ug.role_id IN (16, 17) AND ugs.setting_name = 'name' AND ugs.locale = ?",
                    [$context->getId(), Locale::getLocale()]
                );
                
                foreach ($userGroups as $ug) {
                    $usersInGroup = \APP\facades\Repo::user()->getCollector()
                        ->filterByContextIds([$context->getId()])
                        ->filterByUserGroupIds([$ug->user_group_id])
                        ->getMany();
                        
                    if ($usersInGroup->count() > 0) {
                        $groupMembers = [];
                        foreach ($usersInGroup as $u) {
                            $groupMembers[] = [
                                'id' => $u->getId(),
                                'fullName' => $u->getFullName(),
                                'affiliation' => $u->getLocalizedAffiliation(),
                                'orcid' => $u->getData('orcid'),
                                'url' => $u->getUrl(),
                                'email' => $u->getEmail()
                            ];
                        }
                        $members[] = [
                            'groupName' => $ug->group_name,
                            'members' => $groupMembers
                        ];
                    }
                }
                $templateMgr->assign('editorialBoardGroups', $members);
            }

            // 4. Intercept request for dynamic VietQR Payment Page
            if ($request->getUserVar('payment') && $context && !self::$_isProcessingPayment) {
                self::$_isProcessingPayment = true;
                $submissionId = (int) $request->getUserVar('submissionId');
                $feeType = $request->getUserVar('feeType') === 'publish' ? 'publish' : 'review';
                
                if ($submissionId) {
                    $submission = \APP\facades\Repo::submission()->get($submissionId);
                    
                    if ($submission && $submission->getContextId() === $context->getId()) {
                        $publication = $submission->getCurrentPublication();
                        $title = $publication->getLocalizedTitle();
                        
                        $authors = $publication->getData('authors');
                        $authorNames = [];
                        foreach ($authors as $author) {
                            $authorNames[] = $author->getFullName();
                        }
                        $authorString = implode(', ', $authorNames);
                        $firstAuthor = count($authorNames) > 0 ? $authorNames[0] : 'Author';
                        
                        // Clean author name for transfer description (no accents, alphanumeric only)
                        $cleanAuthor = $this->_cleanString($firstAuthor);
                        
                        // Retrieve VietQR options
                        $bank = $this->getOption('vietqrBank');
                        $accountNumber = $this->getOption('vietqrAccountNumber');
                        $accountName = $this->getOption('vietqrAccountName');
                        
                        if ($feeType === 'publish') {
                            $amount = (int) $this->getOption('vietqrPublishFee');
                            $feeLabelVi = 'Lệ phí xuất bản bài báo';
                            $feeLabelEn = 'Publication Fee';
                            $descCode = 'XUATBAN';
                        } else {
                            $amount = (int) $this->getOption('vietqrReviewFee');
                            $feeLabelVi = 'Lệ phí phản biện bài báo';
                            $feeLabelEn = 'Peer Review Fee';
                            $descCode = 'PHANBIEN';
                        }
                        
                        // Generate transaction description (e.g. "TCKHCN 123 PHANBIEN PHONG")
                        $description = "TCKHCN " . $submissionId . " " . $descCode . " " . strtoupper($cleanAuthor);
                        // Limit description length to 25 chars to prevent VietQR truncation issues
                        $description = substr($description, 0, 25);
                        
                        // Generate VietQR url
                        $qrUrl = "https://img.vietqr.io/image/{$bank}-{$accountNumber}-compact.png?amount={$amount}&addInfo=" . urlencode($description) . "&accountName=" . urlencode($accountName);
                        
                        $templateMgr->assign([
                            'paySubmissionId' => $submissionId,
                            'payTitle' => $title,
                            'payAuthors' => $authorString,
                            'payFeeType' => $feeType,
                            'payFeeLabelVi' => $feeLabelVi,
                            'payFeeLabelEn' => $feeLabelEn,
                            'payAmount' => $amount,
                            'payBank' => strtoupper($bank),
                            'payAccountNumber' => $accountNumber,
                            'payAccountName' => $accountName,
                            'payDescription' => $description,
                            'payQrUrl' => $qrUrl,
                        ]);
                        
                        // Render payment template
                        $templateMgr->display('frontend/pages/payment.tpl');
                        exit;
                    }
                }
                
                // If invalid submission, redirect to homepage
                $request->redirect(null, 'index');
                exit;
            }
        }

        return false;
    }

    /**
     * Helper to clean Vietnamese string for banking description (remove diacritics and spaces)
     */
    private function _cleanString($str)
    {
        $unicode = [
            'a'=>'á|à|ả|ã|ạ|ă|ắ|ằ|ẳ|ẵ|ặ|â|ấ|ầ|ẩ|ẫ|ậ',
            'd'=>'đ',
            'e'=>'é|è|ẻ|ẽ|ẹ|ê|ế|ề|ể|ễ|ệ',
            'i'=>'í|à|ỉ|ĩ|ị',
            'o'=>'ó|ò|ỏ|õ|ọ|ô|ố|ồ|ổ|ỗ|ộ|ơ|ớ|ờ|ở|ỡ|ợ',
            'u'=>'ú|ù|ủ|ũ|ụ|ư|ứ|ừ|ử|ữ|ự',
            'y'=>'ý|ỳ|ỷ|ỹ|ỵ',
            'A'=>'Á|À|Ả|Ã|Ạ|Ă|Ắ|Ằ|Ẳ|Ẵ|Ặ|Â|Ấ|Ầ|Ẩ|Ẫ|Ậ',
            'D'=>'Đ',
            'E'=>'É|È|Ẻ|Ẽ|Ẹ|Ê|Ế|Ề|Ể|Ễ|Ệ',
            'I'=>'Í|À|Ỉ|Ĩ|Ị',
            'O'=>'Ó|Ò|Ỏ|Õ|Ọ|Ô|Ố|Ồ|Ổ|Ỗ|Ộ|Ơ|Ớ|Ờ|Ở|Ỡ|Ợ',
            'U'=>'Ú|Ù|Ủ|ũ|Ụ|Ư|Ứ|Ừ|Ử|Ữ|Ự',
            'Y'=>'Ý|Ỳ|Ỷ|Ỹ|Ỵ',
        ];
        foreach ($unicode as $nonUnicode => $uni) {
            $str = preg_replace("/($uni)/i", $nonUnicode, $str);
        }
        $str = preg_replace('/[^a-zA-Z0-9\s]/', '', $str);
        return str_replace(' ', '', $str);
    }

    /**
     * Chèn file CSS tùy biến vào trang quản trị (backend dashboard).
     */
    public function addAdminStyles($hookName, $args)
    {
        $templateMgr = $args[0];
        $request = \Application::get()->getRequest();

        $templateMgr->addStyleSheet(
            'tckhcn-admin-styles',
            $request->getBaseUrl() . '/plugins/themes/tckhcn/styles/admin.css',
            [
                'contexts' => ['backend']
            ]
        );

        return false;
    }

    /**
     * Tên hiển thị của Theme trong trang quản lý.
     */
    public function getDisplayName()
    {
        return 'Tạp chí Khoa học và Công nghệ Theme';
    }

    /**
     * Mô tả chi tiết về Theme.
     */
    public function getDescription()
    {
        return 'Giao diện tùy biến (Child Theme) kế thừa từ Default Theme, thiết kế riêng cho Tạp chí Khoa học và Công nghệ (TCKHCN).';
    }
}
