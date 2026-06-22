<?php
define('INDEX_FILE_LOCATION', __FILE__);
$t0 = microtime(true);
require_once 'lib/pkp/lib/vendor/autoload.php';
$t1 = microtime(true);
echo "Composer autoload time: " . ($t1 - $t0) . "s\n";

define('BASE_SYS_DIR', dirname(__FILE__));
chdir(BASE_SYS_DIR);
require_once './lib/pkp/includes/functions.php';
$t2 = microtime(true);
echo "Functions load time: " . ($t2 - $t1) . "s\n";

$app = new \APP\core\Application();
$t3 = microtime(true);
echo "Application instantiation time: " . ($t3 - $t2) . "s\n";
