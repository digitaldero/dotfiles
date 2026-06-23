#!/usr/bin/php
<?php
/**
 * Vim CSS formatter wrapper using js-beautify.
 * Follows the same reliable temp-file + read-back pattern as the other
 * vim_*_format.php scripts (protects against empty buffer issues).
 *
 * Uses js-beautify --type css with a dedicated config.
 * This replaces the old csscomb-based formatter for modernity/consistency
 * with the HTML/JS-in-HTML formatter.
 *
 * Requires: js-beautify (already installed globally via npm)
 *
 * Config: ~/dotfiles/.jsbeautify-css.json
 */

error_reporting(0);

$code = stream_get_contents(STDIN);

if ($code !== FALSE) {
    $fixed = format_css($code);
    print $fixed;
} else {
    fwrite(STDERR, "An error occurred while reading stdin.\n");
    exit(1);
}

function format_css($code) {
    $tmp = tempnam(sys_get_temp_dir(), 'vim_css_');
    $file = $tmp . '.css';
    rename($tmp, $file);
    file_put_contents($file, $code);

    $config = getenv('HOME') . '/dotfiles/.jsbeautify-css.json';

    $cmd = sprintf(
        'js-beautify --type css --config %s -f %s -o %s > /dev/null 2>&1',
        escapeshellarg($config),
        escapeshellarg($file),
        escapeshellarg($file)
    );

    system($cmd);

    $fixedCode = file_get_contents($file);

    @unlink($file);
    @unlink($tmp);

    // Post-process to match old csscomb preferences where js-beautify falls short:
    // - Force double quotes (you prefer double for url() and content:)
    $fixedCode = preg_replace("/url\\s*\\('([^']*)'\\)/i", 'url("$1")', $fixedCode);
    $fixedCode = preg_replace("/url\\s*\\(\"([^\"]*)\"\\)/i", 'url("$1")', $fixedCode);
    $fixedCode = preg_replace("/content\\s*:\\s*'([^']*)'/i", 'content: "$1"', $fixedCode);
    $fixedCode = preg_replace("/content\\s*:\\s*\"([^\"]*)\"/i", 'content: "$1"', $fixedCode);

    // - Collapse any remaining broken declaration values onto one line
    //   (e.g. "color:\n    #444;" -> "color: #444;")
    $fixedCode = preg_replace_callback(
        '/([a-zA-Z0-9_-]+)\s*:\s*([^;{]+);/s',
        function($m) {
            $prop = $m[1];
            $val = preg_replace('/\s+/', ' ', trim($m[2]));
            return $prop . ': ' . $val . ';';
        },
        $fixedCode
    );

    // - Lowercase element/tag selectors (never uppercase like DIV, A)
    //   Leaves .classes and #ids untouched
    $fixedCode = preg_replace_callback(
        '/(^|[\s,>+~])([a-zA-Z][a-zA-Z0-9-]*)(?=[\s,>+~.#:{]|$)/',
        function($m) {
            return $m[1] . strtolower($m[2]);
        },
        $fixedCode
    );

    return $fixedCode;
}
