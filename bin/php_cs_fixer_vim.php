#!/usr/bin/php
<?php

/**
 * Modified for 2-space / Uppercase Boolean support.
 */
error_reporting(0);

// Get the code from Vim's buffer (stdin)
$code = stream_get_contents(STDIN);

if (FALSE !== $code) {
  $code = php_cs_fixer($code);
//  $code = add_missing_docblocks($code);
  // Note: 'print' here sends the fixed code back to Vim
  print $code;
} else {
  fwrite(STDERR, "An error occurred while reading stdin.\n");
  exit(1);
}

/**
 * TODO: Document this function.
 */
function php_cs_fixer($code) {
  $tmp = tempnam(sys_get_temp_dir(), 'php_cs_fixer_');
  $file = $tmp . '.php';

  // Ensure the temp file exists with the .php extension
  file_put_contents($file, $code);

  // Path to your config file
  $configFile = $_SERVER['HOME'] . '/.config/php_cs_fixer_config.php';

  // Run the fixer.
  // We use --config to point to your custom rules (2-spaces, uppercase booleans, etc.)
  $cmd = sprintf('php-cs-fixer fix %s --config=%s -q', escapeshellarg($file), escapeshellarg($configFile));
  system($cmd);

  $fixedCode = file_get_contents($file);

  // Cleanup
  if (file_exists($file)) {
    unlink($file);
  }
  if (file_exists($tmp)) {
    unlink($tmp);
  }

  return $fixedCode;
}

/**
 * Add missing doc blocks above functions with no comments.
 */
function add_missing_docblocks($code) {
  /**
   * Regex Breakdown:
   * ^(\s*)          -> Match start of line and capture indentation
   * (?<!\*\/)\n     -> Ensure previous line wasn't a docblock end
   * (function\s+\w+) -> Capture the 'function name' part
   */
  $pattern = '/(?<!\*\/)\n(\s*)(function\s+\w+)/';

  // The replacement ensures the /**, *, and */ are all aligned to the same $1 indent
  $replacement = "\n$1/**\n$1 * TODO: Document this function.\n$1 */\n$1$2";

  return preg_replace($pattern, $replacement, $code);
}
