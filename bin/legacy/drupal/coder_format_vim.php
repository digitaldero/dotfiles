#!/usr/bin/php
<?php

/**
 * command line coder formatter for use in vim
 * by Digital Dero
 */

error_reporting(0);
require_once realpath(dirname($argv[0])) . '/coder_format/coder_format.inc';

$code = stream_get_contents(fopen('php://stdin', 'r'));

if ($code !== FALSE) {

  // Drupal coder format
  $code = coder_format_string_all($code);

  // Remove multiple blank lines
  $code = preg_replace("/\n\n+/", "\n\n", trim($code));
  print $code;
}
else {
  print 'An error occurred while processing.';
}
