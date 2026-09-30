//! deno_core Native Messaging host
//! https://github.com/denoland/roll-your-own-javascript-runtime
//! https://github.com/guest271314/roll-your-own-javascript-runtime
//! guest271314 9-20-2026

use deno_ast::MediaType;
use deno_ast::ParseParams;
use deno_core::error::AnyError;
use deno_core::error::ModuleLoaderError;
use deno_core::{
  AsyncResult, BufMutView, BufView, ModuleLoadResponse, ModuleSourceCode, Resource, WriteOutcome,
};
use deno_error::JsErrorBox;
use std::io::{self, Read, Write};
use std::rc::Rc;
// use std::env;

// 1. Dual-Format Polyvalent Module Loader
struct JsTsModuleLoaderModuleLoader {
  embedded_code: &'static str,
  is_typescript: bool,
}

impl deno_core::ModuleLoader for JsTsModuleLoaderModuleLoader {
  fn resolve(
    &self,
    specifier: &str,
    referrer: &str,
    _kind: deno_core::ResolutionKind,
  ) -> Result<deno_core::ModuleSpecifier, ModuleLoaderError> {
    deno_core::resolve_import(specifier, referrer).map_err(|e| JsErrorBox::from_err(e))
  }

  fn load(
    &self,
    module_specifier: &deno_core::ModuleSpecifier,
    _maybe_referrer: Option<&deno_core::ModuleLoadReferrer>,
    _options: deno_core::ModuleLoadOptions,
  ) -> ModuleLoadResponse {
    let module_specifier = module_specifier.clone();
    let embedded_code = self.embedded_code;
    let is_typescript = self.is_typescript;

    let module_load = move || {
      let specifier_str = module_specifier.as_str();

      // Determine if loading the embedded asset or a fallback local filesystem module
      let (code, media_type) =
        if specifier_str == "file:///main.ts" || specifier_str == "file:///main.js" {
          let detected_media = if is_typescript {
            MediaType::TypeScript
          } else {
            MediaType::JavaScript
          };
          (embedded_code.to_string(), detected_media)
        } else {
          let path = module_specifier.to_file_path().map_err(|_| {
            io::Error::new(io::ErrorKind::InvalidInput, "Invalid file path specifier")
          })?;
          let file_content = std::fs::read_to_string(&path)?;
          let detected_type = MediaType::from_path(&path);
          (file_content, detected_type)
        };

      let (module_type, should_transpile) = match media_type {
        MediaType::JavaScript | MediaType::Mjs | MediaType::Cjs => {
          (deno_core::ModuleType::JavaScript, false)
        }
        MediaType::Jsx => (deno_core::ModuleType::JavaScript, true),
        MediaType::TypeScript
        | MediaType::Mts
        | MediaType::Cts
        | MediaType::Dts
        | MediaType::Dmts
        | MediaType::Dcts
        | MediaType::Tsx => (deno_core::ModuleType::JavaScript, true),
        MediaType::Json => (deno_core::ModuleType::Json, false),
        _ => {
          return Err(io::Error::new(
            io::ErrorKind::Unsupported,
            format!("Unsupported media type for specifier: {}", specifier_str),
          ));
        }
      };

      let final_code = if should_transpile {
        let parsed = deno_ast::parse_module(ParseParams {
          specifier: module_specifier.clone(),
          text: code.into(),
          media_type,
          capture_tokens: false,
          scope_analysis: false,
          maybe_syntax: None,
        })
        .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e.to_string()))?;

        parsed
          .transpile(
            &Default::default(),
            &Default::default(),
            &Default::default(),
          )
          .map_err(|e| io::Error::new(io::ErrorKind::InvalidData, e.to_string()))?
          .into_source()
          .text
      } else {
        code
      };

      let module = deno_core::ModuleSource::new(
        module_type,
        ModuleSourceCode::String(final_code.into()),
        &module_specifier,
        None,
      );
      Ok(module)
    };

    match module_load() {
      Ok(source) => ModuleLoadResponse::Sync(Ok(source)),
      Err(err) => ModuleLoadResponse::Sync(Err(JsErrorBox::from_err(err))),
    }
  }
}

// 2. Standard Streams I/O Resource Registries
struct StdinResource;
impl Resource for StdinResource {
  fn name(&self) -> std::borrow::Cow<'_, str> {
    "stdin".into()
  }
  fn read_byob(self: Rc<Self>, mut buf: BufMutView) -> AsyncResult<(usize, BufMutView)> {
    Box::pin(async move {
      let mut stdin = io::stdin().lock();
      let nread = match stdin.read(&mut buf) {
        Ok(n) => n,
        Err(_) => 0,
      };
      Ok((nread, buf))
    })
  }
}

struct StdoutResource;
impl Resource for StdoutResource {
  fn name(&self) -> std::borrow::Cow<'_, str> {
    "stdout".into()
  }
  fn write(self: Rc<Self>, buf: BufView) -> AsyncResult<WriteOutcome> {
    let mut stdout = io::stdout().lock();
    let nwritten = buf.len();
    let _ = stdout.write_all(&buf);
    let _ = stdout.flush();
    Box::pin(std::future::ready(Ok(WriteOutcome::Full { nwritten })))
  }
}

struct StderrResource;
impl Resource for StderrResource {
  fn name(&self) -> std::borrow::Cow<'_, str> {
    "stderr".into()
  }
  fn write(self: Rc<Self>, buf: BufView) -> AsyncResult<WriteOutcome> {
    let mut stderr = io::stderr().lock();
    let nwritten = buf.len();
    let _ = stderr.write_all(&buf);
    let _ = stderr.flush();
    Box::pin(std::future::ready(Ok(WriteOutcome::Full { nwritten })))
  }
}
/// TODO: Execute only snapshot
// static RUNTIME_SNAPSHOT: &[u8] =
//   include_bytes!(concat!(env!("OUT_DIR"), "/nm_runjs.bin"));

// 3. Main runtime bootstrapper
async fn run_js(embedded_code: &'static str, filename: &str) -> Result<(), AnyError> {
  let is_typescript = filename.ends_with(".ts");
  let loader = Rc::new(JsTsModuleLoaderModuleLoader {
    embedded_code,
    is_typescript,
  });

  let mut js_runtime = deno_core::JsRuntime::new(deno_core::RuntimeOptions {
    module_loader: Some(loader),
    startup_snapshot: None, // Some(RUNTIME_SNAPSHOT),
    ..Default::default()
  });

  let op_state = js_runtime.op_state();
  let mut state = op_state.borrow_mut();
  state.resource_table.add(StdinResource);
  state.resource_table.add(StdoutResource);
  state.resource_table.add(StderrResource);
  drop(state);

  // Dynamic routing based on embedded file type extension matches
  let virtual_url = if is_typescript {
    "file:///main.ts"
  } else {
    "file:///main.js"
  };
  let specifier = deno_core::ModuleSpecifier::parse(virtual_url).unwrap();

  let mod_id = js_runtime.load_main_es_module(&specifier).await?;
  let evaluation = js_runtime.mod_evaluate(mod_id);

  js_runtime.run_event_loop(Default::default()).await?;

  evaluation.await?;
  Ok(())
}

fn main() {
  // Point this to your script path asset target. It works for both .js and .ts extensions.
  const FILENAME: &str = "nm_runjs.ts";
  // let code = include_str!("nm_runjs.ts");
  // let code = include_str!("nm_runjs.js");
  let code = r#"
//! deno_core TypeScript Native Messaging host
//! https://github.com/denoland/roll-your-own-javascript-runtime
//! https://github.com/guest271314/roll-your-own-javascript-runtime
//! guest271314 9-20-2026

const STDIN_RID: number = 0;
const STDOUT_RID: number = 1;
const STDERR_RID: number = 2;

async function readStdinBytes(buffer: Uint8Array<ArrayBuffer>): Promise<number> {
  return Deno.core.ops.op_read(STDIN_RID, buffer);
}

async function writeStdoutBytes(buffer: Uint8Array<ArrayBuffer>): Promise<number> {
  return Deno.core.ops.op_write(STDOUT_RID, buffer);
}

async function writeStderrBytes(buffer: Uint8Array<ArrayBuffer>): Promise<number> {
  return Deno.core.ops.op_write(STDERR_RID, buffer);
}

async function encode(str: string): Uint8Array<ArrayBuffer> {
  return Deno.encode(str);
}

function exit(exitCode: number = 0): void {
  // 1. Force close the OS resource channels tracked by your Rust application
  Deno.core.close(STDIN_RID);
  Deno.core.close(STDOUT_RID);
  Deno.core.close(STDERR_RID);
  if (exitCode > 0) {
    // 2. Throw an explicit error to halt the immediate synchronous execution thread
    throw new Error(`ProcessExit: ${exitCode}`);
  }
}

const buffer: ArrayBuffer = new ArrayBuffer(0, {
  maxByteLength: 1024 ** 2 * 64,
});
// const encoder: TextEncoder = new TextEncoder();

function encodeMessage(message: object): Uint8Array<ArrayBuffer> {
  const jsonString: string = JSON.stringify(message);
  const encoded: Uint8Array = encode(jsonString);
  return new Uint8Array(encoded.buffer) as Uint8Array<ArrayBuffer>;
}

async function readExactly(
  bytesToRead: number,
  targetBuffer: Uint8Array<ArrayBuffer>,
  offset: number,
): Promise<boolean> {
  let totalRead: number = 0;
  while (totalRead < bytesToRead) {
    const subview: Uint8Array<ArrayBuffer> = targetBuffer.subarray(
      offset + totalRead,
      offset + bytesToRead,
    ) as Uint8Array<ArrayBuffer>;
    const chunk: number | null = await readStdinBytes(
      subview,
    );
    if (chunk === 0 || chunk === null) {
      return false;
    }
    totalRead += chunk;
  }
  return true;
}

async function* getMessage(): AsyncGenerator<
  Uint8Array<ArrayBuffer>,
  void,
  unknown
> {
  const headerBuffer: Uint8Array<ArrayBuffer> = new Uint8Array(4) as Uint8Array<
    ArrayBuffer
  >;

  while (true) {
    const successHeader: boolean = await readExactly(4, headerBuffer, 0);
    if (!successHeader) return;

    // Extract little-endian 32-bit unsigned integer using bitwise operations
    const totalMessageLength: number = (
      (headerBuffer[3] << 24) |
      (headerBuffer[2] << 16) |
      (headerBuffer[1] << 8) |
      (headerBuffer[0])
    ) >>> 0; // Use zero-fill right shift to force an unsigned 32-bit integer

    (buffer as ArrayBuffer).resize(totalMessageLength);
    const bodySlice: Uint8Array<ArrayBuffer> = new Uint8Array(
      buffer,
    ) as Uint8Array<ArrayBuffer>;

    const successBody: boolean = await readExactly(
      totalMessageLength,
      bodySlice,
      0,
    );
    if (!successBody) return;

    yield new Uint8Array(buffer.slice(0)) as Uint8Array<ArrayBuffer>;
    (buffer as ArrayBuffer).resize(0);
  }
}

async function sendMessage(message: Uint8Array<ArrayBuffer>): Promise<void> {
  const COMMA: number = 44;
  const OPEN_BRACKET: number = 91;
  const CLOSE_BRACKET: number = 93;
  const CHUNK_SIZE: number = 1024 * 1024;

  if (message.length <= CHUNK_SIZE) {
    const sizeBuffer: Uint32Array = new Uint32Array([message.length]);
    const header: Uint8Array<ArrayBuffer> = new Uint8Array(
      sizeBuffer.buffer,
    ) as Uint8Array<ArrayBuffer>;
    await writeStdoutBytes(header);
    await writeStdoutBytes(message);
    return;
  }

  let index: number = 0;

  while (index < message.length) {
    let splitIndex: number = 0;
    let searchStart: number = index + CHUNK_SIZE - 8;

    if (searchStart >= message.length) {
      splitIndex = message.length;
    } else {
      splitIndex = message.indexOf(COMMA, searchStart);
      if (splitIndex === -1) {
        splitIndex = message.length;
      }
    }

    const rawChunk: Uint8Array<ArrayBuffer> = message.subarray(
      index,
      splitIndex,
    ) as Uint8Array<ArrayBuffer>;
    const startByte: number = rawChunk[0];
    const endByte: number = rawChunk[rawChunk.length - 1];

    let prepend: number | null = null;
    let append: number | null = null;

    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      append = CLOSE_BRACKET;
    } else if (startByte === COMMA) {
      prepend = OPEN_BRACKET;
      if (endByte !== CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }
    }

    let bodyLength: number = rawChunk.length;
    let sourceOffset: number = 0;
    if (startByte === COMMA) {
      sourceOffset = 1;
      bodyLength -= 1;
    }

    const totalLength: number = 4 + (prepend !== null ? 1 : 0) + bodyLength +
      (append !== null ? 1 : 0);
    const output: Uint8Array<ArrayBuffer> = new Uint8Array(
      totalLength,
    ) as Uint8Array<ArrayBuffer>;

    const dataPayloadLen: number = totalLength - 4;
    output[0] = (dataPayloadLen >> 0) & 0xff;
    output[1] = (dataPayloadLen >> 8) & 0xff;
    output[2] = (dataPayloadLen >> 16) & 0xff;
    output[3] = (dataPayloadLen >> 24) & 0xff;

    let cursor: number = 4;
    if (prepend !== null) {
      output[cursor] = prepend;
      cursor++;
    } else if (startByte === COMMA) {
      output[cursor] = OPEN_BRACKET;
      cursor++;
    }

    const subview: Uint8Array<ArrayBuffer> = rawChunk.subarray(
      sourceOffset,
    ) as Uint8Array<ArrayBuffer>;
    output.set(subview, cursor);
    cursor += bodyLength;

    if (append !== null) {
      output[cursor] = append;
    }

    await writeStdoutBytes(output);
    index = splitIndex;
  }
}

async function main(): Promise<void> {
  try {
    for await (const message of getMessage()) {
      await sendMessage(message);
    }
  } catch (e) {
    writeStderrBytes(encodeMessage(e.message)).catch((_) => {
      exit(1);
    });
  }
}

(globalThis as any).main = main;

main().catch((_) => {
  exit(1);
});

"#;

  let runtime = tokio::runtime::Builder::new_current_thread()
    .enable_all()
    .build()
    .unwrap();

  if let Err(error) = runtime.block_on(run_js(code, FILENAME)) {
    eprintln!("error: {}", error);
  }
}
