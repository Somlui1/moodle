<?php
// Moodle placeholder
echo "<h1>Welcome to Moodle Environment</h1>";
echo "<p>PHP version: " . phpversion() . "</p>";
echo "<h2>Enabled Extensions:</h2>";
echo "<ul>";
foreach (get_loaded_extensions() as $ext) {
    echo "<li>$ext</li>";
}
echo "</ul>";
phpinfo();
