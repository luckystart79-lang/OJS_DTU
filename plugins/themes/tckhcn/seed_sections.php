<?php
if (php_sapi_name() !== 'cli') {
    exit('CLI only');
}

define('INDEX_FILE_LOCATION', dirname(__DIR__, 3) . '/index.php');
require_once dirname(__DIR__, 3) . '/lib/pkp/includes/bootstrap.php';

use Illuminate\Support\Facades\DB;

$contextId = 1;

// 1. Rename section 1 to 'Kỹ thuật và Công nghệ' / 'Engineering and Technology'
DB::delete("DELETE FROM section_settings WHERE section_id = 1");

DB::insert("INSERT INTO section_settings (section_id, locale, setting_name, setting_value) VALUES 
    (1, 'vi', 'title', 'Kỹ thuật và Công nghệ'),
    (1, 'vi', 'abbrev', 'KTCN'),
    (1, 'en', 'title', 'Engineering and Technology'),
    (1, 'en', 'abbrev', 'ENG')");

echo "Renamed Section 1 to 'Kỹ thuật và Công nghệ'\n";

// 2. Define the other 5 categories to insert
$categories = [
    [
        'vi_title' => 'Khoa học Tự nhiên',
        'vi_abbrev' => 'KHTN',
        'en_title' => 'Natural Sciences',
        'en_abbrev' => 'NAT'
    ],
    [
        'vi_title' => 'Khoa học Xã hội',
        'vi_abbrev' => 'KHXH',
        'en_title' => 'Social Sciences',
        'en_abbrev' => 'SOC'
    ],
    [
        'vi_title' => 'Khoa học Sức khỏe và Đời sống',
        'vi_abbrev' => 'KHSK',
        'en_title' => 'Health and Life Sciences',
        'en_abbrev' => 'HEA'
    ],
    [
        'vi_title' => 'Khoa học Liên ngành và Ứng dụng',
        'vi_abbrev' => 'KHLN',
        'en_title' => 'Interdisciplinary and Applied Sciences',
        'en_abbrev' => 'INT'
    ],
    [
        'vi_title' => 'Khoa học Nhân văn và Nghệ thuật',
        'vi_abbrev' => 'KHNV',
        'en_title' => 'Humanities and Arts',
        'en_abbrev' => 'HUM'
    ]
];

$seq = 2.00;
foreach ($categories as $cat) {
    // Check if section already exists to prevent duplicate seeding
    $existing = DB::select("SELECT s.section_id FROM sections s JOIN section_settings ss ON s.section_id = ss.section_id WHERE s.journal_id = 1 AND ss.setting_name = 'title' AND ss.setting_value = ?", [$cat['vi_title']]);
    
    if (!empty($existing)) {
        echo "Section '{$cat['vi_title']}' already exists. Skipping.\n";
        continue;
    }

    // Insert row into sections
    DB::insert("INSERT INTO sections (journal_id, seq, meta_indexed, meta_reviewed) VALUES (1, ?, 1, 1)", [$seq]);
    $sectionId = DB::getPdo()->lastInsertId();

    // Insert settings
    DB::insert("INSERT INTO section_settings (section_id, locale, setting_name, setting_value) VALUES (?, 'vi', 'title', ?)", [$sectionId, $cat['vi_title']]);
    DB::insert("INSERT INTO section_settings (section_id, locale, setting_name, setting_value) VALUES (?, 'vi', 'abbrev', ?)", [$sectionId, $cat['vi_abbrev']]);
    DB::insert("INSERT INTO section_settings (section_id, locale, setting_name, setting_value) VALUES (?, 'en', 'title', ?)", [$sectionId, $cat['en_title']]);
    DB::insert("INSERT INTO section_settings (section_id, locale, setting_name, setting_value) VALUES (?, 'en', 'abbrev', ?)", [$sectionId, $cat['en_abbrev']]);
    
    echo "Created Section {$sectionId}: '{$cat['vi_title']}'\n";
    $seq += 1.00;
}

// 3. Clear data caches
$cacheManager = \CacheManager::getManager();
$cacheManager->flush(null);

echo "Seeding completed successfully!\n";
