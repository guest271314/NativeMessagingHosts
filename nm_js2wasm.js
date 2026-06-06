// bun build ./node_modules/@loopdive/js2/examples/native-messaging/nm_js2wasm.ts --target=node --outfile=nm_js2wasm.js
// node_modules/@loopdive/js2/examples/native-messaging/nm_js2wasm.ts
var FRAME_CHUNK = 1024 * 1024;
var MAX_RUN = FRAME_CHUNK - 2;
var COMMA = 44;
var OPEN_BRACKET = 91;
var CLOSE_BRACKET = 93;
function readExact(buf, n) {
  let got = 0;
  while (got < n) {
    const r = process.stdin.read(buf, got);
    if (r <= 0)
      return false;
    got = got + r;
  }
  return true;
}
function readAt(buf, start, n) {
  let got = 0;
  while (got < n) {
    const r = process.stdin.read(buf, start + got);
    if (r <= 0)
      return false;
    got = got + r;
  }
  return true;
}
function decodeLength(header) {
  return header[0] + header[1] * 256 + header[2] * 65536 + header[3] * 16777216;
}
function writeLength(len) {
  process.stdout.write(new Uint8Array([len & 255, len >> 8 & 255, len >> 16 & 255, len >> 24 & 255]));
}
function logFrameBodyRead(declaredLen) {
  process.stderr.write(`[host] received ${4 + declaredLen} chars, declared body length ${declaredLen}
`);
}
function emitRun(src, start, runLen) {
  const frame = new Uint8Array(runLen + 2);
  frame[0] = OPEN_BRACKET;
  let k = 0;
  while (k < runLen) {
    frame[k + 1] = src[start + k];
    k = k + 1;
  }
  frame[runLen + 1] = CLOSE_BRACKET;
  writeLength(runLen + 2);
  process.stdout.write(frame);
}
function main() {
  const header = new Uint8Array(4);
  const one = new Uint8Array(1);
  const buf = new Uint8Array(FRAME_CHUNK);
  while (true) {
    if (!readExact(header, 4))
      break;
    const declaredLen = decodeLength(header);
    if (declaredLen === 0)
      break;
    logFrameBodyRead(declaredLen);
    if (declaredLen <= FRAME_CHUNK) {
      const small = new Uint8Array(declaredLen);
      if (!readExact(small, declaredLen))
        break;
      writeLength(declaredLen);
      process.stdout.write(small);
      continue;
    }
    if (!readExact(one, 1))
      break;
    let interiorRemaining = declaredLen - 2;
    let fill = 0;
    let truncated = false;
    while (interiorRemaining > 0) {
      const need = FRAME_CHUNK - fill;
      if (interiorRemaining >= need) {
        if (!readAt(buf, fill, need)) {
          truncated = true;
          break;
        }
        fill = FRAME_CHUNK;
        interiorRemaining = interiorRemaining - need;
        let last = MAX_RUN;
        while (last > 0 && buf[last - 1] !== COMMA)
          last = last - 1;
        let runLen;
        let consumed;
        if (last === 0) {
          runLen = MAX_RUN;
          consumed = MAX_RUN;
        } else {
          runLen = last - 1;
          consumed = last;
        }
        emitRun(buf, 0, runLen);
        const rem = fill - consumed;
        let m = 0;
        while (m < rem) {
          buf[m] = buf[consumed + m];
          m = m + 1;
        }
        fill = rem;
      } else {
        const tmp = new Uint8Array(interiorRemaining);
        if (!readExact(tmp, interiorRemaining)) {
          truncated = true;
          break;
        }
        let t = 0;
        while (t < interiorRemaining) {
          buf[fill + t] = tmp[t];
          t = t + 1;
        }
        fill = fill + interiorRemaining;
        interiorRemaining = 0;
        let startPos = 0;
        while (startPos < fill) {
          let stop = startPos + MAX_RUN;
          if (stop >= fill) {
            stop = fill;
          } else {
            let c = stop;
            while (c > startPos && buf[c - 1] !== COMMA)
              c = c - 1;
            if (c > startPos)
              stop = c - 1;
          }
          emitRun(buf, startPos, stop - startPos);
          startPos = stop;
          if (startPos < fill && buf[startPos] === COMMA)
            startPos = startPos + 1;
        }
        fill = 0;
      }
    }
    if (truncated)
      break;
    if (!readExact(one, 1))
      break;
  }
}
export {
  main
};
