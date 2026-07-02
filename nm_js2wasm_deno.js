// node_modules/@loopdive/js2/examples/native-messaging/nm_js2wasm_sync_framing.ts
var VERBATIM_WINDOW = 64 * 1024;
var COMMA = 44;
var OPEN_BRACKET = 91;
var CLOSE_BRACKET = 93;
var DQUOTE = 34;
function decodeLength(header) {
  return header[0] + header[1] * 256 + header[2] * 65536 + header[3] * 16777216;
}
function readFillExact(read, buf, start, n) {
  let got = 0;
  while (got < n) {
    const tmp = new Uint8Array(n - got);
    const r = read(tmp);
    if (r === null || r <= 0)
      return false;
    let i = 0;
    while (i < r) {
      buf[start + got + i] = tmp[i];
      i = i + 1;
    }
    got = got + r;
  }
  return true;
}
function emitRun(write, src, start, runLen) {
  const bodyLen = runLen + 2;
  const out = new Uint8Array(4 + bodyLen);
  out[0] = bodyLen & 255;
  out[1] = bodyLen >> 8 & 255;
  out[2] = bodyLen >> 16 & 255;
  out[3] = bodyLen >> 24 & 255;
  out[4] = OPEN_BRACKET;
  let k = 0;
  while (k < runLen) {
    out[5 + k] = src[start + k];
    k = k + 1;
  }
  out[4 + runLen + 1] = CLOSE_BRACKET;
  write(out);
}
function emitStringRun(write, src, start, runLen) {
  const bodyLen = runLen + 2;
  const out = new Uint8Array(4 + bodyLen);
  out[0] = bodyLen & 255;
  out[1] = bodyLen >> 8 & 255;
  out[2] = bodyLen >> 16 & 255;
  out[3] = bodyLen >> 24 & 255;
  out[4] = DQUOTE;
  let k = 0;
  while (k < runLen) {
    out[5 + k] = src[start + k];
    k = k + 1;
  }
  out[4 + runLen + 1] = DQUOTE;
  write(out);
}
function streamLargeString(read, write, buf, interiorRemaining, maxRun) {
  let remaining = interiorRemaining;
  while (remaining > 0) {
    let runLen = maxRun;
    if (remaining < runLen)
      runLen = remaining;
    if (!readFillExact(read, buf, 0, runLen))
      return false;
    emitStringRun(write, buf, 0, runLen);
    remaining = remaining - runLen;
  }
  return true;
}
function runVerbatim(read, write) {
  const header = new Uint8Array(4);
  while (true) {
    if (!readFillExact(read, header, 0, 4))
      return;
    const declaredLen = decodeLength(header);
    if (declaredLen === 0)
      return;
    write(header);
    let remaining = declaredLen;
    while (remaining > 0) {
      let run = VERBATIM_WINDOW;
      if (remaining < run)
        run = remaining;
      const chunk = new Uint8Array(run);
      if (!readFillExact(read, chunk, 0, run))
        return;
      write(chunk);
      remaining = remaining - run;
    }
  }
}
function runRechunk(read, write, log, cap) {
  const maxRun = cap - 2;
  const header = new Uint8Array(4);
  const one = new Uint8Array(1);
  const buf = new Uint8Array(cap);
  while (true) {
    if (!readFillExact(read, header, 0, 4))
      break;
    const declaredLen = decodeLength(header);
    if (declaredLen === 0)
      break;
    log(declaredLen);
    if (declaredLen <= cap) {
      const out = new Uint8Array(4 + declaredLen);
      out[0] = declaredLen & 255;
      out[1] = declaredLen >> 8 & 255;
      out[2] = declaredLen >> 16 & 255;
      out[3] = declaredLen >> 24 & 255;
      if (!readFillExact(read, out, 4, declaredLen))
        break;
      write(out);
      continue;
    }
    if (!readFillExact(read, one, 0, 1))
      break;
    if (one[0] === DQUOTE) {
      if (!streamLargeString(read, write, buf, declaredLen - 2, maxRun))
        break;
      if (!readFillExact(read, one, 0, 1))
        break;
      continue;
    }
    let interiorRemaining = declaredLen - 2;
    let fill = 0;
    let truncated = false;
    while (interiorRemaining > 0) {
      const need = cap - fill;
      if (interiorRemaining >= need) {
        if (!readFillExact(read, buf, fill, need)) {
          truncated = true;
          break;
        }
        fill = cap;
        interiorRemaining = interiorRemaining - need;
        let last = maxRun;
        while (last > 0 && buf[last - 1] !== COMMA)
          last = last - 1;
        let runLen;
        let consumed;
        if (last === 0) {
          runLen = maxRun;
          consumed = maxRun;
        } else {
          runLen = last - 1;
          consumed = last;
        }
        emitRun(write, buf, 0, runLen);
        const rem = fill - consumed;
        let m = 0;
        while (m < rem) {
          buf[m] = buf[consumed + m];
          m = m + 1;
        }
        fill = rem;
      } else {
        const tmp = new Uint8Array(interiorRemaining);
        if (!readFillExact(read, tmp, 0, interiorRemaining)) {
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
          let stop = startPos + maxRun;
          if (stop >= fill) {
            stop = fill;
          } else {
            let c = stop;
            while (c > startPos && buf[c - 1] !== COMMA)
              c = c - 1;
            if (c > startPos)
              stop = c - 1;
          }
          emitRun(write, buf, startPos, stop - startPos);
          startPos = stop;
          if (startPos < fill && buf[startPos] === COMMA)
            startPos = startPos + 1;
        }
        fill = 0;
      }
    }
    if (truncated)
      break;
    if (!readFillExact(read, one, 0, 1))
      break;
  }
}
function runNmHost(read, write, log, maxFrameSize) {
  if (maxFrameSize > 0) {
    runRechunk(read, write, log, maxFrameSize);
  } else {
    runVerbatim(read, write);
  }
}

// node_modules/@loopdive/js2/examples/native-messaging/nm_js2wasm_deno.ts
function denoRead(buf) {
  return Deno.stdin.readSync(buf);
}
function denoWrite(buf) {
  let rest = buf;
  while (rest.length > 0) {
    const w = Deno.stdout.writeSync(rest);
    if (w <= 0)
      return;
    if (w >= rest.length)
      return;
    const tail = new Uint8Array(rest.length - w);
    let i = 0;
    while (i < tail.length) {
      tail[i] = rest[w + i];
      i = i + 1;
    }
    rest = tail;
  }
}
function denoNoLog(declaredLen) {}
function main() {
  const frameChunk = 1024 * 1024;
  runNmHost(denoRead, denoWrite, denoNoLog, frameChunk);
}
main();
export {
  main
};
