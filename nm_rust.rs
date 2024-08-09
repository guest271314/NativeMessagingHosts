#!/usr/bin/env -S /home/user/.cargo/bin/cargo -Zscript
// Rust Native Messaging Host
// https://gist.github.com/TotallyNotChase/c747c55d4a965954f49a7fa5c3f344e0
// https://users.rust-lang.org/t/how-to-implement-a-native-messaging-host-using-only-rust-standard-library/115603/13
// https://play.rust-lang.org/?version=stable&mode=debug&edition=2021&gist=d99e3a23d1c17aa0b5f4ced4e3046eda
// https://doc.rust-lang.org/cargo/reference/unstable.html#script
// 8-7-2024
use std::io::{self, Read, Write};
// TODO: Handle errors
fn main() -> Result<(), Box<dyn std::error::Error>> {
  loop {
    let message = getMessage()?;
    // eprintln!("{:?}", std::str::from_utf8(&msg));
    sendMessage(&message)?;
  }
}

pub fn getMessage() -> io::Result<Vec<u8>> {
  let mut stdin = io::stdin();
  let mut length = [0; 4];
  stdin.read_exact(&mut length)?;
  let mut buffer = vec![0; u32::from_ne_bytes(length) as usize];
  stdin.read_exact(&mut buffer)?;
  Ok(buffer)
}

pub fn sendMessage(message: &[u8]) -> io::Result<()> {
  let mut stdout = io::stdout();
  let length = message.len() as u32;
  stdout.write_all(&length.to_ne_bytes())?;
  stdout.write_all(message)?;
  stdout.flush()?;
  Ok(())
}
