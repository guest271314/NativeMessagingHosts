#!/usr/bin/env -S /home/user/.esvu/bin/v8 --enable-os-system --module
// d8 Native Messaging host
// guest271314 7-7-2023, 6-20-2024

function encodeMessage(str) {
  return new Uint8Array([...str].map((s) => s.codePointAt()));
}

function getMessage(pid, [command, argv]) {
  try {
    const stdin = (os.system(command, argv)).trim();
    if (stdin != undefined && stdin != null && stdin.length) {
      const cmd = command.split(/[/-]/).pop();
      if (cmd === "bash") {
        const message = encodeMessage(stdin);
        return message;
      }
      if (cmd === "qjs") {
        const data = encodeMessage(stdin);
        const view = new DataView(data.subarray(0, 4).buffer);
        const length = view.getUint32(0, true);
        // sendMessage(encodeMessage(JSON.stringify({ length })));
        return data.subarray(4, 4 + length);
      }
    } else {
      quit(1);
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
  const pid = (os.system("pgrep", ["-n", "-f", os.d8Path])).replace(/\D+/g, "")
    .trim();
  // Get PPID of current process
  const ppid = os.system("ps", ["-o", "ppid=", "-p", JSON.parse(pid)]);
  // readline() doesn't read past the Uint32Array equivalent message length
  // V8 authors are not interested in reading STDIN to an ArrayBuffer in d8
  // https://groups.google.com/g/v8-users/c/NsnStT6bx3Y/m/Yr_Z1FwgAQAJ
  // Use dd https://pubs.opengroup.org/onlinepubs/9699919799/utilities/dd.html
  // or GNU Coreutils head https://www.gnu.org/software/coreutils/manual/html_node/head-invocation.html
  // or QuickJS https://bellard.org/quickjs/
  const bash = ["bash", [
    "--posix",
    "-c",
    `
length=$(head -q -z --bytes=4 /proc/${pid}/fd/0 | od -An -td4 -)
message=$(head -q -z --bytes=$((length)) /proc/${pid}/fd/0)
# length=$(dd iflag=fullblock oflag=nocache conv=notrunc,fdatasync bs=4 count=1 if=/proc/${pid}/fd/0 | od -An -td4 -)
# message=$(dd iflag=fullblock oflag=nocache conv=notrunc,fdatasync bs=$((length)) count=1 if=/proc/${pid}/fd/0)
printf "$message"
`,
  ]];
  const qjs = ["/home/user/bin/qjs", [
    "--std",
    "-m",
    "-e",
    `const path = "/proc/${pid}/fd/0";
  try {
    const size = new Uint32Array(1);
    const err = { errno: 0 };
    const pipe = std.open(
      path,
      "rb",
      err,
    );
    if (err.errno !== 0) {
      throw std.strerror(err.errno);
    }
    pipe.read(size.buffer, 0, 4);
    // writeFile("len.txt", size);
    // {error: 'writeFile is not defined'
    const output = new Uint8Array(size[0]);
    pipe.read(output.buffer, 0, size[0]);
    const res = new Uint8Array([...new Uint8Array(size.buffer),...output]);
    std.out.write(res.buffer, 0, res.length);
    std.out.flush();
    std.exit(0);
  } catch (e) {
    const json = JSON.stringify({error:e.message});
    std.out.write(Uint32Array.of(json.length).buffer, 0, 4);
    std.out.puts(json);
    std.out.flush();
    std.exit(0);
  }
`,
  ]];
  while (true) {
    // Terminate current process when chrome processes close
    if (!(os.system("pgrep", ["-P", JSON.parse(ppid)]))) {
      break;
    }
    const message = getMessage(
      pid,
      qjs,
    );
    if (message) {
      sendMessage(message);
      if (
        // Handle error from qjs
        String.fromCodePoint.apply(null, [...message.subarray(1, 8)]) ===
          `"error"` // JSON
      ) {
        break;
      }
    }
  }
}

try {
  main();
} catch (e) {
  writeFile("mainError.txt", encodeMessage(e.message));
  quit();
}
