# NativeMessagingHosts

- Python
- C
- C++
- QuickJS
- txiki.js
- Node.js
- Deno
- Bun
- WebAssembly (`nm_c.c` compiled to WASM with WASI SDK, WAT compiled with `wasm2wat`)
- Bash (GNU Core Utilities `head; and/or Busybox `dd`, `od`)

Tested echoing `new Array(209715)` (1 MB in JSON format) from client to host. 

# Native messaging documentation
- [Chrome Developers](https://developer.chrome.com/docs/extensions/mv3/nativeMessaging/)
- [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging)
- [Microsoft Edge Developer documentation](https://learn.microsoft.com/en-us/microsoft-edge/extensions-chromium/developer-guide/native-messaging)

[Native messaging protocol](https://developer.chrome.com/docs/extensions/mv3/nativeMessaging/#native-messaging-host-protocol) (Chrome Developers)

> Chrome starts each native messaging host in a separate process and communicates with it using standard input (`stdin`) and standard output (`stdout`). The same format is used to send messages in both directions; each message is serialized using JSON, UTF-8 encoded and is preceded with 32-bit message length in native byte order. The maximum size of a single message from the native messaging host is 1 MB, mainly to protect Chrome from misbehaving native applications. The maximum size of the message sent to the native messaging host is 4 GB.

# Installation and usage

Installation and usage on Chrome and Chromium

1. Navigate to `chrome://extensions`.
2. Toggle `Developer mode`.
3. Click `Load unpacked`.
4. Select native-messaging-quickjs folder.
5. Note the generated extension ID.
6. Open, for example, `nm_c_wasm.json` in a text editor, set `"path"` to absolute path of `nm_c.wasm` and `chrome-extension://<ID>/` using ID from 5 in `"allowed_origins"` array. 
7. Copy the `nm_c_wasm.json` file to Chrome or Chromium configuration folder, e.g., Chromium on \*nix `~/.config/chromium/NativeMessagingHosts`; Chrome dev channel on \*nix `~/.config/google-chrome-unstable/NativeMessagingHosts`.
8. Make sure `wasmtime` for WASM host, or the single host file, e.g. when using QuickJS `nm_qjs.js,` are executable.
9. To test click `service worker` link in panel of unpacked extension which is DevTools for `background.js` in MV3 `ServiceWorker`, observe echo'ed message from Native Messaging host to client in  DevTools `console`. To disconnect run `port.disconnect()`.

For differences between OS and browser implementations see [Chrome incompatibilities](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Chrome_incompatibilities#native_messaging). For Firefox or Nightly usage see also [Can't get response in Ubuntu #506](https://github.com/mdn/webextensions-examples/issues/506).

# Examples

- Capture system and specific audio output, stream output to browser. [capture_system_audio](https://github.com/guest271314/captureSystemAudio/tree/master/native_messaging/capture_system_audio)
- Send text or SSML to local eSpeak NG speech syntehsis engine, stream output to browser [native-messaging-espeak-ng](https://github.com/guest271314/native-messaging-espeak-ng)
- Turn local PHP server on and off from browser [native-messaging-php](https://github.com/guest271314/native-messaging-php), see also [`deno-server`](https://github.com/guest271314/native-messaging-espeak-ng/tree/deno-server) branch in `native-messaging-espeak-ng`
- WAT embedded in a Bash shell script [nm_c_wat.sh](https://github.com/guest271314/native-messaging-webassembly/blob/main/nm_c_wat.sh) (see usage note at [10.](https://github.com/guest271314/native-messaging-webassembly#readme:~:text=for%20WAT%20embedded%20in%20nm_c_wat.sh%20we%20use%20kill_wasmtime.sh%20to%20terminate%20wasmtime%20using%20polling%20of%20nm_c_wat.sh%20because%20process%20substitution%20keeps%20wasmtime%20running%20after%20the%20Native%20Messaging%20host%20is%20disconnected%20and%20exits.))


# License
Do What the Fuck You Want to Public License [WTFPLv2](http://www.wtfpl.net/about/)
