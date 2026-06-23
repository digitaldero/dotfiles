#!/usr/bin/php
<?php
/**
 * Vim HTML + embedded JS/CSS formatter wrapper.
 * Follows the same pattern as the old php_cs_fixer_vim.php and vim_csscomb.php
 * that you liked (temp file + external tool + read back to avoid empty buffer issues).
 *
 * Uses js-beautify --type html so it can handle JS inside <script> and CSS inside <style>
 * while formatting the surrounding HTML.
 *
 * Requires: npm install -g js-beautify
 *
 * Config: ~/dotfiles/.jsbeautify-d7.json (Drupal 7-ish rules: 2 spaces, etc.)
 */

error_reporting(0);

$code = stream_get_contents(STDIN);

if ($code !== FALSE) {
    $fixed = format_mixed_html($code);
    print $fixed;
} else {
    fwrite(STDERR, "An error occurred while reading stdin.\n");
    exit(1);
}

function format_mixed_html($code) {
    $tmp = tempnam(sys_get_temp_dir(), 'vim_html_');
    $file = $tmp . '.html';
    rename($tmp, $file);               // match the pattern from your old vim_csscomb.php etc.
    file_put_contents($file, $code);

    $config = getenv('HOME') . '/dotfiles/.jsbeautify-d7.json';

    // js-beautify --type html will format the HTML structure + reformat
    // JS blocks and CSS blocks inside it.
    $cmd = sprintf(
        'js-beautify --type html --config %s -f %s -o %s > /dev/null 2>&1',
        escapeshellarg($config),
        escapeshellarg($file),
        escapeshellarg($file)
    );

    system($cmd);

    $fixedCode = file_get_contents($file);

    // Cleanup (use @ to be quiet if already gone)
    @unlink($file);
    @unlink($tmp);

    return $fixedCode;
}
