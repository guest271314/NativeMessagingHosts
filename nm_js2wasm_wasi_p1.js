// js2wasm Native Messaging host
// guest271314, ttraenkler, 6-5-2026
// https://github.com/loopdive/js2/issues/389
// bun build ./node_modules/@loopdive/js2/examples/native-messaging/nm_js2wasm_wasi_p1.ts --no-bundle --outfile=nm_js2_wasi_p1.js
// bun ./node_modules/@loopdive/js2/src/cli.ts ./nm_js2wasm_wasi_p1.js --verbose --wit --target wasi -o .
import { fd_read, fd_write } from "wasi_snapshot_preview1";
import { store32, load32, store8, load8 } from "wasm:memory";
const IOV = 0;
const RESULT = 8;
const HDR = 16;
const ONE = 20;
const CAP = 64 * 1024;
const MAXRUN = CAP - 2;
const INBUF = 4096;
const OUTBUF = INBUF + CAP;
const COMMA = 44;
const OPEN_BRACKET = 91;
const CLOSE_BRACKET = 93;
const DQUOTE = 34;
function setIovec(buf, len) {
  store32(IOV, buf);
  store32(IOV + 4, len);
  store32(RESULT, 0);
}
function readSome(fd, buf, len) {
  setIovec(buf, len);
  const errno = fd_read(fd, IOV, 1, RESULT);
  if (errno !== 0)
    return 0;
  return load32(RESULT);
}
function readExact(fd, buf, n) {
  let got = 0;
  while (got < n) {
    const r = readSome(fd, buf + got, n - got);
    if (r <= 0)
      return false;
    got = got + r;
  }
  return true;
}
function writeExact(fd, buf, n) {
  let put = 0;
  while (put < n) {
    setIovec(buf + put, n - put);
    const errno = fd_write(fd, IOV, 1, RESULT);
    if (errno !== 0)
      return false;
    const w = load32(RESULT);
    if (w <= 0)
      return false;
    put = put + w;
  }
  return true;
}
function decodeLength(p) {
  return load8(p) + load8(p + 1) * 256 + load8(p + 2) * 65536 + load8(p + 3) * 16777216;
}
function emitFrame(srcOff, runLen, open, close) {
  const bodyLen = runLen + 2;
  store8(OUTBUF, bodyLen & 255);
  store8(OUTBUF + 1, bodyLen >> 8 & 255);
  store8(OUTBUF + 2, bodyLen >> 16 & 255);
  store8(OUTBUF + 3, bodyLen >> 24 & 255);
  store8(OUTBUF + 4, open);
  let k = 0;
  while (k < runLen) {
    store8(OUTBUF + 5 + k, load8(INBUF + srcOff + k));
    k = k + 1;
  }
  store8(OUTBUF + 5 + runLen, close);
  writeExact(1, OUTBUF, 4 + bodyLen);
}
function streamLargeString(interiorRemaining) {
  let remaining = interiorRemaining;
  while (remaining > 0) {
    let runLen = MAXRUN;
    if (remaining < runLen)
      runLen = remaining;
    if (!readExact(0, INBUF, runLen))
      return false;
    emitFrame(0, runLen, DQUOTE, DQUOTE);
    remaining = remaining - runLen;
  }
  return true;
}
function runRechunk() {
  while (true) {
    if (!readExact(0, HDR, 4))
      return;
    const declaredLen = decodeLength(HDR);
    if (declaredLen === 0)
      return;
    if (declaredLen <= CAP) {
      store8(OUTBUF, declaredLen & 255);
      store8(OUTBUF + 1, declaredLen >> 8 & 255);
      store8(OUTBUF + 2, declaredLen >> 16 & 255);
      store8(OUTBUF + 3, declaredLen >> 24 & 255);
      if (!readExact(0, OUTBUF + 4, declaredLen))
        return;
      if (!writeExact(1, OUTBUF, 4 + declaredLen))
        return;
      continue;
    }
    if (!readExact(0, ONE, 1))
      return;
    const first = load8(ONE);
    if (first === DQUOTE) {
      if (!streamLargeString(declaredLen - 2))
        return;
      if (!readExact(0, ONE, 1))
        return;
      continue;
    }
    let interiorRemaining = declaredLen - 2;
    let fill = 0;
    let truncated = false;
    while (interiorRemaining > 0) {
      const need = CAP - fill;
      if (interiorRemaining >= need) {
        if (!readExact(0, INBUF + fill, need)) {
          truncated = true;
          break;
        }
        fill = CAP;
        interiorRemaining = interiorRemaining - need;
        let last = MAXRUN;
        while (last > 0 && load8(INBUF + last - 1) !== COMMA)
          last = last - 1;
        let runLen = 0;
        let consumed = 0;
        if (last === 0) {
          runLen = MAXRUN;
          consumed = MAXRUN;
        } else {
          runLen = last - 1;
          consumed = last;
        }
        emitFrame(0, runLen, OPEN_BRACKET, CLOSE_BRACKET);
        const rem = fill - consumed;
        let m = 0;
        while (m < rem) {
          store8(INBUF + m, load8(INBUF + consumed + m));
          m = m + 1;
        }
        fill = rem;
      } else {
        if (!readExact(0, INBUF + fill, interiorRemaining)) {
          truncated = true;
          break;
        }
        fill = fill + interiorRemaining;
        interiorRemaining = 0;
        let startPos = 0;
        while (startPos < fill) {
          let stop = startPos + MAXRUN;
          if (stop >= fill) {
            stop = fill;
          } else {
            let c = stop;
            while (c > startPos && load8(INBUF + c - 1) !== COMMA)
              c = c - 1;
            if (c > startPos)
              stop = c - 1;
          }
          emitFrame(startPos, stop - startPos, OPEN_BRACKET, CLOSE_BRACKET);
          startPos = stop;
          if (startPos < fill && load8(INBUF + startPos) === COMMA)
            startPos = startPos + 1;
        }
        fill = 0;
      }
    }
    if (truncated)
      return;
    if (!readExact(0, ONE, 1))
      return;
  }
}
export function main() {
  runRechunk();
}
main();
