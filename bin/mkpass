#!/usr/bin/env php
<?php

/**
 * by Chris Herberte
 */
if (isset($argv[1])) {
  require_once '/var/www/crm.dev.xweb.com.au/htdocs/includes/bootstrap.inc';
  require_once '/var/www/crm.dev.xweb.com.au/htdocs/includes/password.inc';

  $user = $argv[1];
  $pass = substr(md5($user), 0, 16);
  $md5 = md5($pass);
  $hash = user_hash_password($pass);

  print 'user: ' . $user . PHP_EOL;
  print 'pass: ' . $pass . PHP_EOL;
  print 'md5/xcms: ' . $md5 . PHP_EOL;
  print 'hash: ' . $hash . PHP_EOL;


}
else {
  print 'Usage: ' . basename($argv[0]) . ' "username"' . PHP_EOL;
}

