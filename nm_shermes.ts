/**
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
// https://github.com/facebook/hermes/tree/static_h/examples/ffi
// Static Hermes Native Messaging host
// guest271314 10-2-2025
// shermes -typed -Wc,-nostartfiles nm_shermes.ts -o nm_shermes
"use strict";

// Emulate a module scope, since global scope is unsound.
(function (exports) {
  const _nativeMessagingHost = $SHBuiltin.extern_c(
    { include: "/home/user/native-messaging-shermes/nm_c_nostartup.c" },
    function nativeMessagingHost(): c_int {
      throw 0;
    },
  );

 _nativeMessagingHost();
  // Optionally force some methods to be emitted for debugging.
  // exports.foo = foo;
})({});
