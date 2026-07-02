// node_modules/@loopdive/js2/examples/native-messaging/nm_js2wasm_node_process.ts
var FRAME_CAP = 1024 * 1024;
var MAX_RUN = FRAME_CAP - 2;
var COMMA = 44;
var OPEN_BRACKET = 91;
var CLOSE_BRACKET = 93;
var DQUOTE = 34;
var ST_HEADER = 0;
var ST_VERBATIM = 1;
var ST_PEEK = 2;
var ST_ARRAY = 3;
var ST_STRING = 4;
var ST_TRAILER = 5;
var st = ST_HEADER;
var stopped = false;
var headerAcc = 0;
var headerMul = 1;
var headerFill = 0;
var vbuf = new Uint8Array(4);
var vfill = 0;
var vneed = 0;
var win = new Uint8Array(FRAME_CAP);
var fill = 0;
var interiorRemaining = 0;
function emitFrame(w, srcStart, runLen, open, close) {
  const bodyLen = runLen + 2;
  const out = new Uint8Array(4 + bodyLen);
  out[0] = bodyLen & 255;
  out[1] = bodyLen >> 8 & 255;
  out[2] = bodyLen >> 16 & 255;
  out[3] = bodyLen >> 24 & 255;
  out[4] = open;
  let k = 0;
  while (k < runLen) {
    out[5 + k] = w[srcStart + k];
    k = k + 1;
  }
  out[4 + runLen + 1] = close;
  process.stdout.write(out);
}
function emitArrayWindow(w) {
  let last = MAX_RUN;
  while (last > 0 && w[last - 1] !== COMMA)
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
  const bodyLen = runLen + 2;
  const out = new Uint8Array(4 + bodyLen);
  out[0] = bodyLen & 255;
  out[1] = bodyLen >> 8 & 255;
  out[2] = bodyLen >> 16 & 255;
  out[3] = bodyLen >> 24 & 255;
  out[4] = OPEN_BRACKET;
  let k = 0;
  while (k < runLen) {
    out[5 + k] = w[k];
    k = k + 1;
  }
  out[4 + runLen + 1] = CLOSE_BRACKET;
  process.stdout.write(out);
  const rem = fill - consumed;
  let m = 0;
  while (m < rem) {
    w[m] = w[consumed + m];
    m = m + 1;
  }
  fill = rem;
}
function drainArrayFinal(w) {
  let startPos = 0;
  while (startPos < fill) {
    let stop = startPos + MAX_RUN;
    if (stop >= fill) {
      stop = fill;
    } else {
      let c = stop;
      while (c > startPos && w[c - 1] !== COMMA)
        c = c - 1;
      if (c > startPos)
        stop = c - 1;
    }
    const runLen = stop - startPos;
    const bodyLen = runLen + 2;
    const out = new Uint8Array(4 + bodyLen);
    out[0] = bodyLen & 255;
    out[1] = bodyLen >> 8 & 255;
    out[2] = bodyLen >> 16 & 255;
    out[3] = bodyLen >> 24 & 255;
    out[4] = OPEN_BRACKET;
    let k = 0;
    while (k < runLen) {
      out[5 + k] = w[startPos + k];
      k = k + 1;
    }
    out[4 + runLen + 1] = CLOSE_BRACKET;
    process.stdout.write(out);
    startPos = stop;
    if (startPos < fill && w[startPos] === COMMA)
      startPos = startPos + 1;
  }
  fill = 0;
}
function onData(chunk) {
  if (stopped)
    return;
  const n = chunk.length;
  let ci = 0;
  while (ci < n && !stopped) {
    if (st === ST_HEADER) {
      while (headerFill < 4 && ci < n) {
        headerAcc = headerAcc + (chunk.charCodeAt(ci) & 255) * headerMul;
        headerMul = headerMul * 256;
        headerFill = headerFill + 1;
        ci = ci + 1;
      }
      if (headerFill < 4)
        return;
      const len = headerAcc;
      headerAcc = 0;
      headerMul = 1;
      headerFill = 0;
      if (len === 0) {
        stopped = true;
        process.stdin.destroy();
        return;
      }
      if (len <= FRAME_CAP) {
        vneed = 4 + len;
        vbuf = new Uint8Array(vneed);
        vbuf[0] = len & 255;
        vbuf[1] = len >> 8 & 255;
        vbuf[2] = len >> 16 & 255;
        vbuf[3] = len >> 24 & 255;
        vfill = 4;
        st = ST_VERBATIM;
      } else {
        interiorRemaining = len - 2;
        fill = 0;
        st = ST_PEEK;
      }
    } else if (st === ST_VERBATIM) {
      let avail = n - ci;
      const space = vneed - vfill;
      if (avail > space)
        avail = space;
      let k = 0;
      while (k < avail) {
        vbuf[vfill + k] = chunk.charCodeAt(ci + k) & 255;
        k = k + 1;
      }
      vfill = vfill + avail;
      ci = ci + avail;
      if (vfill === vneed) {
        process.stdout.write(vbuf);
        st = ST_HEADER;
      }
    } else if (st === ST_PEEK) {
      const b = chunk.charCodeAt(ci) & 255;
      ci = ci + 1;
      if (b === DQUOTE) {
        st = ST_STRING;
      } else {
        st = ST_ARRAY;
      }
    } else if (st === ST_ARRAY) {
      let avail = n - ci;
      const space = FRAME_CAP - fill;
      if (avail > space)
        avail = space;
      if (avail > interiorRemaining)
        avail = interiorRemaining;
      let k = 0;
      while (k < avail) {
        win[fill + k] = chunk.charCodeAt(ci + k) & 255;
        k = k + 1;
      }
      fill = fill + avail;
      ci = ci + avail;
      interiorRemaining = interiorRemaining - avail;
      if (interiorRemaining === 0) {
        drainArrayFinal(win);
        st = ST_TRAILER;
      } else if (fill === FRAME_CAP) {
        emitArrayWindow(win);
      }
    } else if (st === ST_STRING) {
      let avail = n - ci;
      const space = MAX_RUN - fill;
      if (avail > space)
        avail = space;
      if (avail > interiorRemaining)
        avail = interiorRemaining;
      let k = 0;
      while (k < avail) {
        win[fill + k] = chunk.charCodeAt(ci + k) & 255;
        k = k + 1;
      }
      fill = fill + avail;
      ci = ci + avail;
      interiorRemaining = interiorRemaining - avail;
      if (fill === MAX_RUN) {
        emitFrame(win, 0, MAX_RUN, DQUOTE, DQUOTE);
        fill = 0;
      }
      if (interiorRemaining === 0) {
        if (fill > 0) {
          emitFrame(win, 0, fill, DQUOTE, DQUOTE);
          fill = 0;
        }
        st = ST_TRAILER;
      }
    } else if (st === ST_TRAILER) {
      ci = ci + 1;
      st = ST_HEADER;
    }
  }
}
function main() {
  process.stdin.setEncoding("latin1");
  process.stdin.on("data", (chunk) => {
    onData(chunk);
  });
  process.stdin.on("end", () => {});
}
main();
