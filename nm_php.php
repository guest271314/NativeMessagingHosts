#!/usr/bin/env -S /home/user/bin/php
<?php
/**
 * PHP Native Messaging Host
 * guest271314, 4-12-2026
 * Mirroring https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_qjs.js 
 * chunking algorithm for 64 MiB payloads.
 */
error_reporting(0);
ini_set("display_errors", 0);
ini_set("memory_limit", "512M"); // Needed for 64 MiB payload + processing overhead
set_time_limit(0);

/**
 * Reads the full message from stdin.
 */
function getMessage() {
  $stdin = fopen("php://stdin", "rb");
  if (!$stdin || feof($stdin)) return null;

  $raw_length = fread($stdin, 4);
  if ($raw_length === false || strlen($raw_length) !== 4) return null;

  $length = unpack("V", $raw_length)[1];
  $message = "";
  while (strlen($message) < $length && !feof($stdin)) {
    $read = fread($stdin, min($length - strlen($message), 65536));
    if ($read === false) break;
    $message .= $read;
  }
  return $message;
}

/**
 * Sends message to stdout. Chunks large arrays into valid JSON fragments.
 */
function sendMessage($json) {
  $stdout = fopen("php://stdout", "wb");
  $len = strlen($json);
  $limit = 1024 * 1024; // Chrome 1 MiB limit

  if ($len > $limit) {
    $index = 0;
    while ($index < $len) {
      // Find a comma near the 1 MiB mark to split safely
      $fromIndex = min($index + $limit - 8, $len - 1);
      $i = strpos($json, ",", $fromIndex);
      
      if ($i === false || $i >= $len) {
        $i = $len;
        $chunk = substr($json, $index);
      } else {
        $chunk = substr($json, $index, $i - $index);
      }

      // Ensure the chunk is wrapped to be valid JSON (nm_qjs.js logic)
      if ($chunk[0] !== "[") {
        $chunk = "[" . $chunk;
      }
      if (substr($chunk, -1) !== "]") {
        $chunk .= "]";
      }

      fwrite($stdout, pack("V", strlen($chunk)));
      fwrite($stdout, $chunk);
      fflush($stdout);

      $index = $i + 1; // Move past the comma for the next chunk
    }
  } else {
    fwrite($stdout, pack("V", $len));
    fwrite($stdout, $json);
    fflush($stdout);
  }
}

function main() {
  while (true) {
    $message = getMessage();
    if ($message === null) break;
    sendMessage($message);
  }
}

try {
  main();
} catch (Exception $e) {
  file_put_contents("php://stderr", $e->getMessage());
}
