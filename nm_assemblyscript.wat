(module
 (type $0 (func (param i32) (result i32)))
 (type $1 (func (param i32 i32)))
 (type $2 (func (param i32)))
 (type $3 (func (param i32 i32) (result i32)))
 (type $4 (func))
 (type $5 (func (param i32 i32 i32) (result i32)))
 (type $6 (func (param i32 i32 i32 i32) (result i32)))
 (type $7 (func (param i32 i32 i32)))
 (type $8 (func (result i32)))
 (type $9 (func (param i32 i32 i64)))
 (type $10 (func (param i32 i32 i32 i32)))
 (import "wasi_snapshot_preview1" "fd_write" (func $~lib/bindings/wasi_snapshot_preview1/fd_write (param i32 i32 i32 i32) (result i32)))
 (import "wasi_snapshot_preview1" "proc_exit" (func $~lib/bindings/wasi_snapshot_preview1/proc_exit (param i32)))
 (import "wasi_snapshot_preview1" "fd_read" (func $~lib/bindings/wasi_snapshot_preview1/fd_read (param i32 i32 i32 i32) (result i32)))
 (global $~argumentsLength (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/total (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/threshold (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/state (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/visitCount (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/pinSpace (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/iter (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/toSpace (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/white (mut i32) (i32.const 0))
 (global $~lib/rt/itcms/fromSpace (mut i32) (i32.const 0))
 (global $~lib/rt/tlsf/ROOT (mut i32) (i32.const 0))
 (global $~lib/memory/__stack_pointer (mut i32) (i32.const 37660))
 (global $~started (mut i32) (i32.const 0))
 (memory $0 1)
 (data $0 (i32.const 1036) "<")
 (data $0.1 (i32.const 1048) "\02\00\00\00$\00\00\00U\00n\00p\00a\00i\00r\00e\00d\00 \00s\00u\00r\00r\00o\00g\00a\00t\00e")
 (data $1 (i32.const 1100) ",")
 (data $1.1 (i32.const 1112) "\02\00\00\00\1c\00\00\00~\00l\00i\00b\00/\00s\00t\00r\00i\00n\00g\00.\00t\00s")
 (data $2 (i32.const 1148) ",")
 (data $2.1 (i32.const 1160) "\02\00\00\00\1c\00\00\00I\00n\00v\00a\00l\00i\00d\00 \00l\00e\00n\00g\00t\00h")
 (data $3 (i32.const 1196) "<")
 (data $3.1 (i32.const 1208) "\02\00\00\00&\00\00\00~\00l\00i\00b\00/\00a\00r\00r\00a\00y\00b\00u\00f\00f\00e\00r\00.\00t\00s")
 (data $4 (i32.const 1260) "<")
 (data $4.1 (i32.const 1272) "\02\00\00\00(\00\00\00A\00l\00l\00o\00c\00a\00t\00i\00o\00n\00 \00t\00o\00o\00 \00l\00a\00r\00g\00e")
 (data $5 (i32.const 1324) "<")
 (data $5.1 (i32.const 1336) "\02\00\00\00 \00\00\00~\00l\00i\00b\00/\00r\00t\00/\00i\00t\00c\00m\00s\00.\00t\00s")
 (data $8 (i32.const 1452) "<")
 (data $8.1 (i32.const 1464) "\02\00\00\00$\00\00\00I\00n\00d\00e\00x\00 \00o\00u\00t\00 \00o\00f\00 \00r\00a\00n\00g\00e")
 (data $9 (i32.const 1516) ",")
 (data $9.1 (i32.const 1528) "\02\00\00\00\14\00\00\00~\00l\00i\00b\00/\00r\00t\00.\00t\00s")
 (data $11 (i32.const 1596) "<")
 (data $11.1 (i32.const 1608) "\02\00\00\00\1e\00\00\00~\00l\00i\00b\00/\00r\00t\00/\00t\00l\00s\00f\00.\00t\00s")
 (data $12 (i32.const 1660) "<")
 (data $12.1 (i32.const 1672) "\02\00\00\00(\00\00\00~\00l\00i\00b\00/\00w\00a\00s\00i\00_\00p\00r\00o\00c\00e\00s\00s\00.\00t\00s")
 (data $14 (i32.const 1756) ",")
 (data $14.1 (i32.const 1768) "\02\00\00\00\0e\00\00\00S\00U\00C\00C\00E\00S\00S")
 (data $15 (i32.const 1804) "\1c")
 (data $15.1 (i32.const 1816) "\02\00\00\00\0c\00\00\00T\00O\00O\00B\00I\00G")
 (data $16 (i32.const 1836) "\1c")
 (data $16.1 (i32.const 1848) "\02\00\00\00\n\00\00\00A\00C\00C\00E\00S")
 (data $17 (i32.const 1868) ",")
 (data $17.1 (i32.const 1880) "\02\00\00\00\12\00\00\00A\00D\00D\00R\00I\00N\00U\00S\00E")
 (data $18 (i32.const 1916) ",")
 (data $18.1 (i32.const 1928) "\02\00\00\00\18\00\00\00A\00D\00D\00R\00N\00O\00T\00A\00V\00A\00I\00L")
 (data $19 (i32.const 1964) ",")
 (data $19.1 (i32.const 1976) "\02\00\00\00\16\00\00\00A\00F\00N\00O\00S\00U\00P\00P\00O\00R\00T")
 (data $20 (i32.const 2012) "\1c")
 (data $20.1 (i32.const 2024) "\02\00\00\00\n\00\00\00A\00G\00A\00I\00N")
 (data $21 (i32.const 2044) ",")
 (data $21.1 (i32.const 2056) "\02\00\00\00\0e\00\00\00A\00L\00R\00E\00A\00D\00Y")
 (data $22 (i32.const 2092) "\1c")
 (data $22.1 (i32.const 2104) "\02\00\00\00\08\00\00\00B\00A\00D\00F")
 (data $23 (i32.const 2124) "\1c")
 (data $23.1 (i32.const 2136) "\02\00\00\00\0c\00\00\00B\00A\00D\00M\00S\00G")
 (data $24 (i32.const 2156) "\1c")
 (data $24.1 (i32.const 2168) "\02\00\00\00\08\00\00\00B\00U\00S\00Y")
 (data $25 (i32.const 2188) ",")
 (data $25.1 (i32.const 2200) "\02\00\00\00\10\00\00\00C\00A\00N\00C\00E\00L\00E\00D")
 (data $26 (i32.const 2236) "\1c")
 (data $26.1 (i32.const 2248) "\02\00\00\00\n\00\00\00C\00H\00I\00L\00D")
 (data $27 (i32.const 2268) ",")
 (data $27.1 (i32.const 2280) "\02\00\00\00\16\00\00\00C\00O\00N\00N\00A\00B\00O\00R\00T\00E\00D")
 (data $28 (i32.const 2316) ",")
 (data $28.1 (i32.const 2328) "\02\00\00\00\16\00\00\00C\00O\00N\00N\00R\00E\00F\00U\00S\00E\00D")
 (data $29 (i32.const 2364) ",")
 (data $29.1 (i32.const 2376) "\02\00\00\00\12\00\00\00C\00O\00N\00N\00R\00E\00S\00E\00T")
 (data $30 (i32.const 2412) "\1c")
 (data $30.1 (i32.const 2424) "\02\00\00\00\0c\00\00\00D\00E\00A\00D\00L\00K")
 (data $31 (i32.const 2444) ",")
 (data $31.1 (i32.const 2456) "\02\00\00\00\16\00\00\00D\00E\00S\00T\00A\00D\00D\00R\00R\00E\00Q")
 (data $32 (i32.const 2492) "\1c")
 (data $32.1 (i32.const 2504) "\02\00\00\00\06\00\00\00D\00O\00M")
 (data $33 (i32.const 2524) "\1c")
 (data $33.1 (i32.const 2536) "\02\00\00\00\n\00\00\00D\00Q\00U\00O\00T")
 (data $34 (i32.const 2556) "\1c")
 (data $34.1 (i32.const 2568) "\02\00\00\00\n\00\00\00E\00X\00I\00S\00T")
 (data $35 (i32.const 2588) "\1c")
 (data $35.1 (i32.const 2600) "\02\00\00\00\n\00\00\00F\00A\00U\00L\00T")
 (data $36 (i32.const 2620) "\1c")
 (data $36.1 (i32.const 2632) "\02\00\00\00\08\00\00\00F\00B\00I\00G")
 (data $37 (i32.const 2652) ",")
 (data $37.1 (i32.const 2664) "\02\00\00\00\16\00\00\00H\00O\00S\00T\00U\00N\00R\00E\00A\00C\00H")
 (data $38 (i32.const 2700) "\1c")
 (data $38.1 (i32.const 2712) "\02\00\00\00\08\00\00\00I\00D\00R\00M")
 (data $39 (i32.const 2732) "\1c")
 (data $39.1 (i32.const 2744) "\02\00\00\00\n\00\00\00I\00L\00S\00E\00Q")
 (data $40 (i32.const 2764) ",")
 (data $40.1 (i32.const 2776) "\02\00\00\00\14\00\00\00I\00N\00P\00R\00O\00G\00R\00E\00S\00S")
 (data $41 (i32.const 2812) "\1c")
 (data $41.1 (i32.const 2824) "\02\00\00\00\08\00\00\00I\00N\00T\00R")
 (data $42 (i32.const 2844) "\1c")
 (data $42.1 (i32.const 2856) "\02\00\00\00\n\00\00\00I\00N\00V\00A\00L")
 (data $43 (i32.const 2876) "\1c")
 (data $43.1 (i32.const 2888) "\02\00\00\00\04\00\00\00I\00O")
 (data $44 (i32.const 2908) "\1c")
 (data $44.1 (i32.const 2920) "\02\00\00\00\0c\00\00\00I\00S\00C\00O\00N\00N")
 (data $45 (i32.const 2940) "\1c")
 (data $45.1 (i32.const 2952) "\02\00\00\00\n\00\00\00I\00S\00D\00I\00R")
 (data $46 (i32.const 2972) "\1c")
 (data $46.1 (i32.const 2984) "\02\00\00\00\08\00\00\00L\00O\00O\00P")
 (data $47 (i32.const 3004) "\1c")
 (data $47.1 (i32.const 3016) "\02\00\00\00\n\00\00\00M\00F\00I\00L\00E")
 (data $48 (i32.const 3036) "\1c")
 (data $48.1 (i32.const 3048) "\02\00\00\00\n\00\00\00M\00L\00I\00N\00K")
 (data $49 (i32.const 3068) ",")
 (data $49.1 (i32.const 3080) "\02\00\00\00\0e\00\00\00M\00S\00G\00S\00I\00Z\00E")
 (data $50 (i32.const 3116) ",")
 (data $50.1 (i32.const 3128) "\02\00\00\00\10\00\00\00M\00U\00L\00T\00I\00H\00O\00P")
 (data $51 (i32.const 3164) ",")
 (data $51.1 (i32.const 3176) "\02\00\00\00\16\00\00\00N\00A\00M\00E\00T\00O\00O\00L\00O\00N\00G")
 (data $52 (i32.const 3212) ",")
 (data $52.1 (i32.const 3224) "\02\00\00\00\0e\00\00\00N\00E\00T\00D\00O\00W\00N")
 (data $53 (i32.const 3260) ",")
 (data $53.1 (i32.const 3272) "\02\00\00\00\10\00\00\00N\00E\00T\00R\00E\00S\00E\00T")
 (data $54 (i32.const 3308) ",")
 (data $54.1 (i32.const 3320) "\02\00\00\00\14\00\00\00N\00E\00T\00U\00N\00R\00E\00A\00C\00H")
 (data $55 (i32.const 3356) "\1c")
 (data $55.1 (i32.const 3368) "\02\00\00\00\n\00\00\00N\00F\00I\00L\00E")
 (data $56 (i32.const 3388) "\1c")
 (data $56.1 (i32.const 3400) "\02\00\00\00\0c\00\00\00N\00O\00B\00U\00F\00S")
 (data $57 (i32.const 3420) "\1c")
 (data $57.1 (i32.const 3432) "\02\00\00\00\n\00\00\00N\00O\00D\00E\00V")
 (data $58 (i32.const 3452) "\1c")
 (data $58.1 (i32.const 3464) "\02\00\00\00\n\00\00\00N\00O\00E\00N\00T")
 (data $59 (i32.const 3484) "\1c")
 (data $59.1 (i32.const 3496) "\02\00\00\00\0c\00\00\00N\00O\00E\00X\00E\00C")
 (data $60 (i32.const 3516) "\1c")
 (data $60.1 (i32.const 3528) "\02\00\00\00\n\00\00\00N\00O\00L\00C\00K")
 (data $61 (i32.const 3548) "\1c")
 (data $61.1 (i32.const 3560) "\02\00\00\00\0c\00\00\00N\00O\00L\00I\00N\00K")
 (data $62 (i32.const 3580) "\1c")
 (data $62.1 (i32.const 3592) "\02\00\00\00\n\00\00\00N\00O\00M\00E\00M")
 (data $63 (i32.const 3612) "\1c")
 (data $63.1 (i32.const 3624) "\02\00\00\00\n\00\00\00N\00O\00M\00S\00G")
 (data $64 (i32.const 3644) ",")
 (data $64.1 (i32.const 3656) "\02\00\00\00\14\00\00\00N\00O\00P\00R\00O\00T\00O\00O\00P\00T")
 (data $65 (i32.const 3692) "\1c")
 (data $65.1 (i32.const 3704) "\02\00\00\00\n\00\00\00N\00O\00S\00P\00C")
 (data $66 (i32.const 3724) "\1c")
 (data $66.1 (i32.const 3736) "\02\00\00\00\n\00\00\00N\00O\00S\00Y\00S")
 (data $67 (i32.const 3756) ",")
 (data $67.1 (i32.const 3768) "\02\00\00\00\0e\00\00\00N\00O\00T\00C\00O\00N\00N")
 (data $68 (i32.const 3804) "\1c")
 (data $68.1 (i32.const 3816) "\02\00\00\00\0c\00\00\00N\00O\00T\00D\00I\00R")
 (data $69 (i32.const 3836) ",")
 (data $69.1 (i32.const 3848) "\02\00\00\00\10\00\00\00N\00O\00T\00E\00M\00P\00T\00Y")
 (data $70 (i32.const 3884) ",")
 (data $70.1 (i32.const 3896) "\02\00\00\00\1c\00\00\00N\00O\00T\00R\00E\00C\00O\00V\00E\00R\00A\00B\00L\00E")
 (data $71 (i32.const 3932) ",")
 (data $71.1 (i32.const 3944) "\02\00\00\00\0e\00\00\00N\00O\00T\00S\00O\00C\00K")
 (data $72 (i32.const 3980) "\1c")
 (data $72.1 (i32.const 3992) "\02\00\00\00\0c\00\00\00N\00O\00T\00S\00U\00P")
 (data $73 (i32.const 4012) "\1c")
 (data $73.1 (i32.const 4024) "\02\00\00\00\n\00\00\00N\00O\00T\00T\00Y")
 (data $74 (i32.const 4044) "\1c")
 (data $74.1 (i32.const 4056) "\02\00\00\00\08\00\00\00N\00X\00I\00O")
 (data $75 (i32.const 4076) ",")
 (data $75.1 (i32.const 4088) "\02\00\00\00\10\00\00\00O\00V\00E\00R\00F\00L\00O\00W")
 (data $76 (i32.const 4124) ",")
 (data $76.1 (i32.const 4136) "\02\00\00\00\12\00\00\00O\00W\00N\00E\00R\00D\00E\00A\00D")
 (data $77 (i32.const 4172) "\1c")
 (data $77.1 (i32.const 4184) "\02\00\00\00\08\00\00\00P\00E\00R\00M")
 (data $78 (i32.const 4204) "\1c")
 (data $78.1 (i32.const 4216) "\02\00\00\00\08\00\00\00P\00I\00P\00E")
 (data $79 (i32.const 4236) "\1c")
 (data $79.1 (i32.const 4248) "\02\00\00\00\n\00\00\00P\00R\00O\00T\00O")
 (data $80 (i32.const 4268) ",")
 (data $80.1 (i32.const 4280) "\02\00\00\00\1c\00\00\00P\00R\00O\00T\00O\00N\00O\00S\00U\00P\00P\00O\00R\00T")
 (data $81 (i32.const 4316) ",")
 (data $81.1 (i32.const 4328) "\02\00\00\00\12\00\00\00P\00R\00O\00T\00O\00T\00Y\00P\00E")
 (data $82 (i32.const 4364) "\1c")
 (data $82.1 (i32.const 4376) "\02\00\00\00\n\00\00\00R\00A\00N\00G\00E")
 (data $83 (i32.const 4396) "\1c")
 (data $83.1 (i32.const 4408) "\02\00\00\00\08\00\00\00R\00O\00F\00S")
 (data $84 (i32.const 4428) "\1c")
 (data $84.1 (i32.const 4440) "\02\00\00\00\n\00\00\00S\00P\00I\00P\00E")
 (data $85 (i32.const 4460) "\1c")
 (data $85.1 (i32.const 4472) "\02\00\00\00\08\00\00\00S\00R\00C\00H")
 (data $86 (i32.const 4492) "\1c")
 (data $86.1 (i32.const 4504) "\02\00\00\00\n\00\00\00S\00T\00A\00L\00E")
 (data $87 (i32.const 4524) ",")
 (data $87.1 (i32.const 4536) "\02\00\00\00\10\00\00\00T\00I\00M\00E\00D\00O\00U\00T")
 (data $88 (i32.const 4572) "\1c")
 (data $88.1 (i32.const 4584) "\02\00\00\00\0c\00\00\00T\00X\00T\00B\00S\00Y")
 (data $89 (i32.const 4604) "\1c")
 (data $89.1 (i32.const 4616) "\02\00\00\00\08\00\00\00X\00D\00E\00V")
 (data $90 (i32.const 4636) ",")
 (data $90.1 (i32.const 4648) "\02\00\00\00\14\00\00\00N\00O\00T\00C\00A\00P\00A\00B\00L\00E")
 (data $91 (i32.const 4684) ",")
 (data $91.1 (i32.const 4696) "\02\00\00\00\0e\00\00\00U\00N\00K\00N\00O\00W\00N")
 (data $92 (i32.const 4732) "<")
 (data $92.1 (i32.const 4744) "\02\00\00\00 \00\00\00~\00l\00i\00b\00/\00d\00a\00t\00a\00v\00i\00e\00w\00.\00t\00s")
 (data $93 (i32.const 4796) "<")
 (data $93.1 (i32.const 4808) "\02\00\00\00$\00\00\00~\00l\00i\00b\00/\00t\00y\00p\00e\00d\00a\00r\00r\00a\00y\00.\00t\00s")
 (data $94 (i32.const 4864) "\06\00\00\00 \00\00\00 \00\00\00 ")
 (data $94.1 (i32.const 4888) "A")
 (export "main" (func $nm_assemblyscript/main))
 (export "memory" (memory $0))
 (export "_start" (func $~start))
 (func $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf (param $0 i32) (param $1 i32)
  local.get $0
  local.get $1
  i32.store
 )
 (func $~lib/string/String#get:length (param $0 i32) (result i32)
  local.get $0
  i32.const 20
  i32.sub
  i32.load offset=16
  i32.const 1
  i32.shr_u
 )
 (func $~lib/string/String.UTF8.encodeUnsafe (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  local.get $0
  local.get $1
  i32.const 1
  i32.shl
  i32.add
  local.set $3
  local.get $2
  local.set $1
  loop $while-continue|0
   local.get $0
   local.get $3
   i32.lt_u
   if
    local.get $0
    i32.load16_u
    local.tee $4
    i32.const 128
    i32.lt_u
    if (result i32)
     local.get $1
     local.get $4
     i32.store8
     local.get $1
     i32.const 1
     i32.add
    else
     local.get $4
     i32.const 2048
     i32.lt_u
     if (result i32)
      local.get $1
      local.get $4
      i32.const 6
      i32.shr_u
      i32.const 192
      i32.or
      local.get $4
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.const 8
      i32.shl
      i32.or
      i32.store16
      local.get $1
      i32.const 2
      i32.add
     else
      local.get $4
      i32.const 56320
      i32.lt_u
      local.get $0
      i32.const 2
      i32.add
      local.get $3
      i32.lt_u
      i32.and
      local.get $4
      i32.const 63488
      i32.and
      i32.const 55296
      i32.eq
      i32.and
      if
       local.get $0
       i32.load16_u offset=2
       local.tee $5
       i32.const 64512
       i32.and
       i32.const 56320
       i32.eq
       if
        local.get $1
        local.get $4
        i32.const 1023
        i32.and
        i32.const 10
        i32.shl
        i32.const 65536
        i32.add
        local.get $5
        i32.const 1023
        i32.and
        i32.or
        local.tee $4
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.const 24
        i32.shl
        local.get $4
        i32.const 6
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.const 16
        i32.shl
        i32.or
        local.get $4
        i32.const 12
        i32.shr_u
        i32.const 63
        i32.and
        i32.const 128
        i32.or
        i32.const 8
        i32.shl
        i32.or
        local.get $4
        i32.const 18
        i32.shr_u
        i32.const 240
        i32.or
        i32.or
        i32.store
        local.get $1
        i32.const 4
        i32.add
        local.set $1
        local.get $0
        i32.const 4
        i32.add
        local.set $0
        br $while-continue|0
       end
      end
      local.get $1
      local.get $4
      i32.const 12
      i32.shr_u
      i32.const 224
      i32.or
      local.get $4
      i32.const 6
      i32.shr_u
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.const 8
      i32.shl
      i32.or
      i32.store16
      local.get $1
      local.get $4
      i32.const 63
      i32.and
      i32.const 128
      i32.or
      i32.store8 offset=2
      local.get $1
      i32.const 3
      i32.add
     end
    end
    local.set $1
    local.get $0
    i32.const 2
    i32.add
    local.set $0
    br $while-continue|0
   end
  end
  local.get $1
  local.get $2
  i32.sub
 )
 (func $~lib/string/String.UTF8.encodeUnsafe@varargs (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  block $2of2
   block $outOfRange
    global.get $~argumentsLength
    i32.const 3
    i32.sub
    br_table $2of2 $2of2 $2of2 $outOfRange
   end
   unreachable
  end
  local.get $0
  local.get $1
  local.get $2
  call $~lib/string/String.UTF8.encodeUnsafe
 )
 (func $~lib/util/number/decimalCount32 (param $0 i32) (result i32)
  local.get $0
  i32.const 10
  i32.ge_u
  i32.const 1
  i32.add
  local.get $0
  i32.const 10000
  i32.ge_u
  i32.const 3
  i32.add
  local.get $0
  i32.const 1000
  i32.ge_u
  i32.add
  local.get $0
  i32.const 100
  i32.lt_u
  select
  local.get $0
  i32.const 1000000
  i32.ge_u
  i32.const 6
  i32.add
  local.get $0
  i32.const 1000000000
  i32.ge_u
  i32.const 8
  i32.add
  local.get $0
  i32.const 100000000
  i32.ge_u
  i32.add
  local.get $0
  i32.const 10000000
  i32.lt_u
  select
  local.get $0
  i32.const 100000
  i32.lt_u
  select
 )
 (func $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len (param $0 i32) (param $1 i32)
  local.get $0
  local.get $1
  i32.store offset=4
 )
 (func $~lib/rt/itcms/Object#set:prev (param $0 i32) (param $1 i32)
  local.get $0
  local.get $1
  i32.store offset=8
 )
 (func $~lib/rt/itcms/initLazy (param $0 i32) (result i32)
  local.get $0
  local.get $0
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  local.get $0
  local.get $0
  call $~lib/rt/itcms/Object#set:prev
  local.get $0
 )
 (func $~lib/rt/itcms/Object#get:next (param $0 i32) (result i32)
  local.get $0
  i32.load offset=4
  i32.const -4
  i32.and
 )
 (func $~lib/rt/itcms/Object#get:color (param $0 i32) (result i32)
  local.get $0
  i32.load offset=4
  i32.const 3
  i32.and
 )
 (func $~lib/rt/itcms/visitRoots
  (local $0 i32)
  (local $1 i32)
  i32.const 1472
  call $~lib/rt/itcms/__visit
  i32.const 1168
  call $~lib/rt/itcms/__visit
  i32.const 1280
  call $~lib/rt/itcms/__visit
  i32.const 1056
  call $~lib/rt/itcms/__visit
  global.get $~lib/rt/itcms/pinSpace
  local.tee $1
  call $~lib/rt/itcms/Object#get:next
  local.set $0
  loop $while-continue|0
   local.get $0
   local.get $1
   i32.ne
   if
    local.get $0
    call $~lib/rt/itcms/Object#get:color
    i32.const 3
    i32.ne
    if
     i32.const 0
     i32.const 1344
     i32.const 160
     i32.const 16
     call $~lib/wasi_internal/wasi_abort
     unreachable
    end
    local.get $0
    i32.const 20
    i32.add
    call $~lib/rt/__visit_members
    local.get $0
    call $~lib/rt/itcms/Object#get:next
    local.set $0
    br $while-continue|0
   end
  end
 )
 (func $~lib/rt/itcms/Object#set:color (param $0 i32) (param $1 i32)
  local.get $0
  local.get $0
  i32.load offset=4
  i32.const -4
  i32.and
  local.get $1
  i32.or
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
 )
 (func $~lib/rt/itcms/Object#set:next (param $0 i32) (param $1 i32)
  local.get $0
  local.get $1
  local.get $0
  i32.load offset=4
  i32.const 3
  i32.and
  i32.or
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
 )
 (func $~lib/rt/itcms/Object#linkTo (param $0 i32) (param $1 i32) (param $2 i32)
  (local $3 i32)
  local.get $1
  i32.load offset=8
  local.set $3
  local.get $0
  local.get $1
  local.get $2
  i32.or
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  local.get $0
  local.get $3
  call $~lib/rt/itcms/Object#set:prev
  local.get $3
  local.get $0
  call $~lib/rt/itcms/Object#set:next
  local.get $1
  local.get $0
  call $~lib/rt/itcms/Object#set:prev
 )
 (func $~lib/rt/itcms/Object#makeGray (param $0 i32)
  (local $1 i32)
  (local $2 i32)
  local.get $0
  global.get $~lib/rt/itcms/iter
  i32.eq
  if
   local.get $0
   i32.load offset=8
   local.tee $1
   i32.eqz
   if
    i32.const 0
    i32.const 1344
    i32.const 148
    i32.const 30
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
   local.get $1
   global.set $~lib/rt/itcms/iter
  end
  block $__inlined_func$~lib/rt/itcms/Object#unlink$64
   local.get $0
   call $~lib/rt/itcms/Object#get:next
   local.tee $1
   i32.eqz
   if
    local.get $0
    i32.load offset=8
    i32.eqz
    local.get $0
    i32.const 37660
    i32.lt_u
    i32.and
    i32.eqz
    if
     i32.const 0
     i32.const 1344
     i32.const 128
     i32.const 18
     call $~lib/wasi_internal/wasi_abort
     unreachable
    end
    br $__inlined_func$~lib/rt/itcms/Object#unlink$64
   end
   local.get $0
   i32.load offset=8
   local.tee $2
   i32.eqz
   if
    i32.const 0
    i32.const 1344
    i32.const 132
    i32.const 16
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
   local.get $1
   local.get $2
   call $~lib/rt/itcms/Object#set:prev
   local.get $2
   local.get $1
   call $~lib/rt/itcms/Object#set:next
  end
  global.get $~lib/rt/itcms/toSpace
  local.set $1
  local.get $0
  i32.load offset=12
  local.tee $2
  i32.const 2
  i32.le_u
  if (result i32)
   i32.const 1
  else
   local.get $2
   i32.const 4864
   i32.load
   i32.gt_u
   if
    i32.const 1472
    i32.const 1536
    i32.const 21
    i32.const 28
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
   local.get $2
   i32.const 2
   i32.shl
   i32.const 4868
   i32.add
   i32.load
   i32.const 32
   i32.and
  end
  local.set $2
  local.get $0
  local.get $1
  global.get $~lib/rt/itcms/white
  i32.eqz
  i32.const 2
  local.get $2
  select
  call $~lib/rt/itcms/Object#linkTo
 )
 (func $~lib/rt/itcms/__visit (param $0 i32)
  local.get $0
  i32.eqz
  if
   return
  end
  local.get $0
  i32.const 20
  i32.sub
  local.tee $0
  call $~lib/rt/itcms/Object#get:color
  global.get $~lib/rt/itcms/white
  i32.eq
  if
   local.get $0
   call $~lib/rt/itcms/Object#makeGray
   global.get $~lib/rt/itcms/visitCount
   i32.const 1
   i32.add
   global.set $~lib/rt/itcms/visitCount
  end
 )
 (func $~lib/rt/itcms/Object#get:size (param $0 i32) (result i32)
  local.get $0
  i32.load
  i32.const -4
  i32.and
  i32.const 4
  i32.add
 )
 (func $~lib/rt/tlsf/removeBlock (param $0 i32) (param $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  local.get $1
  i32.load
  local.tee $3
  i32.const 1
  i32.and
  i32.eqz
  if
   i32.const 0
   i32.const 1616
   i32.const 268
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $3
  i32.const -4
  i32.and
  local.tee $3
  i32.const 12
  i32.lt_u
  if
   i32.const 0
   i32.const 1616
   i32.const 270
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $3
  i32.const 256
  i32.lt_u
  if (result i32)
   local.get $3
   i32.const 4
   i32.shr_u
  else
   i32.const 31
   i32.const 1073741820
   local.get $3
   local.get $3
   i32.const 1073741820
   i32.ge_u
   select
   local.tee $3
   i32.clz
   i32.sub
   local.tee $4
   i32.const 7
   i32.sub
   local.set $2
   local.get $3
   local.get $4
   i32.const 4
   i32.sub
   i32.shr_u
   i32.const 16
   i32.xor
  end
  local.tee $3
  i32.const 16
  i32.lt_u
  local.get $2
  i32.const 23
  i32.lt_u
  i32.and
  i32.eqz
  if
   i32.const 0
   i32.const 1616
   i32.const 284
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $1
  i32.load offset=8
  local.set $5
  local.get $1
  i32.load offset=4
  local.tee $4
  if
   local.get $4
   local.get $5
   call $~lib/rt/itcms/Object#set:prev
  end
  local.get $5
  if
   local.get $5
   local.get $4
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  end
  local.get $1
  local.get $0
  local.get $2
  i32.const 4
  i32.shl
  local.get $3
  i32.add
  i32.const 2
  i32.shl
  i32.add
  local.tee $1
  i32.load offset=96
  i32.eq
  if
   local.get $1
   local.get $5
   i32.store offset=96
   local.get $5
   i32.eqz
   if
    local.get $0
    local.get $2
    i32.const 2
    i32.shl
    i32.add
    local.tee $1
    i32.load offset=4
    i32.const -2
    local.get $3
    i32.rotl
    i32.and
    local.set $3
    local.get $1
    local.get $3
    i32.store offset=4
    local.get $3
    i32.eqz
    if
     local.get $0
     local.get $0
     i32.load
     i32.const -2
     local.get $2
     i32.rotl
     i32.and
     call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
    end
   end
  end
 )
 (func $~lib/rt/tlsf/insertBlock (param $0 i32) (param $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  local.get $1
  i32.eqz
  if
   i32.const 0
   i32.const 1616
   i32.const 201
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $1
  i32.load
  local.tee $3
  i32.const 1
  i32.and
  i32.eqz
  if
   i32.const 0
   i32.const 1616
   i32.const 203
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $1
  i32.const 4
  i32.add
  local.get $1
  i32.load
  i32.const -4
  i32.and
  i32.add
  local.tee $4
  i32.load
  local.tee $2
  i32.const 1
  i32.and
  if
   local.get $0
   local.get $4
   call $~lib/rt/tlsf/removeBlock
   local.get $1
   local.get $3
   i32.const 4
   i32.add
   local.get $2
   i32.const -4
   i32.and
   i32.add
   local.tee $3
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
   local.get $1
   i32.const 4
   i32.add
   local.get $1
   i32.load
   i32.const -4
   i32.and
   i32.add
   local.tee $4
   i32.load
   local.set $2
  end
  local.get $3
  i32.const 2
  i32.and
  if
   local.get $1
   i32.const 4
   i32.sub
   i32.load
   local.tee $1
   i32.load
   local.tee $6
   i32.const 1
   i32.and
   i32.eqz
   if
    i32.const 0
    i32.const 1616
    i32.const 221
    i32.const 16
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
   local.get $0
   local.get $1
   call $~lib/rt/tlsf/removeBlock
   local.get $1
   local.get $6
   i32.const 4
   i32.add
   local.get $3
   i32.const -4
   i32.and
   i32.add
   local.tee $3
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  end
  local.get $4
  local.get $2
  i32.const 2
  i32.or
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  local.get $3
  i32.const -4
  i32.and
  local.tee $2
  i32.const 12
  i32.lt_u
  if
   i32.const 0
   i32.const 1616
   i32.const 233
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $4
  local.get $1
  i32.const 4
  i32.add
  local.get $2
  i32.add
  i32.ne
  if
   i32.const 0
   i32.const 1616
   i32.const 234
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $4
  i32.const 4
  i32.sub
  local.get $1
  i32.store
  local.get $2
  i32.const 256
  i32.lt_u
  if (result i32)
   local.get $2
   i32.const 4
   i32.shr_u
  else
   i32.const 31
   i32.const 1073741820
   local.get $2
   local.get $2
   i32.const 1073741820
   i32.ge_u
   select
   local.tee $2
   i32.clz
   i32.sub
   local.tee $3
   i32.const 7
   i32.sub
   local.set $5
   local.get $2
   local.get $3
   i32.const 4
   i32.sub
   i32.shr_u
   i32.const 16
   i32.xor
  end
  local.tee $2
  i32.const 16
  i32.lt_u
  local.get $5
  i32.const 23
  i32.lt_u
  i32.and
  i32.eqz
  if
   i32.const 0
   i32.const 1616
   i32.const 251
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $0
  local.get $5
  i32.const 4
  i32.shl
  local.get $2
  i32.add
  i32.const 2
  i32.shl
  i32.add
  i32.load offset=96
  local.set $3
  local.get $1
  i32.const 0
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  local.get $1
  local.get $3
  call $~lib/rt/itcms/Object#set:prev
  local.get $3
  if
   local.get $3
   local.get $1
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  end
  local.get $0
  local.get $5
  i32.const 4
  i32.shl
  local.get $2
  i32.add
  i32.const 2
  i32.shl
  i32.add
  local.get $1
  i32.store offset=96
  local.get $0
  local.get $0
  i32.load
  i32.const 1
  local.get $5
  i32.shl
  i32.or
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  local.get $0
  local.get $5
  i32.const 2
  i32.shl
  i32.add
  local.tee $0
  local.get $0
  i32.load offset=4
  i32.const 1
  local.get $2
  i32.shl
  i32.or
  i32.store offset=4
 )
 (func $~lib/rt/tlsf/addMemory (param $0 i32) (param $1 i32) (param $2 i64)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  local.get $2
  local.get $1
  i64.extend_i32_u
  i64.lt_u
  if
   i32.const 0
   i32.const 1616
   i32.const 382
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $1
  i32.const 19
  i32.add
  i32.const -16
  i32.and
  i32.const 4
  i32.sub
  local.set $1
  local.get $0
  i32.load offset=1568
  local.tee $3
  if
   local.get $3
   i32.const 4
   i32.add
   local.get $1
   i32.gt_u
   if
    i32.const 0
    i32.const 1616
    i32.const 389
    i32.const 16
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
   local.get $3
   local.get $1
   i32.const 16
   i32.sub
   local.tee $5
   i32.eq
   if
    local.get $3
    i32.load
    local.set $4
    local.get $5
    local.set $1
   end
  else
   local.get $0
   i32.const 1572
   i32.add
   local.get $1
   i32.gt_u
   if
    i32.const 0
    i32.const 1616
    i32.const 402
    i32.const 5
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
  end
  local.get $2
  i32.wrap_i64
  i32.const -16
  i32.and
  local.get $1
  i32.sub
  local.tee $3
  i32.const 20
  i32.lt_u
  if
   return
  end
  local.get $1
  local.get $4
  i32.const 2
  i32.and
  local.get $3
  i32.const 8
  i32.sub
  local.tee $3
  i32.const 1
  i32.or
  i32.or
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  local.get $1
  i32.const 0
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  local.get $1
  i32.const 0
  call $~lib/rt/itcms/Object#set:prev
  local.get $1
  i32.const 4
  i32.add
  local.get $3
  i32.add
  local.tee $3
  i32.const 2
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  local.get $0
  local.get $3
  i32.store offset=1568
  local.get $0
  local.get $1
  call $~lib/rt/tlsf/insertBlock
 )
 (func $~lib/rt/tlsf/initialize
  (local $0 i32)
  (local $1 i32)
  memory.size
  local.tee $1
  i32.const 0
  i32.le_s
  if (result i32)
   i32.const 1
   local.get $1
   i32.sub
   memory.grow
   i32.const 0
   i32.lt_s
  else
   i32.const 0
  end
  if
   unreachable
  end
  i32.const 37664
  i32.const 0
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  i32.const 39232
  i32.const 0
  i32.store
  loop $for-loop|0
   local.get $0
   i32.const 23
   i32.lt_u
   if
    local.get $0
    i32.const 2
    i32.shl
    i32.const 37664
    i32.add
    i32.const 0
    i32.store offset=4
    i32.const 0
    local.set $1
    loop $for-loop|1
     local.get $1
     i32.const 16
     i32.lt_u
     if
      local.get $0
      i32.const 4
      i32.shl
      local.get $1
      i32.add
      i32.const 2
      i32.shl
      i32.const 37664
      i32.add
      i32.const 0
      i32.store offset=96
      local.get $1
      i32.const 1
      i32.add
      local.set $1
      br $for-loop|1
     end
    end
    local.get $0
    i32.const 1
    i32.add
    local.set $0
    br $for-loop|0
   end
  end
  i32.const 37664
  i32.const 39236
  memory.size
  i64.extend_i32_s
  i64.const 16
  i64.shl
  call $~lib/rt/tlsf/addMemory
  i32.const 37664
  global.set $~lib/rt/tlsf/ROOT
 )
 (func $~lib/rt/itcms/step (result i32)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  block $break|0
   block $case2|0
    block $case1|0
     block $case0|0
      global.get $~lib/rt/itcms/state
      br_table $case0|0 $case1|0 $case2|0 $break|0
     end
     i32.const 1
     global.set $~lib/rt/itcms/state
     i32.const 0
     global.set $~lib/rt/itcms/visitCount
     call $~lib/rt/itcms/visitRoots
     global.get $~lib/rt/itcms/toSpace
     global.set $~lib/rt/itcms/iter
     global.get $~lib/rt/itcms/visitCount
     return
    end
    global.get $~lib/rt/itcms/white
    i32.eqz
    local.set $1
    global.get $~lib/rt/itcms/iter
    call $~lib/rt/itcms/Object#get:next
    local.set $0
    loop $while-continue|1
     local.get $0
     global.get $~lib/rt/itcms/toSpace
     i32.ne
     if
      local.get $0
      global.set $~lib/rt/itcms/iter
      local.get $0
      call $~lib/rt/itcms/Object#get:color
      local.get $1
      i32.ne
      if
       local.get $0
       local.get $1
       call $~lib/rt/itcms/Object#set:color
       i32.const 0
       global.set $~lib/rt/itcms/visitCount
       local.get $0
       i32.const 20
       i32.add
       call $~lib/rt/__visit_members
       global.get $~lib/rt/itcms/visitCount
       return
      end
      local.get $0
      call $~lib/rt/itcms/Object#get:next
      local.set $0
      br $while-continue|1
     end
    end
    i32.const 0
    global.set $~lib/rt/itcms/visitCount
    call $~lib/rt/itcms/visitRoots
    global.get $~lib/rt/itcms/iter
    call $~lib/rt/itcms/Object#get:next
    global.get $~lib/rt/itcms/toSpace
    i32.eq
    if
     global.get $~lib/memory/__stack_pointer
     local.set $0
     loop $while-continue|0
      local.get $0
      i32.const 37660
      i32.lt_u
      if
       local.get $0
       i32.load
       call $~lib/rt/itcms/__visit
       local.get $0
       i32.const 4
       i32.add
       local.set $0
       br $while-continue|0
      end
     end
     global.get $~lib/rt/itcms/iter
     call $~lib/rt/itcms/Object#get:next
     local.set $0
     loop $while-continue|2
      local.get $0
      global.get $~lib/rt/itcms/toSpace
      i32.ne
      if
       local.get $0
       call $~lib/rt/itcms/Object#get:color
       local.get $1
       i32.ne
       if
        local.get $0
        local.get $1
        call $~lib/rt/itcms/Object#set:color
        local.get $0
        i32.const 20
        i32.add
        call $~lib/rt/__visit_members
       end
       local.get $0
       call $~lib/rt/itcms/Object#get:next
       local.set $0
       br $while-continue|2
      end
     end
     global.get $~lib/rt/itcms/fromSpace
     local.set $0
     global.get $~lib/rt/itcms/toSpace
     global.set $~lib/rt/itcms/fromSpace
     local.get $0
     global.set $~lib/rt/itcms/toSpace
     local.get $1
     global.set $~lib/rt/itcms/white
     local.get $0
     call $~lib/rt/itcms/Object#get:next
     global.set $~lib/rt/itcms/iter
     i32.const 2
     global.set $~lib/rt/itcms/state
    end
    global.get $~lib/rt/itcms/visitCount
    return
   end
   global.get $~lib/rt/itcms/iter
   local.tee $0
   global.get $~lib/rt/itcms/toSpace
   i32.ne
   if
    local.get $0
    call $~lib/rt/itcms/Object#get:next
    global.set $~lib/rt/itcms/iter
    local.get $0
    call $~lib/rt/itcms/Object#get:color
    global.get $~lib/rt/itcms/white
    i32.eqz
    i32.ne
    if
     i32.const 0
     i32.const 1344
     i32.const 229
     i32.const 20
     call $~lib/wasi_internal/wasi_abort
     unreachable
    end
    local.get $0
    i32.const 37660
    i32.lt_u
    if
     local.get $0
     i32.const 0
     call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
     local.get $0
     i32.const 0
     call $~lib/rt/itcms/Object#set:prev
    else
     global.get $~lib/rt/itcms/total
     local.get $0
     call $~lib/rt/itcms/Object#get:size
     i32.sub
     global.set $~lib/rt/itcms/total
     local.get $0
     i32.const 4
     i32.add
     local.tee $1
     i32.const 37660
     i32.ge_u
     if
      global.get $~lib/rt/tlsf/ROOT
      i32.eqz
      if
       call $~lib/rt/tlsf/initialize
      end
      global.get $~lib/rt/tlsf/ROOT
      local.get $1
      i32.const 4
      i32.sub
      local.set $0
      local.get $1
      i32.const 15
      i32.and
      i32.const 1
      local.get $1
      select
      if (result i32)
       i32.const 1
      else
       local.get $0
       i32.load
       i32.const 1
       i32.and
      end
      if
       i32.const 0
       i32.const 1616
       i32.const 562
       i32.const 3
       call $~lib/wasi_internal/wasi_abort
       unreachable
      end
      local.get $0
      local.get $0
      i32.load
      i32.const 1
      i32.or
      call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
      local.get $0
      call $~lib/rt/tlsf/insertBlock
     end
    end
    i32.const 10
    return
   end
   global.get $~lib/rt/itcms/toSpace
   global.get $~lib/rt/itcms/toSpace
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
   global.get $~lib/rt/itcms/toSpace
   global.get $~lib/rt/itcms/toSpace
   call $~lib/rt/itcms/Object#set:prev
   i32.const 0
   global.set $~lib/rt/itcms/state
  end
  i32.const 0
 )
 (func $~lib/rt/tlsf/roundSize (param $0 i32) (result i32)
  local.get $0
  i32.const 1
  i32.const 27
  local.get $0
  i32.clz
  i32.sub
  i32.shl
  i32.add
  i32.const 1
  i32.sub
  local.get $0
  local.get $0
  i32.const 536870910
  i32.lt_u
  select
 )
 (func $~lib/rt/tlsf/searchBlock (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  local.get $1
  i32.const 256
  i32.lt_u
  if (result i32)
   local.get $1
   i32.const 4
   i32.shr_u
  else
   i32.const 31
   local.get $1
   call $~lib/rt/tlsf/roundSize
   local.tee $1
   i32.clz
   i32.sub
   local.tee $3
   i32.const 7
   i32.sub
   local.set $2
   local.get $1
   local.get $3
   i32.const 4
   i32.sub
   i32.shr_u
   i32.const 16
   i32.xor
  end
  local.tee $1
  i32.const 16
  i32.lt_u
  local.get $2
  i32.const 23
  i32.lt_u
  i32.and
  i32.eqz
  if
   i32.const 0
   i32.const 1616
   i32.const 334
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $0
  local.get $2
  i32.const 2
  i32.shl
  i32.add
  i32.load offset=4
  i32.const -1
  local.get $1
  i32.shl
  i32.and
  local.tee $1
  if (result i32)
   local.get $0
   local.get $1
   i32.ctz
   local.get $2
   i32.const 4
   i32.shl
   i32.add
   i32.const 2
   i32.shl
   i32.add
   i32.load offset=96
  else
   local.get $0
   i32.load
   i32.const -1
   local.get $2
   i32.const 1
   i32.add
   i32.shl
   i32.and
   local.tee $1
   if (result i32)
    local.get $0
    local.get $1
    i32.ctz
    local.tee $1
    i32.const 2
    i32.shl
    i32.add
    i32.load offset=4
    local.tee $2
    i32.eqz
    if
     i32.const 0
     i32.const 1616
     i32.const 347
     i32.const 18
     call $~lib/wasi_internal/wasi_abort
     unreachable
    end
    local.get $0
    local.get $2
    i32.ctz
    local.get $1
    i32.const 4
    i32.shl
    i32.add
    i32.const 2
    i32.shl
    i32.add
    i32.load offset=96
   else
    i32.const 0
   end
  end
 )
 (func $~lib/rt/tlsf/allocateBlock (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  local.get $1
  i32.const 1073741820
  i32.gt_u
  if
   i32.const 1280
   i32.const 1616
   i32.const 461
   i32.const 29
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $0
  i32.const 12
  local.get $1
  i32.const 19
  i32.add
  i32.const -16
  i32.and
  i32.const 4
  i32.sub
  local.get $1
  i32.const 12
  i32.le_u
  select
  local.tee $1
  call $~lib/rt/tlsf/searchBlock
  local.tee $2
  i32.eqz
  if
   local.get $1
   i32.const 256
   i32.ge_u
   if (result i32)
    local.get $1
    call $~lib/rt/tlsf/roundSize
   else
    local.get $1
   end
   local.set $2
   memory.size
   local.tee $3
   local.get $2
   i32.const 4
   local.get $0
   i32.load offset=1568
   local.get $3
   i32.const 16
   i32.shl
   i32.const 4
   i32.sub
   i32.ne
   i32.shl
   i32.add
   i32.const 65535
   i32.add
   i32.const -65536
   i32.and
   i32.const 16
   i32.shr_u
   local.tee $2
   local.get $2
   local.get $3
   i32.lt_s
   select
   memory.grow
   i32.const 0
   i32.lt_s
   if
    local.get $2
    memory.grow
    i32.const 0
    i32.lt_s
    if
     unreachable
    end
   end
   local.get $0
   local.get $3
   i32.const 16
   i32.shl
   memory.size
   i64.extend_i32_s
   i64.const 16
   i64.shl
   call $~lib/rt/tlsf/addMemory
   local.get $0
   local.get $1
   call $~lib/rt/tlsf/searchBlock
   local.tee $2
   i32.eqz
   if
    i32.const 0
    i32.const 1616
    i32.const 499
    i32.const 16
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
  end
  local.get $1
  local.get $2
  i32.load
  i32.const -4
  i32.and
  i32.gt_u
  if
   i32.const 0
   i32.const 1616
   i32.const 501
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $0
  local.get $2
  call $~lib/rt/tlsf/removeBlock
  local.get $2
  i32.load
  local.set $4
  local.get $1
  i32.const 4
  i32.add
  i32.const 15
  i32.and
  if
   i32.const 0
   i32.const 1616
   i32.const 361
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $4
  i32.const -4
  i32.and
  local.get $1
  i32.sub
  local.tee $3
  i32.const 16
  i32.ge_u
  if
   local.get $2
   local.get $1
   local.get $4
   i32.const 2
   i32.and
   i32.or
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
   local.get $2
   i32.const 4
   i32.add
   local.get $1
   i32.add
   local.tee $1
   local.get $3
   i32.const 4
   i32.sub
   i32.const 1
   i32.or
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
   local.get $0
   local.get $1
   call $~lib/rt/tlsf/insertBlock
  else
   local.get $2
   local.get $4
   i32.const -2
   i32.and
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
   local.get $2
   i32.const 4
   i32.add
   local.get $2
   i32.load
   i32.const -4
   i32.and
   i32.add
   local.tee $0
   local.get $0
   i32.load
   i32.const -3
   i32.and
   call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  end
  local.get $2
 )
 (func $~lib/rt/itcms/__new (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  local.get $0
  i32.const 1073741804
  i32.ge_u
  if
   i32.const 1280
   i32.const 1344
   i32.const 261
   i32.const 31
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  global.get $~lib/rt/itcms/total
  global.get $~lib/rt/itcms/threshold
  i32.ge_u
  if
   block $__inlined_func$~lib/rt/itcms/interrupt$37
    i32.const 2048
    local.set $2
    loop $do-loop|0
     local.get $2
     call $~lib/rt/itcms/step
     i32.sub
     local.set $2
     global.get $~lib/rt/itcms/state
     i32.eqz
     if
      global.get $~lib/rt/itcms/total
      i64.extend_i32_u
      i64.const 200
      i64.mul
      i64.const 100
      i64.div_u
      i32.wrap_i64
      i32.const 1024
      i32.add
      global.set $~lib/rt/itcms/threshold
      br $__inlined_func$~lib/rt/itcms/interrupt$37
     end
     local.get $2
     i32.const 0
     i32.gt_s
     br_if $do-loop|0
    end
    global.get $~lib/rt/itcms/total
    global.get $~lib/rt/itcms/total
    global.get $~lib/rt/itcms/threshold
    i32.sub
    i32.const 1024
    i32.lt_u
    i32.const 10
    i32.shl
    i32.add
    global.set $~lib/rt/itcms/threshold
   end
  end
  global.get $~lib/rt/tlsf/ROOT
  i32.eqz
  if
   call $~lib/rt/tlsf/initialize
  end
  global.get $~lib/rt/tlsf/ROOT
  local.get $0
  i32.const 16
  i32.add
  call $~lib/rt/tlsf/allocateBlock
  local.tee $2
  local.get $1
  i32.store offset=12
  local.get $2
  local.get $0
  i32.store offset=16
  local.get $2
  global.get $~lib/rt/itcms/fromSpace
  global.get $~lib/rt/itcms/white
  call $~lib/rt/itcms/Object#linkTo
  global.get $~lib/rt/itcms/total
  local.get $2
  call $~lib/rt/itcms/Object#get:size
  i32.add
  global.set $~lib/rt/itcms/total
  local.get $2
  i32.const 20
  i32.add
  local.tee $1
  i32.const 0
  local.get $0
  memory.fill
  local.get $1
 )
 (func $~lib/arraybuffer/ArrayBuffer#get:byteLength (param $0 i32) (result i32)
  local.get $0
  i32.const 20
  i32.sub
  i32.load offset=16
 )
 (func $~lib/bindings/wasi_snapshot_preview1/errnoToString (param $0 i32) (result i32)
  block $break|0
   block $case76|0
    block $case75|0
     block $case74|0
      block $case73|0
       block $case72|0
        block $case71|0
         block $case70|0
          block $case69|0
           block $case68|0
            block $case67|0
             block $case66|0
              block $case65|0
               block $case64|0
                block $case63|0
                 block $case62|0
                  block $case61|0
                   block $case60|0
                    block $case59|0
                     block $case58|0
                      block $case57|0
                       block $case56|0
                        block $case55|0
                         block $case54|0
                          block $case53|0
                           block $case52|0
                            block $case51|0
                             block $case50|0
                              block $case49|0
                               block $case48|0
                                block $case47|0
                                 block $case46|0
                                  block $case45|0
                                   block $case44|0
                                    block $case43|0
                                     block $case42|0
                                      block $case41|0
                                       block $case40|0
                                        block $case39|0
                                         block $case38|0
                                          block $case37|0
                                           block $case36|0
                                            block $case35|0
                                             block $case34|0
                                              block $case33|0
                                               block $case32|0
                                                block $case31|0
                                                 block $case30|0
                                                  block $case29|0
                                                   block $case28|0
                                                    block $case27|0
                                                     block $case26|0
                                                      block $case25|0
                                                       block $case24|0
                                                        block $case23|0
                                                         block $case22|0
                                                          block $case21|0
                                                           block $case20|0
                                                            block $case19|0
                                                             block $case18|0
                                                              block $case17|0
                                                               block $case16|0
                                                                block $case15|0
                                                                 block $case14|0
                                                                  block $case13|0
                                                                   block $case12|0
                                                                    block $case11|0
                                                                     block $case10|0
                                                                      block $case9|0
                                                                       block $case8|0
                                                                        block $case7|0
                                                                         block $case6|0
                                                                          block $case5|0
                                                                           block $case4|0
                                                                            block $case3|0
                                                                             block $case2|0
                                                                              block $case1|0
                                                                               block $case0|0
                                                                                local.get $0
                                                                                i32.const 65535
                                                                                i32.and
                                                                                br_table $case0|0 $case1|0 $case2|0 $case3|0 $case4|0 $case5|0 $case6|0 $case7|0 $case8|0 $case9|0 $case10|0 $case11|0 $case12|0 $case13|0 $case14|0 $case15|0 $case16|0 $case17|0 $case18|0 $case19|0 $case20|0 $case21|0 $case22|0 $case23|0 $case24|0 $case25|0 $case26|0 $case27|0 $case28|0 $case29|0 $case30|0 $case31|0 $case32|0 $case33|0 $case34|0 $case35|0 $case36|0 $case37|0 $case38|0 $case39|0 $case40|0 $case41|0 $case42|0 $case43|0 $case44|0 $case45|0 $case46|0 $case47|0 $case48|0 $case49|0 $case50|0 $case51|0 $case52|0 $case53|0 $case54|0 $case55|0 $case56|0 $case57|0 $case58|0 $case59|0 $case60|0 $case61|0 $case62|0 $case63|0 $case64|0 $case65|0 $case66|0 $case67|0 $case68|0 $case69|0 $case70|0 $case71|0 $case72|0 $case73|0 $case74|0 $case75|0 $case76|0 $break|0
                                                                               end
                                                                               i32.const 1776
                                                                               return
                                                                              end
                                                                              i32.const 1824
                                                                              return
                                                                             end
                                                                             i32.const 1856
                                                                             return
                                                                            end
                                                                            i32.const 1888
                                                                            return
                                                                           end
                                                                           i32.const 1936
                                                                           return
                                                                          end
                                                                          i32.const 1984
                                                                          return
                                                                         end
                                                                         i32.const 2032
                                                                         return
                                                                        end
                                                                        i32.const 2064
                                                                        return
                                                                       end
                                                                       i32.const 2112
                                                                       return
                                                                      end
                                                                      i32.const 2144
                                                                      return
                                                                     end
                                                                     i32.const 2176
                                                                     return
                                                                    end
                                                                    i32.const 2208
                                                                    return
                                                                   end
                                                                   i32.const 2256
                                                                   return
                                                                  end
                                                                  i32.const 2288
                                                                  return
                                                                 end
                                                                 i32.const 2336
                                                                 return
                                                                end
                                                                i32.const 2384
                                                                return
                                                               end
                                                               i32.const 2432
                                                               return
                                                              end
                                                              i32.const 2464
                                                              return
                                                             end
                                                             i32.const 2512
                                                             return
                                                            end
                                                            i32.const 2544
                                                            return
                                                           end
                                                           i32.const 2576
                                                           return
                                                          end
                                                          i32.const 2608
                                                          return
                                                         end
                                                         i32.const 2640
                                                         return
                                                        end
                                                        i32.const 2672
                                                        return
                                                       end
                                                       i32.const 2720
                                                       return
                                                      end
                                                      i32.const 2752
                                                      return
                                                     end
                                                     i32.const 2784
                                                     return
                                                    end
                                                    i32.const 2832
                                                    return
                                                   end
                                                   i32.const 2864
                                                   return
                                                  end
                                                  i32.const 2896
                                                  return
                                                 end
                                                 i32.const 2928
                                                 return
                                                end
                                                i32.const 2960
                                                return
                                               end
                                               i32.const 2992
                                               return
                                              end
                                              i32.const 3024
                                              return
                                             end
                                             i32.const 3056
                                             return
                                            end
                                            i32.const 3088
                                            return
                                           end
                                           i32.const 3136
                                           return
                                          end
                                          i32.const 3184
                                          return
                                         end
                                         i32.const 3232
                                         return
                                        end
                                        i32.const 3280
                                        return
                                       end
                                       i32.const 3328
                                       return
                                      end
                                      i32.const 3376
                                      return
                                     end
                                     i32.const 3408
                                     return
                                    end
                                    i32.const 3440
                                    return
                                   end
                                   i32.const 3472
                                   return
                                  end
                                  i32.const 3504
                                  return
                                 end
                                 i32.const 3536
                                 return
                                end
                                i32.const 3568
                                return
                               end
                               i32.const 3600
                               return
                              end
                              i32.const 3632
                              return
                             end
                             i32.const 3664
                             return
                            end
                            i32.const 3712
                            return
                           end
                           i32.const 3744
                           return
                          end
                          i32.const 3776
                          return
                         end
                         i32.const 3824
                         return
                        end
                        i32.const 3856
                        return
                       end
                       i32.const 3904
                       return
                      end
                      i32.const 3952
                      return
                     end
                     i32.const 4000
                     return
                    end
                    i32.const 4032
                    return
                   end
                   i32.const 4064
                   return
                  end
                  i32.const 4096
                  return
                 end
                 i32.const 4144
                 return
                end
                i32.const 4192
                return
               end
               i32.const 4224
               return
              end
              i32.const 4256
              return
             end
             i32.const 4288
             return
            end
            i32.const 4336
            return
           end
           i32.const 4384
           return
          end
          i32.const 4416
          return
         end
         i32.const 4448
         return
        end
        i32.const 4480
        return
       end
       i32.const 4512
       return
      end
      i32.const 4544
      return
     end
     i32.const 4592
     return
    end
    i32.const 4624
    return
   end
   i32.const 4656
   return
  end
  i32.const 4704
 )
 (func $~lib/rt/itcms/__link (param $0 i32) (param $1 i32)
  local.get $1
  i32.eqz
  if
   return
  end
  local.get $0
  i32.eqz
  if
   i32.const 0
   i32.const 1344
   i32.const 295
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  local.get $1
  i32.const 20
  i32.sub
  local.tee $1
  call $~lib/rt/itcms/Object#get:color
  global.get $~lib/rt/itcms/white
  i32.eq
  if
   local.get $0
   i32.const 20
   i32.sub
   call $~lib/rt/itcms/Object#get:color
   local.tee $0
   global.get $~lib/rt/itcms/white
   i32.eqz
   i32.eq
   if
    local.get $1
    call $~lib/rt/itcms/Object#makeGray
   else
    global.get $~lib/rt/itcms/state
    i32.const 1
    i32.eq
    local.get $0
    i32.const 3
    i32.eq
    i32.and
    if
     local.get $1
     call $~lib/rt/itcms/Object#makeGray
    end
   end
  end
 )
 (func $~lib/dataview/DataView#set:buffer (param $0 i32) (param $1 i32)
  local.get $0
  local.get $1
  i32.store
  local.get $0
  local.get $1
  call $~lib/rt/itcms/__link
 )
 (func $~lib/arraybuffer/ArrayBufferView~visit (param $0 i32)
  local.get $0
  i32.load
  call $~lib/rt/itcms/__visit
 )
 (func $~lib/rt/__visit_members (param $0 i32)
  block $invalid
   block $~lib/typedarray/Uint8Array
    block $~lib/dataview/DataView
     block $~lib/arraybuffer/ArrayBufferView
      block $~lib/string/String
       block $~lib/arraybuffer/ArrayBuffer
        block $~lib/object/Object
         local.get $0
         i32.const 8
         i32.sub
         i32.load
         br_table $~lib/object/Object $~lib/arraybuffer/ArrayBuffer $~lib/string/String $~lib/arraybuffer/ArrayBufferView $~lib/dataview/DataView $~lib/typedarray/Uint8Array $invalid
        end
        return
       end
       return
      end
      return
     end
     local.get $0
     call $~lib/arraybuffer/ArrayBufferView~visit
     return
    end
    local.get $0
    call $~lib/arraybuffer/ArrayBufferView~visit
    return
   end
   local.get $0
   call $~lib/arraybuffer/ArrayBufferView~visit
   return
  end
  unreachable
 )
 (func $~start
  global.get $~started
  if
   return
  end
  i32.const 1
  global.set $~started
  memory.size
  i32.const 16
  i32.shl
  i32.const 37660
  i32.sub
  i32.const 1
  i32.shr_u
  global.set $~lib/rt/itcms/threshold
  i32.const 1392
  call $~lib/rt/itcms/initLazy
  global.set $~lib/rt/itcms/pinSpace
  i32.const 1424
  call $~lib/rt/itcms/initLazy
  global.set $~lib/rt/itcms/toSpace
  i32.const 1568
  call $~lib/rt/itcms/initLazy
  global.set $~lib/rt/itcms/fromSpace
  call $nm_assemblyscript/main
 )
 (func $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 4892
  i32.lt_s
  if
   i32.const 37680
   i32.const 37728
   i32.const 1
   i32.const 1
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
 )
 (func $~lib/string/String.__ne (param $0 i32) (result i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 8
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store offset=4
  global.get $~lib/memory/__stack_pointer
  i32.const 8
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  global.get $~lib/memory/__stack_pointer
  i32.const 8
  i32.add
  global.set $~lib/memory/__stack_pointer
  global.get $~lib/memory/__stack_pointer
  i32.const 8
  i32.add
  global.set $~lib/memory/__stack_pointer
  local.get $0
  i32.eqz
  i32.eqz
 )
 (func $~lib/wasi_internal/wasi_abort (param $0 i32) (param $1 i32) (param $2 i32) (param $3 i32)
  (local $4 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  i32.const 0
  i32.const 12
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf
  i32.const 12
  i64.const 9071471065260641
  i64.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  local.get $0
  call $~lib/string/String.__ne
  if (result i32)
   global.get $~lib/memory/__stack_pointer
   local.get $0
   i32.store
   local.get $0
   call $~lib/string/String#get:length
   local.set $4
   i32.const 3
   global.set $~argumentsLength
   local.get $0
   local.get $4
   i32.const 19
   call $~lib/string/String.UTF8.encodeUnsafe@varargs
   i32.const 19
   i32.add
  else
   i32.const 19
  end
  local.tee $0
  i32.const 544106784
  i32.store
  local.get $0
  i32.const 4
  i32.add
  local.set $0
  global.get $~lib/memory/__stack_pointer
  local.get $1
  i32.store
  local.get $1
  call $~lib/string/String.__ne
  if
   global.get $~lib/memory/__stack_pointer
   local.get $1
   i32.store
   local.get $1
   call $~lib/string/String#get:length
   local.set $4
   i32.const 3
   global.set $~argumentsLength
   local.get $1
   local.get $4
   local.get $0
   call $~lib/string/String.UTF8.encodeUnsafe@varargs
   local.get $0
   i32.add
   local.set $0
  end
  local.get $0
  i32.const 40
  i32.store8
  local.get $2
  call $~lib/util/number/decimalCount32
  local.tee $1
  local.get $0
  i32.const 1
  i32.add
  i32.add
  local.set $0
  loop $do-loop|0
   local.get $0
   i32.const 1
   i32.sub
   local.tee $0
   local.get $2
   i32.const 10
   i32.rem_u
   i32.const 48
   i32.add
   i32.store8
   local.get $2
   i32.const 10
   i32.div_u
   local.tee $2
   br_if $do-loop|0
  end
  local.get $0
  local.get $1
  i32.add
  local.tee $0
  i32.const 58
  i32.store8
  local.get $3
  call $~lib/util/number/decimalCount32
  local.tee $1
  local.get $0
  i32.const 1
  i32.add
  i32.add
  local.set $0
  loop $do-loop|1
   local.get $0
   i32.const 1
   i32.sub
   local.tee $0
   local.get $3
   i32.const 10
   i32.rem_u
   i32.const 48
   i32.add
   i32.store8
   local.get $3
   i32.const 10
   i32.div_u
   local.tee $3
   br_if $do-loop|1
  end
  local.get $0
  local.get $1
  i32.add
  local.tee $0
  i32.const 2601
  i32.store16
  i32.const 0
  local.get $0
  i32.const 10
  i32.sub
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  i32.const 2
  i32.const 0
  i32.const 1
  i32.const 8
  call $~lib/bindings/wasi_snapshot_preview1/fd_write
  drop
  i32.const 255
  call $~lib/bindings/wasi_snapshot_preview1/proc_exit
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $~lib/wasi_process/ReadableStream#read (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  local.get $1
  i32.const 0
  i32.lt_s
  local.get $0
  call $~lib/arraybuffer/ArrayBuffer#get:byteLength
  local.tee $2
  local.get $1
  i32.lt_u
  i32.or
  if
   i32.const 1472
   i32.const 1680
   i32.const 134
   i32.const 7
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  i32.const 1728
  local.get $0
  local.get $1
  i32.add
  i32.store
  i32.const 1732
  local.get $2
  local.get $1
  i32.sub
  i32.store
  i32.const 0
  i32.const 1728
  i32.const 1
  i32.const 1736
  call $~lib/bindings/wasi_snapshot_preview1/fd_read
  local.tee $0
  i32.const 65535
  i32.and
  if
   local.get $0
   call $~lib/bindings/wasi_snapshot_preview1/errnoToString
   i32.const 1680
   i32.const 139
   i32.const 14
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  i32.const 1736
  i32.load
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $~lib/dataview/DataView#constructor (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store offset=8
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.const 4
  call $~lib/rt/itcms/__new
  local.tee $2
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $2
  i32.store offset=4
  local.get $2
  i32.const 0
  call $~lib/dataview/DataView#set:buffer
  global.get $~lib/memory/__stack_pointer
  local.get $2
  i32.store offset=4
  local.get $2
  i32.const 0
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  global.get $~lib/memory/__stack_pointer
  local.get $2
  i32.store offset=4
  local.get $2
  i32.const 0
  call $~lib/rt/itcms/Object#set:prev
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  call $~lib/arraybuffer/ArrayBuffer#get:byteLength
  local.get $1
  i32.lt_u
  local.get $1
  i32.const 1073741820
  i32.gt_u
  i32.or
  if
   i32.const 1168
   i32.const 4752
   i32.const 25
   i32.const 7
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  global.get $~lib/memory/__stack_pointer
  local.get $2
  i32.store offset=4
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=8
  local.get $2
  local.get $0
  call $~lib/dataview/DataView#set:buffer
  global.get $~lib/memory/__stack_pointer
  local.get $2
  i32.store offset=4
  local.get $2
  local.get $0
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  global.get $~lib/memory/__stack_pointer
  local.get $2
  i32.store offset=4
  local.get $2
  local.get $1
  call $~lib/rt/itcms/Object#set:prev
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.add
  global.set $~lib/memory/__stack_pointer
  local.get $2
 )
 (func $~lib/dataview/DataView#constructor@varargs (param $0 i32) (result i32)
  (local $1 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 8
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  block $2of2
   block $1of2
    block $outOfRange
     global.get $~argumentsLength
     i32.const 1
     i32.sub
     br_table $1of2 $1of2 $2of2 $outOfRange
    end
    unreachable
   end
   global.get $~lib/memory/__stack_pointer
   local.get $0
   i32.store
   local.get $0
   call $~lib/arraybuffer/ArrayBuffer#get:byteLength
   local.set $1
  end
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  local.get $1
  call $~lib/dataview/DataView#constructor
  global.get $~lib/memory/__stack_pointer
  i32.const 8
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $nm_assemblyscript/getMessage (result i32)
  (local $0 i32)
  (local $1 i32)
  (local $2 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 16
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store offset=8
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  call $~lib/arraybuffer/ArrayBuffer#constructor
  local.tee $1
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $1
  i32.store offset=4
  local.get $1
  i32.const 0
  call $~lib/wasi_process/ReadableStream#read
  drop
  global.get $~lib/memory/__stack_pointer
  local.get $1
  i32.store offset=4
  i32.const 1
  global.set $~argumentsLength
  global.get $~lib/memory/__stack_pointer
  local.get $1
  call $~lib/dataview/DataView#constructor@varargs
  local.tee $1
  i32.store offset=8
  global.get $~lib/memory/__stack_pointer
  local.get $1
  i32.store offset=4
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $1
  i32.store
  local.get $1
  i32.load offset=8
  i32.const 4
  i32.lt_s
  if
   i32.const 1472
   i32.const 4752
   i32.const 87
   i32.const 7
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  global.get $~lib/memory/__stack_pointer
  local.get $1
  i32.store
  local.get $1
  i32.load offset=4
  i32.load
  local.set $2
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
  global.get $~lib/memory/__stack_pointer
  local.get $2
  call $~lib/arraybuffer/ArrayBuffer#constructor
  local.tee $1
  i32.store offset=12
  loop $while-continue|0
   local.get $0
   local.get $2
   i32.lt_s
   if
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store offset=4
    local.get $1
    local.get $0
    call $~lib/wasi_process/ReadableStream#read
    local.get $0
    i32.add
    local.set $0
    br $while-continue|0
   end
  end
  global.get $~lib/memory/__stack_pointer
  i32.const 16
  i32.add
  global.set $~lib/memory/__stack_pointer
  local.get $1
 )
 (func $~lib/typedarray/Uint8Array#get:length (param $0 i32) (result i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  local.get $0
  i32.load offset=8
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $~lib/wasi_process/WritableStream#write<~lib/arraybuffer/ArrayBuffer> (param $0 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  i32.const 1728
  local.get $0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  i32.const 1732
  local.get $0
  call $~lib/arraybuffer/ArrayBuffer#get:byteLength
  i32.store
  i32.const 1
  i32.const 1728
  i32.const 1
  i32.const 1736
  call $~lib/bindings/wasi_snapshot_preview1/fd_write
  local.tee $0
  i32.const 65535
  i32.and
  if
   local.get $0
   call $~lib/bindings/wasi_snapshot_preview1/errnoToString
   i32.const 1680
   i32.const 148
   i32.const 12
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $~lib/typedarray/Uint8Array#__uget (param $0 i32) (param $1 i32) (result i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  local.get $0
  i32.load offset=4
  local.get $1
  i32.add
  i32.load8_u
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $~lib/arraybuffer/ArrayBufferView#constructor (param $0 i32) (param $1 i32) (result i32)
  (local $2 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 16
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store offset=8
  local.get $0
  i32.eqz
  if
   global.get $~lib/memory/__stack_pointer
   i32.const 12
   i32.const 3
   call $~lib/rt/itcms/__new
   local.tee $0
   i32.store
  end
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  i32.const 0
  call $~lib/dataview/DataView#set:buffer
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  i32.const 0
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  i32.const 0
  call $~lib/rt/itcms/Object#set:prev
  local.get $1
  i32.const 1073741820
  i32.gt_u
  if
   i32.const 1168
   i32.const 1216
   i32.const 19
   i32.const 57
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  global.get $~lib/memory/__stack_pointer
  local.get $1
  i32.const 1
  call $~lib/rt/itcms/__new
  local.tee $2
  i32.store offset=8
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  global.get $~lib/memory/__stack_pointer
  local.get $2
  i32.store offset=12
  local.get $0
  local.get $2
  call $~lib/dataview/DataView#set:buffer
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  local.get $2
  call $~lib/bindings/wasi_snapshot_preview1/iovec#set:buf_len
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  local.get $1
  call $~lib/rt/itcms/Object#set:prev
  global.get $~lib/memory/__stack_pointer
  i32.const 16
  i32.add
  global.set $~lib/memory/__stack_pointer
  local.get $0
 )
 (func $~lib/typedarray/Uint8Array#__uset (param $0 i32) (param $1 i32) (param $2 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  local.get $0
  i32.load offset=4
  local.get $1
  i32.add
  local.get $2
  i32.store8
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $~lib/typedarray/Uint8Array#subarray (param $0 i32) (param $1 i32) (param $2 i32) (result i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store offset=8
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  call $~lib/typedarray/Uint8Array#get:length
  local.set $3
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.const 5
  call $~lib/rt/itcms/__new
  local.tee $5
  i32.store offset=8
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $5
  local.get $0
  i32.load
  local.tee $4
  i32.store
  local.get $5
  local.get $4
  call $~lib/rt/itcms/__link
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $5
  local.get $0
  i32.load offset=4
  local.get $1
  i32.const 0
  i32.lt_s
  if (result i32)
   local.get $1
   local.get $3
   i32.add
   local.tee $0
   i32.const 0
   local.get $0
   i32.const 0
   i32.gt_s
   select
  else
   local.get $1
   local.get $3
   local.get $1
   local.get $3
   i32.lt_s
   select
  end
  local.tee $0
  i32.add
  i32.store offset=4
  local.get $5
  local.get $2
  i32.const 0
  i32.lt_s
  if (result i32)
   local.get $2
   local.get $3
   i32.add
   local.tee $1
   i32.const 0
   local.get $1
   i32.const 0
   i32.gt_s
   select
  else
   local.get $2
   local.get $3
   local.get $2
   local.get $3
   i32.lt_s
   select
  end
  local.tee $1
  local.get $0
  local.get $0
  local.get $1
  i32.lt_s
  select
  local.get $0
  i32.sub
  i32.store offset=8
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.add
  global.set $~lib/memory/__stack_pointer
  local.get $5
 )
 (func $nm_assemblyscript/sendMessage (param $0 i32)
  (local $1 i32)
  (local $2 i32)
  (local $3 i32)
  (local $4 i32)
  (local $5 i32)
  (local $6 i32)
  (local $7 i32)
  (local $8 i32)
  (local $9 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 24
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.const 24
  memory.fill
  global.get $~lib/memory/__stack_pointer
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  i32.const 1
  global.set $~argumentsLength
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  block $2of2
   block $1of2
    block $outOfRange
     global.get $~argumentsLength
     i32.const 1
     i32.sub
     br_table $1of2 $1of2 $2of2 $outOfRange
    end
    unreachable
   end
   i32.const -1
   local.set $1
  end
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store offset=8
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.store offset=4
  local.get $0
  call $~lib/arraybuffer/ArrayBuffer#get:byteLength
  local.set $3
  local.get $1
  i32.const 0
  i32.lt_s
  if
   local.get $1
   i32.const -1
   i32.eq
   if (result i32)
    local.get $3
   else
    i32.const 1168
    i32.const 4816
    i32.const 1869
    i32.const 7
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
   local.set $1
  else
   local.get $1
   local.get $3
   i32.gt_s
   if
    i32.const 1168
    i32.const 4816
    i32.const 1874
    i32.const 7
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
  end
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.const 5
  call $~lib/rt/itcms/__new
  local.tee $4
  i32.store offset=8
  local.get $4
  local.get $0
  i32.store
  local.get $4
  local.get $0
  call $~lib/rt/itcms/__link
  local.get $4
  local.get $1
  i32.store offset=8
  local.get $4
  local.get $0
  i32.store offset=4
  global.get $~lib/memory/__stack_pointer
  i32.const 12
  i32.add
  global.set $~lib/memory/__stack_pointer
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
  local.get $4
  i32.store offset=4
  global.get $~lib/memory/__stack_pointer
  local.get $4
  i32.store
  local.get $4
  call $~lib/typedarray/Uint8Array#get:length
  local.tee $3
  i32.const 1048576
  i32.le_s
  if
   global.get $~lib/memory/__stack_pointer
   i32.const 4
   call $~lib/arraybuffer/ArrayBuffer#constructor
   local.tee $0
   i32.store offset=8
   global.get $~lib/memory/__stack_pointer
   local.get $0
   i32.store offset=12
   i32.const 1
   global.set $~argumentsLength
   local.get $0
   call $~lib/dataview/DataView#constructor@varargs
   local.set $1
   global.get $~lib/memory/__stack_pointer
   local.get $1
   i32.store
   global.get $~lib/memory/__stack_pointer
   local.get $4
   i32.store offset=16
   global.get $~lib/memory/__stack_pointer
   local.get $4
   i32.load
   local.tee $2
   i32.store offset=12
   local.get $2
   call $~lib/arraybuffer/ArrayBuffer#get:byteLength
   local.set $2
   global.get $~lib/memory/__stack_pointer
   i32.const 4
   i32.sub
   global.set $~lib/memory/__stack_pointer
   call $~stack_check
   global.get $~lib/memory/__stack_pointer
   i32.const 0
   i32.store
   global.get $~lib/memory/__stack_pointer
   local.get $1
   i32.store
   local.get $1
   i32.load offset=8
   i32.const 4
   i32.lt_s
   if
    i32.const 1472
    i32.const 4752
    i32.const 142
    i32.const 7
    call $~lib/wasi_internal/wasi_abort
    unreachable
   end
   global.get $~lib/memory/__stack_pointer
   local.get $1
   i32.store
   local.get $1
   i32.load offset=4
   local.get $2
   i32.store
   global.get $~lib/memory/__stack_pointer
   i32.const 4
   i32.add
   global.set $~lib/memory/__stack_pointer
   global.get $~lib/memory/__stack_pointer
   local.get $0
   i32.store
   local.get $0
   call $~lib/wasi_process/WritableStream#write<~lib/arraybuffer/ArrayBuffer>
   global.get $~lib/memory/__stack_pointer
   local.get $4
   i32.store offset=12
   global.get $~lib/memory/__stack_pointer
   local.get $4
   i32.load
   local.tee $0
   i32.store
   local.get $0
   call $~lib/wasi_process/WritableStream#write<~lib/arraybuffer/ArrayBuffer>
   global.get $~lib/memory/__stack_pointer
   i32.const 24
   i32.add
   global.set $~lib/memory/__stack_pointer
   return
  end
  loop $while-continue|0
   local.get $2
   local.get $3
   i32.lt_s
   if
    local.get $3
    local.get $2
    i32.const 1048568
    i32.add
    local.tee $1
    i32.le_s
    if (result i32)
     local.get $3
    else
     i32.const -1
     local.set $0
     loop $for-loop|1
      local.get $1
      local.get $3
      i32.lt_s
      if
       block $for-break1
        global.get $~lib/memory/__stack_pointer
        local.get $4
        i32.store
        local.get $4
        local.get $1
        call $~lib/typedarray/Uint8Array#__uget
        i32.const 44
        i32.eq
        if
         local.get $1
         local.set $0
         br $for-break1
        end
        local.get $1
        i32.const 1
        i32.add
        local.set $1
        br $for-loop|1
       end
      end
     end
     local.get $3
     local.get $0
     local.get $0
     i32.const -1
     i32.eq
     select
    end
    local.set $0
    global.get $~lib/memory/__stack_pointer
    local.get $4
    i32.store
    local.get $4
    local.get $2
    call $~lib/typedarray/Uint8Array#__uget
    local.set $1
    global.get $~lib/memory/__stack_pointer
    local.get $4
    i32.store
    local.get $4
    local.get $0
    i32.const 1
    i32.sub
    call $~lib/typedarray/Uint8Array#__uget
    local.set $6
    i32.const 0
    local.set $5
    global.get $~lib/memory/__stack_pointer
    global.get $~lib/memory/__stack_pointer
    i32.const 8
    i32.sub
    global.set $~lib/memory/__stack_pointer
    call $~stack_check
    global.get $~lib/memory/__stack_pointer
    i64.const 0
    i64.store
    global.get $~lib/memory/__stack_pointer
    i32.const 12
    i32.const 5
    call $~lib/rt/itcms/__new
    local.tee $8
    i32.store
    global.get $~lib/memory/__stack_pointer
    local.get $8
    i32.store offset=4
    global.get $~lib/memory/__stack_pointer
    local.get $8
    local.get $1
    i32.const 91
    i32.eq
    if (result i32)
     local.get $6
     i32.const 93
     i32.ne
    else
     local.get $1
     i32.const 44
     i32.eq
     if (result i32)
      i32.const 1
      local.set $5
      local.get $6
      i32.const 93
      i32.ne
     else
      i32.const 0
     end
    end
    local.tee $6
    local.get $0
    local.get $2
    i32.const 1
    i32.add
    local.get $2
    local.get $5
    select
    local.tee $8
    i32.sub
    local.tee $2
    local.get $5
    i32.add
    i32.add
    local.tee $9
    i32.const 4
    i32.add
    call $~lib/arraybuffer/ArrayBufferView#constructor
    local.tee $1
    i32.store
    global.get $~lib/memory/__stack_pointer
    i32.const 8
    i32.add
    global.set $~lib/memory/__stack_pointer
    local.get $1
    i32.store offset=20
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store
    local.get $1
    i32.const 0
    local.get $9
    i32.const 255
    i32.and
    call $~lib/typedarray/Uint8Array#__uset
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store
    local.get $1
    i32.const 1
    local.get $9
    i32.const 8
    i32.shr_s
    i32.const 255
    i32.and
    call $~lib/typedarray/Uint8Array#__uset
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store
    local.get $1
    i32.const 2
    local.get $9
    i32.const 16
    i32.shr_s
    i32.const 255
    i32.and
    call $~lib/typedarray/Uint8Array#__uset
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store
    local.get $1
    i32.const 3
    local.get $9
    i32.const 24
    i32.shr_s
    i32.const 255
    i32.and
    call $~lib/typedarray/Uint8Array#__uset
    local.get $5
    if (result i32)
     global.get $~lib/memory/__stack_pointer
     local.get $1
     i32.store
     local.get $1
     i32.const 4
     i32.const 91
     call $~lib/typedarray/Uint8Array#__uset
     i32.const 5
    else
     i32.const 4
    end
    local.set $5
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store
    global.get $~lib/memory/__stack_pointer
    local.get $4
    i32.store offset=16
    local.get $4
    local.get $8
    local.get $0
    call $~lib/typedarray/Uint8Array#subarray
    local.set $7
    global.get $~lib/memory/__stack_pointer
    local.get $7
    i32.store offset=12
    global.get $~lib/memory/__stack_pointer
    i32.const 12
    i32.sub
    global.set $~lib/memory/__stack_pointer
    call $~stack_check
    global.get $~lib/memory/__stack_pointer
    i64.const 0
    i64.store
    global.get $~lib/memory/__stack_pointer
    i32.const 0
    i32.store offset=8
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store
    global.get $~lib/memory/__stack_pointer
    local.get $7
    i32.store offset=4
    global.get $~lib/memory/__stack_pointer
    local.get $7
    i32.store offset=8
    local.get $7
    call $~lib/typedarray/Uint8Array#get:length
    local.set $8
    local.get $5
    i32.const 0
    i32.lt_s
    if (result i32)
     i32.const 1
    else
     global.get $~lib/memory/__stack_pointer
     local.get $1
     i32.store offset=8
     local.get $1
     call $~lib/typedarray/Uint8Array#get:length
     local.get $5
     local.get $8
     i32.add
     i32.lt_s
    end
    if
     i32.const 1472
     i32.const 4816
     i32.const 1902
     i32.const 5
     call $~lib/wasi_internal/wasi_abort
     unreachable
    end
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store offset=8
    local.get $1
    i32.load offset=4
    local.get $5
    i32.add
    global.get $~lib/memory/__stack_pointer
    local.get $7
    i32.store offset=8
    local.get $7
    i32.load offset=4
    local.get $8
    memory.copy
    global.get $~lib/memory/__stack_pointer
    i32.const 12
    i32.add
    global.set $~lib/memory/__stack_pointer
    local.get $6
    if
     global.get $~lib/memory/__stack_pointer
     local.get $1
     i32.store
     local.get $1
     local.get $2
     local.get $5
     i32.add
     i32.const 93
     call $~lib/typedarray/Uint8Array#__uset
    end
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.store offset=12
    global.get $~lib/memory/__stack_pointer
    local.get $1
    i32.load
    local.tee $1
    i32.store
    local.get $1
    call $~lib/wasi_process/WritableStream#write<~lib/arraybuffer/ArrayBuffer>
    local.get $0
    local.set $2
    br $while-continue|0
   end
  end
  global.get $~lib/memory/__stack_pointer
  i32.const 24
  i32.add
  global.set $~lib/memory/__stack_pointer
 )
 (func $nm_assemblyscript/main
  (local $0 i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 8
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i64.const 0
  i64.store
  loop $while-continue|0
   global.get $~lib/memory/__stack_pointer
   call $nm_assemblyscript/getMessage
   local.tee $0
   i32.store
   global.get $~lib/memory/__stack_pointer
   local.get $0
   i32.store offset=4
   local.get $0
   call $nm_assemblyscript/sendMessage
   br $while-continue|0
  end
  unreachable
 )
 (func $~lib/arraybuffer/ArrayBuffer#constructor (param $0 i32) (result i32)
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.sub
  global.set $~lib/memory/__stack_pointer
  call $~stack_check
  global.get $~lib/memory/__stack_pointer
  i32.const 0
  i32.store
  local.get $0
  i32.const 1073741820
  i32.gt_u
  if
   i32.const 1168
   i32.const 1216
   i32.const 52
   i32.const 43
   call $~lib/wasi_internal/wasi_abort
   unreachable
  end
  global.get $~lib/memory/__stack_pointer
  local.get $0
  i32.const 1
  call $~lib/rt/itcms/__new
  local.tee $0
  i32.store
  global.get $~lib/memory/__stack_pointer
  i32.const 4
  i32.add
  global.set $~lib/memory/__stack_pointer
  local.get $0
 )
)
