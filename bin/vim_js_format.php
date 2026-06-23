#!/usr/bin/php
<?php
/**
 * Vim JS/JSON formatter wrapper using js-beautify.
 * Follows the exact same reliable temp-file + read-back pattern
 * as vim_html_format.php and vim_css_format.php.
 *
 * - Protects against external tools emptying the buffer
 * - Works immediately after editing this script (no :source needed)
 * - Easy to maintain and tweak
 *
 * Called from vim like:
 *   :exe '%!vim_js_format.php js'
 *   :exe '%!vim_js_format.php json'
 *
 * Requires: js-beautify (npm install -g js-beautify)
 *
 * Config: ~/dotfiles/.jsbeautify-d7.json (your Drupal 7-ish rules)
 */

error_reporting(0);

$code = stream_get_contents(STDIN);

$type = 'js';
if (isset($argv[1]) && in_array($argv[1], ['js', 'json'], true)) {
    $type = $argv[1];
}

if ($code !== FALSE) {
    $fixed = format_js($code, $type);
    print $fixed;
} else {
    fwrite(STDERR, "An error occurred while reading stdin.\n");
    exit(1);
}

function format_js($code, $type) {
    $tmp = tempnam(sys_get_temp_dir(), 'vim_js_');
    $ext = ($type === 'json') ? '.json' : '.js';
    $file = $tmp . $ext;
    rename($tmp, $file);
    file_put_contents($file, $code);

    // Robustly locate js-beautify, preferring nvm current version
    $jsbeautify = null;
    $nvm_dir = getenv('NVM_DIR') ?: (getenv('HOME') . '/.nvm');
    $nvm_sh = "$nvm_dir/nvm.sh";
    if (is_readable($nvm_sh)) {
        // Source nvm and get current node version to find the bin
        $current = trim(shell_exec("bash -c 'source \"$nvm_sh\" --no-use 2>/dev/null; nvm current 2>/dev/null'"));
        if ($current && $current !== 'none' && $current !== 'system') {
            $cand = "$nvm_dir/versions/node/$current/bin/js-beautify";
            if (is_executable($cand)) {
                $jsbeautify = $cand;
            }
        }
    }
    if (!$jsbeautify) {
        $jsbeautify = trim(shell_exec('which js-beautify 2>/dev/null'));
    }
    if (!$jsbeautify || !is_executable($jsbeautify)) {
        $jsbeautify = '/home/chris/.nvm/versions/node/v22.19.0/bin/js-beautify';
    }
    if (!is_executable($jsbeautify)) {
        $jsbeautify = 'js-beautify';  // last resort, will likely fail and fallback
    }

    $home = getenv('HOME') ?: '/home/chris';

    if ($type === 'json') {
        $config = $home . '/dotfiles/.jsbeautify-json.json';
        // Do not pass --type json (js-beautify only accepts js|css|html).
        // The dedicated JSON config + file extension is sufficient for pretty-printing.
        $cmd = sprintf(
            '%s --config %s %s 2>&1',
            escapeshellarg($jsbeautify),
            escapeshellarg($config),
            escapeshellarg($file)
        );
    } else {
        $config = $home . '/dotfiles/.jsbeautify-d7.json';
        $cmd = sprintf(
            '%s --type %s --config %s %s 2>&1',
            escapeshellarg($jsbeautify),
            escapeshellarg($type),
            escapeshellarg($config),
            escapeshellarg($file)
        );
    }

    $fixedCode = shell_exec($cmd);

    @unlink($file);
    @unlink($tmp);

    // Debug: log what happened (check /tmp/vim_js_debug.log after testing)
    @file_put_contents('/tmp/vim_js_debug.log', date('c') . " type=$type jsbeautify=$jsbeautify output_len=" . strlen($fixedCode) . "\n", FILE_APPEND);

    // If command failed or produced no output, safely return original content
    if ($fixedCode === null || trim($fixedCode) === '' || strpos($fixedCode, 'command not found') !== false || strpos($fixedCode, 'type was invalid') !== false) {
        $fixedCode = $code;
    }

    // Add any JS-specific post-processing here if needed later
    // (e.g. quote style, etc.). For now the config does the heavy lifting.

    return $fixedCode;
}
