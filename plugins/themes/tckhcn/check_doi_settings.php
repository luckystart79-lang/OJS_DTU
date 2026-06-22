<?php
define('INDEX_FILE_LOCATION', dirname(__DIR__, 3) . '/index.php');
require_once dirname(__DIR__, 3) . '/lib/pkp/includes/bootstrap.php';

use Illuminate\Support\Facades\DB;

$results = DB::select("SELECT * FROM journal_settings WHERE setting_name LIKE '%doi%' OR setting_name LIKE '%DOI%'");
foreach ($results as $row) {
    echo "Journal ID: {$row->journal_id}, Locale: {$row->locale}, Key: {$row->setting_name}, Value: {$row->setting_value}\n";
}

echo "=== Enabled plugins from plugin_settings ===\n";
$plugins = DB::select("SELECT * FROM plugin_settings WHERE setting_name = 'enabled'");
foreach ($plugins as $p) {
    echo "Plugin: {$p->plugin_name}, Context ID: {$p->context_id}, Value: {$p->setting_value}\n";
}
