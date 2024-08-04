#!/usr/bin/env -S /path/to/llrt
// llrt Native Messaging host
// guest271314, 8-3-2024

import { writeFileSync } from "node:fs";
import { spawn } from "node:child_process";

const [, filename] = process.argv;

function encodeMessage(str) {
  return new Uint8Array([...JSON.stringify(str)].map((s) => s.codePointAt()));
}

async function getMessage([command, argv]) {
  const message = await new Promise((resolve, reject) => {
    const res = [];
    const subprocess = spawn(command, argv, { stdio: "pipe" });
    subprocess.stdout.on("data", (data) => {
      res.push(...data);
    });
    subprocess.stdout.on("close", (code) => {
      resolve(new Uint8Array(res));
    });
    subprocess.stdout.on("exit", (code) => {
      reject(encodeMessage({ code }));
    });
  }).catch((e) => e);
  const cmd = command.split(/[/-]/).pop();
  if (cmd === "bash") {
    return message;
  }
  if (cmd === "qjs") {
    const view = new DataView(message.subarray(0, 4).buffer);
    const length = view.getUint32(0, true);
    // sendMessage(encodeMessage({ length }));
    return message.subarray(4, 4 + length);
  }
}

function sendMessage(json) {
  const header = Uint32Array.from({
    length: 4,
  }, (_, index) => (json.length >> (index * 8)) & 0xff);
  const output = new Uint8Array(header.length + json.length);
  output.set(header, 0);
  output.set(json, 4);
  writeFileSync("/proc/self/fd/1", output);
}

async function main() {
  const pid = process.id;
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
  const qjs = ["/path/to/qjs", [
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
    try {
      const message = await getMessage(bash);
      sendMessage(message);
    } catch (e) {
      sendMessage(encodeMessage(e.message));
      break;
    }
  }
}

main();
