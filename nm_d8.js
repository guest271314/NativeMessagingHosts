#!/usr/bin/env -S /home/user/.esvu/bin/v8 --enable-os-system --module
// d8 Native Messaging host
// guest271314 7-7-2023, 6-20-2024

function encodeMessage(str) {
  return new Uint8Array([...str].map((s) => s.codePointAt()));
}

function getMessage(pid) {
  try {
    // readline() doesn't read past the Uint32Array equivalent message length
    // V8 authors are not interested in reading STDIN to an ArrayBuffer in d8
    // https://groups.google.com/g/v8-users/c/NsnStT6bx3Y/m/Yr_Z1FwgAQAJ
    // Use dd https://pubs.opengroup.org/onlinepubs/9699919799/utilities/dd.html
    // or GNU Coreutils head https://www.gnu.org/software/coreutils/manual/html_node/head-invocation.html
    // # length=$(head -q -z --bytes=4 /proc/${pid}/fd/0 | od -An -td4 -)
    // # message=$(head -q -z --bytes=$((length)) /proc/${pid}/fd/0)
    // to get message length and return message from Bash script
    const stdin = (os.system("bash", [
      "-c",
      `
  length=$(dd iflag=fullblock oflag=nocache conv=notrunc,fdatasync bs=4 count=1 if=/proc/${pid}/fd/0 | od -An -td4 -)
  message=$(dd iflag=fullblock oflag=nocache conv=notrunc,fdatasync bs=$((length)) count=1 if=/proc/${pid}/fd/0)
  echo "$message"`,
    ])).trim();
    if (stdin != undefined && stdin != null && stdin.length) {
      const message = encodeMessage(stdin);
      // https://stackoverflow.com/a/58288413
      // const header = new Uint32Array([
      //  ((uint32) =>
      //    (uint32[3] << 24) |
      //    (uint32[2] << 16) |
      //    (uint32[1] << 8) |
      //    (uint32[0]))(Array.from({
      //    length: 4,
      //    }, (_, index) => (message.length >> (index * 8)) & 0xff)),
      // ]);
      // writeFile("messageLength.txt", encodeMessage(JSON.stringify(header)));
      return encodeMessage(stdin);
    } else {
      return;
    }
  } catch (e) {
    writeFile("getMessageError.txt", encodeMessage(e.message));
  }
}

function sendMessage(message) {
  const header = new Uint32Array([message.length]);
  writeFile("/proc/self/fd/1", header);
  writeFile("/proc/self/fd/1", message);
}

function main() {
  // Get PID of current process
  const pid = (os.system("pgrep", ["-n", "-f", os.d8Path])).replace(/\D+/g, "");
  // Get PPID of current process
  const ppid = os.system("ps", ["-o", "ppid=", "-p", JSON.parse(pid)]);
  while (true) {
    // Terminate current process when chrome processes close
    if (!(os.system("pgrep", ["-P", JSON.parse(ppid)]))) {
      break;
    }
    const message = getMessage(pid);
    if (message) {
      sendMessage(message);
    }
  }
}

try {
  main();
} catch (e) {
  writeFile("mainError.txt", encodeMessage(e.message));
  quit();
}
