/// rquickjs https://crates.io/crates/rquickjs
/// Native Messaging host nm_rquickjs.js
/// Globals defined for I/O in ECMAScript: std.in.read(), std.out.write(), std.stderr.write()
/// guest271314 9-23-2026
use rquickjs::{Context, Function, Object, Runtime, Value};
use std::error::Error;
use std::io::{self, Read, Write};

/// High-performance read helper. Links the 'js context lifetime to the returned raw
/// Value variant explicitly to pass Rust's strict compiler variance checks.
fn safe_read<'js>(ctx: rquickjs::Ctx<'js>, bytes_to_read: usize) -> rquickjs::Result<Value<'js>> {
  let mut buf = vec![0u8; bytes_to_read];
  let mut stdin = io::stdin().lock();
  let len = match stdin.read_exact(&mut buf) {
    Ok(_) => bytes_to_read,
    Err(_) => 0,
  };

  unsafe {
    let raw_ctx = ctx.as_raw().as_ptr();
    let raw_val =
      rquickjs::qjs::JS_NewArrayBufferCopy(raw_ctx, buf.as_ptr(), len as rquickjs::qjs::size_t);
    Ok(Value::from_raw(ctx, raw_val))
  }
}

fn main() -> Result<(), Box<dyn Error>> {
  let runtime = Runtime::new()?;
  let context = Context::full(&runtime)?;

  context.with(|ctx| {
    let global = ctx.globals();

    // 1. Bind std.in.read using our helper function
    let std_in_read = Function::new(ctx.clone(), safe_read)?;

    // 2. Bind std.out.write
    let std_out_write = Function::new(
      ctx.clone(),
      |ctx: rquickjs::Ctx<'_>, val: Value<'_>, offset: usize, length: usize| unsafe {
        let raw_ctx = ctx.as_raw().as_ptr();
        let raw_val = val.as_raw();
        let mut out_len: rquickjs::qjs::size_t = 0;
        let ptr = rquickjs::qjs::JS_GetArrayBuffer(raw_ctx, &mut out_len, raw_val);

        if !ptr.is_null() && offset + length <= out_len as usize {
          let target_slice = std::slice::from_raw_parts(ptr.add(offset), length);
          let mut stdout = io::stdout().lock();
          let _ = stdout.write_all(target_slice);
        }
      },
    )?;

    // 3. Bind std.out.flush
    let std_out_flush = Function::new(ctx.clone(), || {
      let _ = io::stdout().lock().flush();
    })?;

    // 4. Bind std.stderr.write (💡 NEW: Native Error Stream Writer)
    let std_err_write = Function::new(
      ctx.clone(),
      |ctx: rquickjs::Ctx<'_>, val: Value<'_>, offset: usize, length: usize| unsafe {
        let raw_ctx = ctx.as_raw().as_ptr();
        let raw_val = val.as_raw();
        let mut out_len: rquickjs::qjs::size_t = 0;
        let ptr = rquickjs::qjs::JS_GetArrayBuffer(raw_ctx, &mut out_len, raw_val);

        if !ptr.is_null() && offset + length <= out_len as usize {
          let target_slice = std::slice::from_raw_parts(ptr.add(offset), length);
          let mut stderr = io::stderr().lock();
          let _ = stderr.write_all(target_slice);
        }
      },
    )?;

    // 5. Bind std.stderr.flush (💡 NEW: Native Error Stream Flusher)
    let std_err_flush = Function::new(ctx.clone(), || {
      let _ = io::stderr().lock().flush();
    })?;

    // 6. Bind std.exit
    let std_exit = Function::new(ctx.clone(), |code: i32| -> rquickjs::Result<()> {
      std::process::exit(code);
    })?;

    // Establish the QuickJS compliant object tree hierarchy
    let std_obj = Object::new(ctx.clone())?;
    let in_obj = Object::new(ctx.clone())?;
    let out_obj = Object::new(ctx.clone())?;
    let err_obj = Object::new(ctx.clone())?;

    in_obj.set("read", std_in_read)?;

    out_obj.set("write", std_out_write)?;
    out_obj.set("flush", std_out_flush)?;

    err_obj.set("write", std_err_write)?;
    err_obj.set("flush", std_err_flush)?;

    std_obj.set("in", in_obj)?;
    std_obj.set("out", out_obj)?;
    std_obj.set("stderr", err_obj)?; // 💡 Exposed as std.stderr matching qjs spec
    std_obj.set("exit", std_exit)?;

    global.set("std", std_obj)?;

    // 7. Embedded High-Performance JavaScript Orchestration Script
    // let js_code = include_str!("nm_rquickjs.js");
    let js_code = r#"
// rquickjs Native Messaging host
// Based on https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_qjs_64.js
// guest271314 9-23-2026
function getMessage() {
  const headerBuffer = std.in.read(4);
  if (!headerBuffer || headerBuffer.byteLength === 0) return null;

  const view = new DataView(headerBuffer);
  const messageLength = view.getUint32(0, true);

  const bodyBuffer = std.in.read(messageLength);
  if (!bodyBuffer || bodyBuffer.byteLength === 0) return null;

  return new Uint8Array(bodyBuffer);
}

function sendMessage(message) {
  const COMMA = 44;
  const OPEN_BRACKET = 91;
  const CLOSE_BRACKET = 93;
  const CHUNK_SIZE = 1024 * 1024; // 1MB

  if (message.length <= CHUNK_SIZE) {
    const output = new Uint8Array(4 + message.length);
    output[0] = (message.length >> 0) & 0xff;
    output[1] = (message.length >> 8) & 0xff;
    output[2] = (message.length >> 16) & 0xff;
    output[3] = (message.length >> 24) & 0xff;
    output.set(message, 4);

    std.out.write(output.buffer, 0, output.length);
    std.out.flush();
    return;
  }

  let index = 0;

  while (index < message.length) {
    let splitIndex;
    let searchStart = index + CHUNK_SIZE - 8;

    if (searchStart >= message.length) {
      splitIndex = message.length;
    } else {
      splitIndex = message.indexOf(COMMA, searchStart);
      if (splitIndex === -1) {
        splitIndex = message.length;
      }
    }

    const rawChunk = message.subarray(index, splitIndex);
    const startByte = rawChunk[0];
    const endByte = rawChunk[rawChunk.length - 1];

    let prepend = null;
    let append = null;

    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      append = CLOSE_BRACKET;
    } else if (startByte === COMMA) {
      prepend = OPEN_BRACKET;
      if (endByte !== CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }
    }

    let bodyLength = rawChunk.length;
    let sourceOffset = 0;
    if (startByte === COMMA) {
      sourceOffset = 1;
      bodyLength -= 1;
    }

    const hasPrepend = prepend !== null;
    const hasAppend = append !== null;

    const totalLength = 4 + (hasPrepend ? 1 : 0) + bodyLength +
      (hasAppend ? 1 : 0);
    const output = new Uint8Array(totalLength);

    const dataLen = totalLength - 4;
    output[0] = (dataLen >> 0) & 0xff;
    output[1] = (dataLen >> 8) & 0xff;
    output[2] = (dataLen >> 16) & 0xff;
    output[3] = (dataLen >> 24) & 0xff;

    let cursor = 4;
    if (hasPrepend) {
      output[cursor] = prepend;
      cursor++;
    } else if (startByte === COMMA) {
      output[cursor] = OPEN_BRACKET;
      cursor++;
    }

    output.set(rawChunk.subarray(sourceOffset), cursor);
    cursor += bodyLength;

    if (hasAppend) {
      output[cursor] = append;
    }

    std.out.write(output.buffer, 0, output.length);
    std.out.flush();

    index = splitIndex;
  }
}

function main() {
  while (true) {
    try {
      const message = getMessage();
      if (!message) return;
      sendMessage(message);
    } catch (err) {
      const errPayload = new Uint8Array(
        Array.from(`Exception: ${err.message}\n`).map((c) => c.charCodeAt(0)),
      );
      std.stderr.write(errPayload.buffer, 0, errPayload.length);
      std.stderr.flush();
    }
  }
}

try {
  main();
} catch (e) {
  std.exit(0);
}

    "#;

    let _ = ctx.eval::<(), _>(js_code)?;
    Ok::<(), rquickjs::Error>(())
  })?;

  Ok(())
}
