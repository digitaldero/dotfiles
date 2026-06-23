#!/usr/bin/php
<?php

/**
 * by Chris Herberte
 */

//error_reporting(0);

$code = stream_get_contents(fopen('php://stdin', 'r'));

if ($code !== FALSE) {
  // remove multiple blank lines. leave one.
  $code = preg_replace("/\n\n+/", "\n\n", trim($code));

  // csscomb
  $code = csscomb($code);
  print $code;
}
else {
  print 'An error occurred while processing.';
}

function csscomb($code) {
  $tmp = tempnam(sys_get_temp_dir(), 'vim_csscomb_');
  $file = $tmp . '.css';
  rename($tmp, $file);
  file_put_contents($file, $code);
  system('csscomb -t -c ~/dotfiles/.csscomb.json ' . $file);
  $code = file_get_contents($file);
  unlink($file);
  return $code;
}
