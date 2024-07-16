#!/usr/bin/env -S JS_STDERR=err.txt /path/to/spidermonkey -m
// /home/user/bin/jsshell-linux-x86_64/js
// SpiderMonkey Shell Native Messaging host
// guest271314 7-7-2023, 6-16-2024

function encodeMessage(str) {
  return new Uint8Array([...str].map((s) => s.codePointAt()));
}

function getMessage() {
  // Call readline() N times to catch `\r\n\r\n"` from 2d port.postMessage()
  let stdin;
  while (true) {
    stdin = readline();
    if (stdin !== null) {
      break;
    }
  }
  
  let data = `${stdin}`.replace(/[\r\n]+|\\x([0-9A-Fa-f]{2,4})/gu, "")
    .replace(/[^A-Za-z0-9\s\[,\]\{\}:_"]+/igu, "")
    .replace(/^"rnrn/gu, "")
    .replace(/^[#\r\n\}_]+(?=\[)/gu, "")
    .replace(/^"(?=["\{]+)|^"(?!"$)/gu, "") 
    .replace(/^\[(?=\[(?!.*\]{2}$))/gu, "")
    .replace(/^\{(?!\}|.+\}$)/gu, "")
    .replace(/^[0-9A-Z]+(?=[\[\{"])/igu, "") 
    .replace(/^[\]\}](?=\[)/i, "")
    .trimStart().trim();
  // https://stackoverflow.com/a/52434176
  // let previous = redirect("length.txt");
  // putstr(data.length);
  // redirect(previous); // restore the redirection to stdout
  // os.file.writeTypedArrayToFile("input.txt", encodeMessage(data));
  return encodeMessage(data);
}

function sendMessage(message) {
  os.file.writeTypedArrayToFile(
    "/proc/self/fd/1",
    new Uint32Array([message.length]),
  );
  os.file.writeTypedArrayToFile("/proc/self/fd/1", message);
}

function main() {
  // Send help() to client
  // const previous = redirect("help.txt");
  // putstr(help());
  // redirect(previous); // restore the redirection to stdout
  // const h = read("help.txt", "binary");
  // sendMessage(encodeMessage(JSON.stringify([...h])));
  while (true) {
    // Terminate current process when chrome-extension://<ID> is not a running process
    // https://discourse.mozilla.org/t/131564/
    if (!!os.system(`pgrep -fln ${scriptArgs[0]} > /dev/null`)) {
      break;
    }
    const message = getMessage();
    sendMessage(message);
  }
}

try {
  main();
} catch (e) {
  os.file.writeTypedArrayToFile(
    "caught.txt",
    encodeMessage(JSON.stringify(e.message)),
  );
  quit();
}
