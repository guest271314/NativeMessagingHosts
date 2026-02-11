// WASI Preview 1 Native Messaging host
// guest271314, 2-10-2026
// 
// #!/usr/bin/env -S /home/user/bin/node
// #!/usr/bin/env -S /home/user/bin/deno -A

import * as process from "node:process";
import fs from "node:fs";
// https://github.com/nodejs/node/issues/11568#issuecomment-282765300
process.stdout?._handle?.setBlocking(true);
process.stdin?._handle?.setBlocking(true);
// Minimal WASI Preview 1
// https://github.com/WebAssembly/WASI/tree/wasi-0.1
const ERRNO_SUCCESS = 0;
const ERRNO_BADF = 8;
const FILETYPE_CHARACTER_DEVICE = 2;
class WASIP1_MIN {
  args;
  env;
  memory;
  fds;
  exports;
  constructor(options) {
    this.args = options?.args ? options.args : [];
    this.env = options?.env ? options.env : {};
    this.memory = options?.memory;
    this.fds = [
      {
        type: FILETYPE_CHARACTER_DEVICE,
        handle: process.stdin,
      },
      {
        type: FILETYPE_CHARACTER_DEVICE,
        handle: process.stdout,
      },
      {
        type: FILETYPE_CHARACTER_DEVICE,
        handle: process.stderr,
      },
    ];// #!/usr/bin/env -S /home/user/bin/node
// #!/usr/bin/env -S /home/user/bin/deno -A
//
    this.exports = {
      args_get: (argv_ptr, argv_buf_ptr) => {
        const args = this.args;
        const text = new TextEncoder();
        const heap = new Uint8Array(this.memory.buffer);
        const view = new DataView(this.memory.buffer);
        for (let arg of args) {
          view.setUint32(argv_ptr, argv_buf_ptr, true);
          argv_ptr += 4;
          const data = text.encode(`${arg}\x00`);
          heap.set(data, argv_buf_ptr);
          argv_buf_ptr += data.length;
        }
        return ERRNO_SUCCESS;
      },
      fd_read: (fd, iovs_ptr, iovs_len, nread_out) => {
        const entry = this.fds[fd];
        if (!entry) {
          return ERRNO_BADF;
        }
        const view = new DataView(this.memory.buffer);
        let nread = 0;
        let n = 0;
        for (let i = 0; i < iovs_len; i++) {
          const data_ptr = view.getUint32(iovs_ptr, true);
          iovs_ptr += 4;
          const data_len = view.getUint32(iovs_ptr, true);
          iovs_ptr += 4;
          const data = new Uint8Array(this.memory.buffer, data_ptr, data_len);
          nread += fs.readSync(entry.handle.fd, data);
        }
        view.setUint32(nread_out, nread, true);
        return ERRNO_SUCCESS;
      },
      fd_write: (fd, iovs_ptr, iovs_len, nwritten_out) => {
        const entry = this.fds[fd];
        if (!entry) {
          return ERRNO_BADF;
        }
        const view = new DataView(this.memory.buffer);
        let nwritten = 0;
        for (let i = 0; i < iovs_len; i++) {
          const data_ptr = view.getUint32(iovs_ptr, true);
          iovs_ptr += 4;
          const data_len = view.getUint32(iovs_ptr, true);
          iovs_ptr += 4;
          nwritten += fs.writeSync(
            entry.handle.fd,
            new Uint8Array(this.memory.buffer, data_ptr, data_len),
          );
        }
        view.setUint32(nwritten_out, nwritten, true);
        return ERRNO_SUCCESS;
      },
      proc_exit: (rval) => {
        process.exit(rval);
      },
    };
  }
}
const wasm = fs.readFileSync(
  new URL("./path/to/native-messaging-host.wasm", import.meta.url),
);
const wasi = new WASIP1_MIN;
const { instance } = await WebAssembly.instantiateStreaming(
  new Response(wasm, { headers: { "content-type": "application/wasm" } }),
  { wasi_snapshot_preview1: wasi.exports },
);
try {
  wasi.memory = instance.exports.memory;
  instance.exports._start();
} catch (e) {
  fs.writeFileSync("err.txt", e.stack);
}
