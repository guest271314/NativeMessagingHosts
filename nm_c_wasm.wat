(module
  (type $t0 (func (param i32 i32 i32) (result i32)))
  (type $t1 (func (param i32 i64 i32) (result i64)))
  (type $t2 (func (param i32) (result i32)))
  (type $t3 (func (param i32 i32) (result i32)))
  (type $t4 (func (param i32 i32 i32 i32) (result i32)))
  (type $t5 (func (param i32 i64 i32 i32) (result i32)))
  (type $t6 (func (param i32)))
  (type $t7 (func))
  (type $t8 (func (result i32)))
  (import "wasi_snapshot_preview1" "fd_close" (func $__imported_wasi_snapshot_preview1_fd_close (type $t2)))
  (import "wasi_snapshot_preview1" "fd_fdstat_get" (func $__imported_wasi_snapshot_preview1_fd_fdstat_get (type $t3)))
  (import "wasi_snapshot_preview1" "fd_read" (func $__imported_wasi_snapshot_preview1_fd_read (type $t4)))
  (import "wasi_snapshot_preview1" "fd_seek" (func $__imported_wasi_snapshot_preview1_fd_seek (type $t5)))
  (import "wasi_snapshot_preview1" "fd_write" (func $__imported_wasi_snapshot_preview1_fd_write (type $t4)))
  (import "wasi_snapshot_preview1" "proc_exit" (func $__imported_wasi_snapshot_preview1_proc_exit (type $t6)))
  (func $__wasm_call_ctors (type $t7))
  (func $_start (export "_start") (type $t7)
    (local $l0 i32)
    (block $B0
      (block $B1
        (br_if $B1
          (i32.load offset=1280
            (i32.const 0)))
        (i32.store offset=1280
          (i32.const 0)
          (i32.const 1))
        (call $__wasm_call_ctors)
        (local.set $l0
          (call $__original_main))
        (call $__wasm_call_dtors)
        (br_if $B0
          (local.get $l0))
        (return))
      (unreachable)
      (unreachable))
    (call $__wasi_proc_exit
      (local.get $l0))
    (unreachable))
  (func $getMessage (type $t2) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32) (local $l16 i32) (local $l17 i32) (local $l18 i32) (local $l19 i32) (local $l20 i32) (local $l21 i32) (local $l22 i32) (local $l23 i32) (local $l24 i32) (local $l25 i32) (local $l26 i32) (local $l27 i32) (local $l28 i32)
    (local.set $l1
      (global.get $__stack_pointer))
    (local.set $l2
      (i32.const 16))
    (local.set $l3
      (i32.sub
        (local.get $l1)
        (local.get $l2)))
    (global.set $__stack_pointer
      (local.get $l3))
    (i32.store offset=12
      (local.get $l3)
      (local.get $p0))
    (local.set $l4
      (i32.const 0))
    (i32.store offset=8
      (local.get $l3)
      (local.get $l4))
    (local.set $l5
      (i32.const 0))
    (local.set $l6
      (i32.load offset=1024
        (local.get $l5)))
    (local.set $l7
      (i32.const 8))
    (local.set $l8
      (i32.add
        (local.get $l3)
        (local.get $l7)))
    (local.set $l9
      (local.get $l8))
    (local.set $l10
      (i32.const 4))
    (local.set $l11
      (i32.const 1))
    (local.set $l12
      (call $fread
        (local.get $l9)
        (local.get $l10)
        (local.get $l11)
        (local.get $l6)))
    (i32.store offset=4
      (local.get $l3)
      (local.get $l12))
    (local.set $l13
      (i32.load offset=8
        (local.get $l3)))
    (local.set $l14
      (i32.const 1))
    (local.set $l15
      (i32.add
        (local.get $l13)
        (local.get $l14)))
    (local.set $l16
      (i32.const 1))
    (local.set $l17
      (call $calloc
        (local.get $l15)
        (local.get $l16)))
    (i32.store
      (local.get $l3)
      (local.get $l17))
    (local.set $l18
      (i32.load
        (local.get $l3)))
    (local.set $l19
      (i32.load offset=8
        (local.get $l3)))
    (local.set $l20
      (i32.const 0))
    (local.set $l21
      (i32.load offset=1024
        (local.get $l20)))
    (local.set $l22
      (i32.const 1))
    (local.set $l23
      (call $fread
        (local.get $l18)
        (local.get $l22)
        (local.get $l19)
        (local.get $l21)))
    (i32.store offset=4
      (local.get $l3)
      (local.get $l23))
    (local.set $l24
      (i32.load offset=8
        (local.get $l3)))
    (local.set $l25
      (i32.load offset=12
        (local.get $l3)))
    (i32.store
      (local.get $l25)
      (local.get $l24))
    (local.set $l26
      (i32.load
        (local.get $l3)))
    (local.set $l27
      (i32.const 16))
    (local.set $l28
      (i32.add
        (local.get $l3)
        (local.get $l27)))
    (global.set $__stack_pointer
      (local.get $l28))
    (return
      (local.get $l26)))
  (func $sendMessage (type $t6) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32) (local $l12 i32) (local $l13 i32) (local $l14 i32) (local $l15 i32) (local $l16 i32) (local $l17 i32) (local $l18 i32) (local $l19 i32) (local $l20 i32) (local $l21 i32)
    (local.set $l1
      (global.get $__stack_pointer))
    (local.set $l2
      (i32.const 16))
    (local.set $l3
      (i32.sub
        (local.get $l1)
        (local.get $l2)))
    (global.set $__stack_pointer
      (local.get $l3))
    (i32.store offset=12
      (local.get $l3)
      (local.get $p0))
    (local.set $l4
      (i32.load offset=12
        (local.get $l3)))
    (local.set $l5
      (call $strlen
        (local.get $l4)))
    (i32.store offset=8
      (local.get $l3)
      (local.get $l5))
    (local.set $l6
      (i32.const 0))
    (local.set $l7
      (i32.load offset=1028
        (local.get $l6)))
    (local.set $l8
      (i32.const 8))
    (local.set $l9
      (i32.add
        (local.get $l3)
        (local.get $l8)))
    (local.set $l10
      (local.get $l9))
    (local.set $l11
      (i32.const 4))
    (local.set $l12
      (i32.const 1))
    (drop
      (call $fwrite
        (local.get $l10)
        (local.get $l11)
        (local.get $l12)
        (local.get $l7)))
    (local.set $l13
      (i32.load offset=12
        (local.get $l3)))
    (local.set $l14
      (i32.load offset=8
        (local.get $l3)))
    (local.set $l15
      (i32.const 0))
    (local.set $l16
      (i32.load offset=1028
        (local.get $l15)))
    (local.set $l17
      (i32.const 1))
    (drop
      (call $fwrite
        (local.get $l13)
        (local.get $l14)
        (local.get $l17)
        (local.get $l16)))
    (local.set $l18
      (i32.const 0))
    (local.set $l19
      (i32.load offset=1028
        (local.get $l18)))
    (drop
      (call $fflush
        (local.get $l19)))
    (local.set $l20
      (i32.const 16))
    (local.set $l21
      (i32.add
        (local.get $l3)
        (local.get $l20)))
    (global.set $__stack_pointer
      (local.get $l21))
    (return))
  (func $__original_main (type $t8) (result i32)
    (local $l0 i32) (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32)
    (local.set $l0
      (global.get $__stack_pointer))
    (local.set $l1
      (i32.const 16))
    (local.set $l2
      (i32.sub
        (local.get $l0)
        (local.get $l1)))
    (global.set $__stack_pointer
      (local.get $l2))
    (local.set $l3
      (i32.const 0))
    (i32.store offset=12
      (local.get $l2)
      (local.get $l3))
    (loop $L0 (result i32)
      (local.set $l4
        (i32.const 0))
      (i32.store offset=8
        (local.get $l2)
        (local.get $l4))
      (local.set $l5
        (i32.const 8))
      (local.set $l6
        (i32.add
          (local.get $l2)
          (local.get $l5)))
      (local.set $l7
        (local.get $l6))
      (local.set $l8
        (call $getMessage
          (local.get $l7)))
      (i32.store offset=4
        (local.get $l2)
        (local.get $l8))
      (local.set $l9
        (i32.load offset=4
          (local.get $l2)))
      (call $sendMessage
        (local.get $l9))
      (local.set $l10
        (i32.load offset=4
          (local.get $l2)))
      (call $free
        (local.get $l10))
      (br $L0)))
  (func $dlmalloc (type $t2) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32) (local $l10 i32) (local $l11 i32)
    (global.set $__stack_pointer
      (local.tee $l1
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (block $B0
      (br_if $B0
        (local.tee $l2
          (i32.load offset=1308
            (i32.const 0))))
      (block $B1
        (block $B2
          (br_if $B2
            (i32.eqz
              (local.tee $l3
                (i32.load offset=1756
                  (i32.const 0)))))
          (local.set $l4
            (i32.load offset=1760
              (i32.const 0)))
          (br $B1))
        (i64.store offset=1768 align=4
          (i32.const 0)
          (i64.const -1))
        (i64.store offset=1760 align=4
          (i32.const 0)
          (i64.const 281474976776192))
        (i32.store offset=1756
          (i32.const 0)
          (local.tee $l3
            (i32.xor
              (i32.and
                (i32.add
                  (local.get $l1)
                  (i32.const 8))
                (i32.const -16))
              (i32.const 1431655768))))
        (i32.store offset=1776
          (i32.const 0)
          (i32.const 0))
        (i32.store offset=1728
          (i32.const 0)
          (i32.const 0))
        (local.set $l4
          (i32.const 65536)))
      (local.set $l2
        (i32.const 0))
      (br_if $B0
        (i32.lt_u
          (local.tee $l5
            (i32.sub
              (select
                (i32.const 131072)
                (i32.and
                  (i32.add
                    (i32.add
                      (i32.const 69408)
                      (local.get $l4))
                    (i32.const -1))
                  (i32.sub
                    (i32.const 0)
                    (local.get $l4)))
                (i32.const 131072))
              (i32.const 69408)))
          (i32.const 89)))
      (local.set $l4
        (i32.const 0))
      (i32.store offset=1736
        (i32.const 0)
        (local.get $l5))
      (i32.store offset=1732
        (i32.const 0)
        (i32.const 69408))
      (i32.store offset=1300
        (i32.const 0)
        (i32.const 69408))
      (i32.store offset=1320
        (i32.const 0)
        (local.get $l3))
      (i32.store offset=1316
        (i32.const 0)
        (i32.const -1))
      (loop $L3
        (i32.store
          (i32.add
            (local.get $l4)
            (i32.const 1344))
          (local.tee $l3
            (i32.add
              (local.get $l4)
              (i32.const 1332))))
        (i32.store
          (local.get $l3)
          (local.tee $l6
            (i32.add
              (local.get $l4)
              (i32.const 1324))))
        (i32.store
          (i32.add
            (local.get $l4)
            (i32.const 1336))
          (local.get $l6))
        (i32.store
          (i32.add
            (local.get $l4)
            (i32.const 1352))
          (local.tee $l6
            (i32.add
              (local.get $l4)
              (i32.const 1340))))
        (i32.store
          (local.get $l6)
          (local.get $l3))
        (i32.store
          (i32.add
            (local.get $l4)
            (i32.const 1360))
          (local.tee $l3
            (i32.add
              (local.get $l4)
              (i32.const 1348))))
        (i32.store
          (local.get $l3)
          (local.get $l6))
        (i32.store
          (i32.add
            (local.get $l4)
            (i32.const 1356))
          (local.get $l3))
        (br_if $L3
          (i32.ne
            (local.tee $l4
              (i32.add
                (local.get $l4)
                (i32.const 32)))
            (i32.const 256))))
      (i32.store
        (i32.add
          (local.tee $l2
            (i32.add
              (i32.const 69408)
              (local.tee $l4
                (select
                  (i32.and
                    (i32.sub
                      (i32.const -8)
                      (i32.const 69408))
                    (i32.const 15))
                  (i32.const 0)
                  (i32.and
                    (i32.add
                      (i32.const 69408)
                      (i32.const 8))
                    (i32.const 15))))))
          (i32.const 4))
        (i32.or
          (local.tee $l4
            (i32.sub
              (local.tee $l3
                (i32.add
                  (local.get $l5)
                  (i32.const -56)))
              (local.get $l4)))
          (i32.const 1)))
      (i32.store offset=1312
        (i32.const 0)
        (i32.load offset=1772
          (i32.const 0)))
      (i32.store offset=1296
        (i32.const 0)
        (local.get $l4))
      (i32.store offset=1308
        (i32.const 0)
        (local.get $l2))
      (i32.store offset=4
        (i32.add
          (i32.const 69408)
          (local.get $l3))
        (i32.const 56)))
    (block $B4
      (block $B5
        (block $B6
          (block $B7
            (block $B8
              (block $B9
                (block $B10
                  (block $B11
                    (block $B12
                      (block $B13
                        (block $B14
                          (block $B15
                            (br_if $B15
                              (i32.gt_u
                                (local.get $p0)
                                (i32.const 236)))
                            (block $B16
                              (br_if $B16
                                (i32.eqz
                                  (i32.and
                                    (local.tee $l4
                                      (i32.shr_u
                                        (local.tee $l7
                                          (i32.load offset=1284
                                            (i32.const 0)))
                                        (local.tee $l3
                                          (i32.shr_u
                                            (local.tee $l5
                                              (select
                                                (i32.const 16)
                                                (i32.and
                                                  (i32.add
                                                    (local.get $p0)
                                                    (i32.const 19))
                                                  (i32.const -16))
                                                (i32.lt_u
                                                  (local.get $p0)
                                                  (i32.const 11))))
                                            (i32.const 3)))))
                                    (i32.const 3))))
                              (block $B17
                                (block $B18
                                  (br_if $B18
                                    (i32.ne
                                      (local.tee $l4
                                        (i32.add
                                          (local.tee $l3
                                            (i32.shl
                                              (local.tee $l6
                                                (i32.xor
                                                  (i32.or
                                                    (i32.and
                                                      (local.get $l4)
                                                      (i32.const 1))
                                                    (local.get $l3))
                                                  (i32.const 1)))
                                              (i32.const 3)))
                                          (i32.const 1324)))
                                      (local.tee $l5
                                        (i32.load offset=8
                                          (local.tee $l3
                                            (i32.load
                                              (i32.add
                                                (local.get $l3)
                                                (i32.const 1332))))))))
                                  (i32.store offset=1284
                                    (i32.const 0)
                                    (i32.and
                                      (local.get $l7)
                                      (i32.rotl
                                        (i32.const -2)
                                        (local.get $l6))))
                                  (br $B17))
                                (i32.store offset=8
                                  (local.get $l4)
                                  (local.get $l5))
                                (i32.store offset=12
                                  (local.get $l5)
                                  (local.get $l4)))
                              (local.set $l4
                                (i32.add
                                  (local.get $l3)
                                  (i32.const 8)))
                              (i32.store offset=4
                                (local.get $l3)
                                (i32.or
                                  (local.tee $l6
                                    (i32.shl
                                      (local.get $l6)
                                      (i32.const 3)))
                                  (i32.const 3)))
                              (i32.store offset=4
                                (local.tee $l3
                                  (i32.add
                                    (local.get $l3)
                                    (local.get $l6)))
                                (i32.or
                                  (i32.load offset=4
                                    (local.get $l3))
                                  (i32.const 1)))
                              (br $B4))
                            (br_if $B14
                              (i32.le_u
                                (local.get $l5)
                                (local.tee $l8
                                  (i32.load offset=1292
                                    (i32.const 0)))))
                            (block $B19
                              (br_if $B19
                                (i32.eqz
                                  (local.get $l4)))
                              (block $B20
                                (block $B21
                                  (br_if $B21
                                    (i32.ne
                                      (local.tee $l6
                                        (i32.add
                                          (local.tee $l4
                                            (i32.shl
                                              (local.tee $l3
                                                (i32.add
                                                  (i32.or
                                                    (i32.or
                                                      (i32.or
                                                        (i32.or
                                                          (local.tee $l6
                                                            (i32.and
                                                              (i32.shr_u
                                                                (local.tee $l3
                                                                  (i32.shr_u
                                                                    (local.tee $l4
                                                                      (i32.add
                                                                        (i32.and
                                                                          (local.tee $l4
                                                                            (i32.and
                                                                              (i32.shl
                                                                                (local.get $l4)
                                                                                (local.get $l3))
                                                                              (i32.or
                                                                                (local.tee $l4
                                                                                  (i32.shl
                                                                                    (i32.const 2)
                                                                                    (local.get $l3)))
                                                                                (i32.sub
                                                                                  (i32.const 0)
                                                                                  (local.get $l4)))))
                                                                          (i32.sub
                                                                            (i32.const 0)
                                                                            (local.get $l4)))
                                                                        (i32.const -1)))
                                                                    (local.tee $l4
                                                                      (i32.and
                                                                        (i32.shr_u
                                                                          (local.get $l4)
                                                                          (i32.const 12))
                                                                        (i32.const 16)))))
                                                                (i32.const 5))
                                                              (i32.const 8)))
                                                          (local.get $l4))
                                                        (local.tee $l3
                                                          (i32.and
                                                            (i32.shr_u
                                                              (local.tee $l4
                                                                (i32.shr_u
                                                                  (local.get $l3)
                                                                  (local.get $l6)))
                                                              (i32.const 2))
                                                            (i32.const 4))))
                                                      (local.tee $l3
                                                        (i32.and
                                                          (i32.shr_u
                                                            (local.tee $l4
                                                              (i32.shr_u
                                                                (local.get $l4)
                                                                (local.get $l3)))
                                                            (i32.const 1))
                                                          (i32.const 2))))
                                                    (local.tee $l3
                                                      (i32.and
                                                        (i32.shr_u
                                                          (local.tee $l4
                                                            (i32.shr_u
                                                              (local.get $l4)
                                                              (local.get $l3)))
                                                          (i32.const 1))
                                                        (i32.const 1))))
                                                  (i32.shr_u
                                                    (local.get $l4)
                                                    (local.get $l3))))
                                              (i32.const 3)))
                                          (i32.const 1324)))
                                      (local.tee $p0
                                        (i32.load offset=8
                                          (local.tee $l4
                                            (i32.load
                                              (i32.add
                                                (local.get $l4)
                                                (i32.const 1332))))))))
                                  (i32.store offset=1284
                                    (i32.const 0)
                                    (local.tee $l7
                                      (i32.and
                                        (local.get $l7)
                                        (i32.rotl
                                          (i32.const -2)
                                          (local.get $l3)))))
                                  (br $B20))
                                (i32.store offset=8
                                  (local.get $l6)
                                  (local.get $p0))
                                (i32.store offset=12
                                  (local.get $p0)
                                  (local.get $l6)))
                              (i32.store offset=4
                                (local.get $l4)
                                (i32.or
                                  (local.get $l5)
                                  (i32.const 3)))
                              (i32.store
                                (i32.add
                                  (local.get $l4)
                                  (local.tee $l3
                                    (i32.shl
                                      (local.get $l3)
                                      (i32.const 3))))
                                (local.tee $l6
                                  (i32.sub
                                    (local.get $l3)
                                    (local.get $l5))))
                              (i32.store offset=4
                                (local.tee $p0
                                  (i32.add
                                    (local.get $l4)
                                    (local.get $l5)))
                                (i32.or
                                  (local.get $l6)
                                  (i32.const 1)))
                              (block $B22
                                (br_if $B22
                                  (i32.eqz
                                    (local.get $l8)))
                                (local.set $l5
                                  (i32.add
                                    (i32.and
                                      (local.get $l8)
                                      (i32.const -8))
                                    (i32.const 1324)))
                                (local.set $l3
                                  (i32.load offset=1304
                                    (i32.const 0)))
                                (block $B23
                                  (block $B24
                                    (br_if $B24
                                      (i32.and
                                        (local.get $l7)
                                        (local.tee $l9
                                          (i32.shl
                                            (i32.const 1)
                                            (i32.shr_u
                                              (local.get $l8)
                                              (i32.const 3))))))
                                    (i32.store offset=1284
                                      (i32.const 0)
                                      (i32.or
                                        (local.get $l7)
                                        (local.get $l9)))
                                    (local.set $l9
                                      (local.get $l5))
                                    (br $B23))
                                  (local.set $l9
                                    (i32.load offset=8
                                      (local.get $l5))))
                                (i32.store offset=12
                                  (local.get $l9)
                                  (local.get $l3))
                                (i32.store offset=8
                                  (local.get $l5)
                                  (local.get $l3))
                                (i32.store offset=12
                                  (local.get $l3)
                                  (local.get $l5))
                                (i32.store offset=8
                                  (local.get $l3)
                                  (local.get $l9)))
                              (local.set $l4
                                (i32.add
                                  (local.get $l4)
                                  (i32.const 8)))
                              (i32.store offset=1304
                                (i32.const 0)
                                (local.get $p0))
                              (i32.store offset=1292
                                (i32.const 0)
                                (local.get $l6))
                              (br $B4))
                            (br_if $B14
                              (i32.eqz
                                (local.tee $l10
                                  (i32.load offset=1288
                                    (i32.const 0)))))
                            (local.set $l3
                              (i32.sub
                                (i32.and
                                  (i32.load offset=4
                                    (local.tee $p0
                                      (i32.load
                                        (i32.add
                                          (i32.shl
                                            (i32.add
                                              (i32.or
                                                (i32.or
                                                  (i32.or
                                                    (i32.or
                                                      (local.tee $l6
                                                        (i32.and
                                                          (i32.shr_u
                                                            (local.tee $l3
                                                              (i32.shr_u
                                                                (local.tee $l4
                                                                  (i32.add
                                                                    (i32.and
                                                                      (local.get $l10)
                                                                      (i32.sub
                                                                        (i32.const 0)
                                                                        (local.get $l10)))
                                                                    (i32.const -1)))
                                                                (local.tee $l4
                                                                  (i32.and
                                                                    (i32.shr_u
                                                                      (local.get $l4)
                                                                      (i32.const 12))
                                                                    (i32.const 16)))))
                                                            (i32.const 5))
                                                          (i32.const 8)))
                                                      (local.get $l4))
                                                    (local.tee $l3
                                                      (i32.and
                                                        (i32.shr_u
                                                          (local.tee $l4
                                                            (i32.shr_u
                                                              (local.get $l3)
                                                              (local.get $l6)))
                                                          (i32.const 2))
                                                        (i32.const 4))))
                                                  (local.tee $l3
                                                    (i32.and
                                                      (i32.shr_u
                                                        (local.tee $l4
                                                          (i32.shr_u
                                                            (local.get $l4)
                                                            (local.get $l3)))
                                                        (i32.const 1))
                                                      (i32.const 2))))
                                                (local.tee $l3
                                                  (i32.and
                                                    (i32.shr_u
                                                      (local.tee $l4
                                                        (i32.shr_u
                                                          (local.get $l4)
                                                          (local.get $l3)))
                                                      (i32.const 1))
                                                    (i32.const 1))))
                                              (i32.shr_u
                                                (local.get $l4)
                                                (local.get $l3)))
                                            (i32.const 2))
                                          (i32.const 1588)))))
                                  (i32.const -8))
                                (local.get $l5)))
                            (local.set $l6
                              (local.get $p0))
                            (block $B25
                              (loop $L26
                                (block $B27
                                  (br_if $B27
                                    (local.tee $l4
                                      (i32.load offset=16
                                        (local.get $l6))))
                                  (br_if $B25
                                    (i32.eqz
                                      (local.tee $l4
                                        (i32.load
                                          (i32.add
                                            (local.get $l6)
                                            (i32.const 20)))))))
                                (local.set $l3
                                  (select
                                    (local.tee $l6
                                      (i32.sub
                                        (i32.and
                                          (i32.load offset=4
                                            (local.get $l4))
                                          (i32.const -8))
                                        (local.get $l5)))
                                    (local.get $l3)
                                    (local.tee $l6
                                      (i32.lt_u
                                        (local.get $l6)
                                        (local.get $l3)))))
                                (local.set $p0
                                  (select
                                    (local.get $l4)
                                    (local.get $p0)
                                    (local.get $l6)))
                                (local.set $l6
                                  (local.get $l4))
                                (br $L26)))
                            (local.set $l11
                              (i32.load offset=24
                                (local.get $p0)))
                            (block $B28
                              (br_if $B28
                                (i32.eq
                                  (local.tee $l9
                                    (i32.load offset=12
                                      (local.get $p0)))
                                  (local.get $p0)))
                              (drop
                                (i32.lt_u
                                  (local.tee $l4
                                    (i32.load offset=8
                                      (local.get $p0)))
                                  (i32.load offset=1300
                                    (i32.const 0))))
                              (i32.store offset=8
                                (local.get $l9)
                                (local.get $l4))
                              (i32.store offset=12
                                (local.get $l4)
                                (local.get $l9))
                              (br $B5))
                            (block $B29
                              (br_if $B29
                                (local.tee $l4
                                  (i32.load
                                    (local.tee $l6
                                      (i32.add
                                        (local.get $p0)
                                        (i32.const 20))))))
                              (br_if $B13
                                (i32.eqz
                                  (local.tee $l4
                                    (i32.load offset=16
                                      (local.get $p0)))))
                              (local.set $l6
                                (i32.add
                                  (local.get $p0)
                                  (i32.const 16))))
                            (loop $L30
                              (local.set $l2
                                (local.get $l6))
                              (br_if $L30
                                (local.tee $l4
                                  (i32.load
                                    (local.tee $l6
                                      (i32.add
                                        (local.tee $l9
                                          (local.get $l4))
                                        (i32.const 20))))))
                              (local.set $l6
                                (i32.add
                                  (local.get $l9)
                                  (i32.const 16)))
                              (br_if $L30
                                (local.tee $l4
                                  (i32.load offset=16
                                    (local.get $l9)))))
                            (i32.store
                              (local.get $l2)
                              (i32.const 0))
                            (br $B5))
                          (local.set $l5
                            (i32.const -1))
                          (br_if $B14
                            (i32.gt_u
                              (local.get $p0)
                              (i32.const -65)))
                          (local.set $l5
                            (i32.and
                              (local.tee $l4
                                (i32.add
                                  (local.get $p0)
                                  (i32.const 19)))
                              (i32.const -16)))
                          (br_if $B14
                            (i32.eqz
                              (local.tee $l10
                                (i32.load offset=1288
                                  (i32.const 0)))))
                          (local.set $l8
                            (i32.const 0))
                          (block $B31
                            (br_if $B31
                              (i32.lt_u
                                (local.get $l5)
                                (i32.const 256)))
                            (local.set $l8
                              (i32.const 31))
                            (br_if $B31
                              (i32.gt_u
                                (local.get $l5)
                                (i32.const 16777215)))
                            (local.set $l8
                              (i32.add
                                (i32.or
                                  (i32.shl
                                    (local.tee $l4
                                      (i32.sub
                                        (i32.shr_u
                                          (i32.shl
                                            (local.tee $l6
                                              (i32.shl
                                                (local.tee $l3
                                                  (i32.shl
                                                    (local.tee $l4
                                                      (i32.shr_u
                                                        (local.get $l4)
                                                        (i32.const 8)))
                                                    (local.tee $l4
                                                      (i32.and
                                                        (i32.shr_u
                                                          (i32.add
                                                            (local.get $l4)
                                                            (i32.const 1048320))
                                                          (i32.const 16))
                                                        (i32.const 8)))))
                                                (local.tee $l3
                                                  (i32.and
                                                    (i32.shr_u
                                                      (i32.add
                                                        (local.get $l3)
                                                        (i32.const 520192))
                                                      (i32.const 16))
                                                    (i32.const 4)))))
                                            (local.tee $l6
                                              (i32.and
                                                (i32.shr_u
                                                  (i32.add
                                                    (local.get $l6)
                                                    (i32.const 245760))
                                                  (i32.const 16))
                                                (i32.const 2))))
                                          (i32.const 15))
                                        (i32.or
                                          (i32.or
                                            (local.get $l4)
                                            (local.get $l3))
                                          (local.get $l6))))
                                    (i32.const 1))
                                  (i32.and
                                    (i32.shr_u
                                      (local.get $l5)
                                      (i32.add
                                        (local.get $l4)
                                        (i32.const 21)))
                                    (i32.const 1)))
                                (i32.const 28))))
                          (local.set $l3
                            (i32.sub
                              (i32.const 0)
                              (local.get $l5)))
                          (block $B32
                            (block $B33
                              (block $B34
                                (block $B35
                                  (br_if $B35
                                    (local.tee $l6
                                      (i32.load
                                        (i32.add
                                          (i32.shl
                                            (local.get $l8)
                                            (i32.const 2))
                                          (i32.const 1588)))))
                                  (local.set $l4
                                    (i32.const 0))
                                  (local.set $l9
                                    (i32.const 0))
                                  (br $B34))
                                (local.set $l4
                                  (i32.const 0))
                                (local.set $p0
                                  (i32.shl
                                    (local.get $l5)
                                    (select
                                      (i32.const 0)
                                      (i32.sub
                                        (i32.const 25)
                                        (i32.shr_u
                                          (local.get $l8)
                                          (i32.const 1)))
                                      (i32.eq
                                        (local.get $l8)
                                        (i32.const 31)))))
                                (local.set $l9
                                  (i32.const 0))
                                (loop $L36
                                  (block $B37
                                    (br_if $B37
                                      (i32.ge_u
                                        (local.tee $l7
                                          (i32.sub
                                            (i32.and
                                              (i32.load offset=4
                                                (local.get $l6))
                                              (i32.const -8))
                                            (local.get $l5)))
                                        (local.get $l3)))
                                    (local.set $l3
                                      (local.get $l7))
                                    (local.set $l9
                                      (local.get $l6))
                                    (br_if $B37
                                      (local.get $l7))
                                    (local.set $l3
                                      (i32.const 0))
                                    (local.set $l9
                                      (local.get $l6))
                                    (local.set $l4
                                      (local.get $l6))
                                    (br $B33))
                                  (local.set $l4
                                    (select
                                      (select
                                        (local.get $l4)
                                        (local.tee $l7
                                          (i32.load
                                            (i32.add
                                              (local.get $l6)
                                              (i32.const 20))))
                                        (i32.eq
                                          (local.get $l7)
                                          (local.tee $l6
                                            (i32.load
                                              (i32.add
                                                (i32.add
                                                  (local.get $l6)
                                                  (i32.and
                                                    (i32.shr_u
                                                      (local.get $p0)
                                                      (i32.const 29))
                                                    (i32.const 4)))
                                                (i32.const 16))))))
                                      (local.get $l4)
                                      (local.get $l7)))
                                  (local.set $p0
                                    (i32.shl
                                      (local.get $p0)
                                      (i32.const 1)))
                                  (br_if $L36
                                    (local.get $l6))))
                              (block $B38
                                (br_if $B38
                                  (i32.or
                                    (local.get $l4)
                                    (local.get $l9)))
                                (local.set $l9
                                  (i32.const 0))
                                (br_if $B14
                                  (i32.eqz
                                    (local.tee $l4
                                      (i32.and
                                        (i32.or
                                          (local.tee $l4
                                            (i32.shl
                                              (i32.const 2)
                                              (local.get $l8)))
                                          (i32.sub
                                            (i32.const 0)
                                            (local.get $l4)))
                                        (local.get $l10)))))
                                (local.set $l4
                                  (i32.load
                                    (i32.add
                                      (i32.shl
                                        (i32.add
                                          (i32.or
                                            (i32.or
                                              (i32.or
                                                (i32.or
                                                  (local.tee $p0
                                                    (i32.and
                                                      (i32.shr_u
                                                        (local.tee $l6
                                                          (i32.shr_u
                                                            (local.tee $l4
                                                              (i32.add
                                                                (i32.and
                                                                  (local.get $l4)
                                                                  (i32.sub
                                                                    (i32.const 0)
                                                                    (local.get $l4)))
                                                                (i32.const -1)))
                                                            (local.tee $l4
                                                              (i32.and
                                                                (i32.shr_u
                                                                  (local.get $l4)
                                                                  (i32.const 12))
                                                                (i32.const 16)))))
                                                        (i32.const 5))
                                                      (i32.const 8)))
                                                  (local.get $l4))
                                                (local.tee $l6
                                                  (i32.and
                                                    (i32.shr_u
                                                      (local.tee $l4
                                                        (i32.shr_u
                                                          (local.get $l6)
                                                          (local.get $p0)))
                                                      (i32.const 2))
                                                    (i32.const 4))))
                                              (local.tee $l6
                                                (i32.and
                                                  (i32.shr_u
                                                    (local.tee $l4
                                                      (i32.shr_u
                                                        (local.get $l4)
                                                        (local.get $l6)))
                                                    (i32.const 1))
                                                  (i32.const 2))))
                                            (local.tee $l6
                                              (i32.and
                                                (i32.shr_u
                                                  (local.tee $l4
                                                    (i32.shr_u
                                                      (local.get $l4)
                                                      (local.get $l6)))
                                                  (i32.const 1))
                                                (i32.const 1))))
                                          (i32.shr_u
                                            (local.get $l4)
                                            (local.get $l6)))
                                        (i32.const 2))
                                      (i32.const 1588)))))
                              (br_if $B32
                                (i32.eqz
                                  (local.get $l4))))
                            (loop $L39
                              (local.set $p0
                                (i32.lt_u
                                  (local.tee $l7
                                    (i32.sub
                                      (i32.and
                                        (i32.load offset=4
                                          (local.get $l4))
                                        (i32.const -8))
                                      (local.get $l5)))
                                  (local.get $l3)))
                              (block $B40
                                (br_if $B40
                                  (local.tee $l6
                                    (i32.load offset=16
                                      (local.get $l4))))
                                (local.set $l6
                                  (i32.load
                                    (i32.add
                                      (local.get $l4)
                                      (i32.const 20)))))
                              (local.set $l3
                                (select
                                  (local.get $l7)
                                  (local.get $l3)
                                  (local.get $p0)))
                              (local.set $l9
                                (select
                                  (local.get $l4)
                                  (local.get $l9)
                                  (local.get $p0)))
                              (local.set $l4
                                (local.get $l6))
                              (br_if $L39
                                (local.get $l6))))
                          (br_if $B14
                            (i32.eqz
                              (local.get $l9)))
                          (br_if $B14
                            (i32.ge_u
                              (local.get $l3)
                              (i32.sub
                                (i32.load offset=1292
                                  (i32.const 0))
                                (local.get $l5))))
                          (local.set $l2
                            (i32.load offset=24
                              (local.get $l9)))
                          (block $B41
                            (br_if $B41
                              (i32.eq
                                (local.tee $p0
                                  (i32.load offset=12
                                    (local.get $l9)))
                                (local.get $l9)))
                            (drop
                              (i32.lt_u
                                (local.tee $l4
                                  (i32.load offset=8
                                    (local.get $l9)))
                                (i32.load offset=1300
                                  (i32.const 0))))
                            (i32.store offset=8
                              (local.get $p0)
                              (local.get $l4))
                            (i32.store offset=12
                              (local.get $l4)
                              (local.get $p0))
                            (br $B6))
                          (block $B42
                            (br_if $B42
                              (local.tee $l4
                                (i32.load
                                  (local.tee $l6
                                    (i32.add
                                      (local.get $l9)
                                      (i32.const 20))))))
                            (br_if $B12
                              (i32.eqz
                                (local.tee $l4
                                  (i32.load offset=16
                                    (local.get $l9)))))
                            (local.set $l6
                              (i32.add
                                (local.get $l9)
                                (i32.const 16))))
                          (loop $L43
                            (local.set $l7
                              (local.get $l6))
                            (br_if $L43
                              (local.tee $l4
                                (i32.load
                                  (local.tee $l6
                                    (i32.add
                                      (local.tee $p0
                                        (local.get $l4))
                                      (i32.const 20))))))
                            (local.set $l6
                              (i32.add
                                (local.get $p0)
                                (i32.const 16)))
                            (br_if $L43
                              (local.tee $l4
                                (i32.load offset=16
                                  (local.get $p0)))))
                          (i32.store
                            (local.get $l7)
                            (i32.const 0))
                          (br $B6))
                        (block $B44
                          (br_if $B44
                            (i32.lt_u
                              (local.tee $l4
                                (i32.load offset=1292
                                  (i32.const 0)))
                              (local.get $l5)))
                          (local.set $l3
                            (i32.load offset=1304
                              (i32.const 0)))
                          (block $B45
                            (block $B46
                              (br_if $B46
                                (i32.lt_u
                                  (local.tee $l6
                                    (i32.sub
                                      (local.get $l4)
                                      (local.get $l5)))
                                  (i32.const 16)))
                              (i32.store offset=4
                                (local.tee $p0
                                  (i32.add
                                    (local.get $l3)
                                    (local.get $l5)))
                                (i32.or
                                  (local.get $l6)
                                  (i32.const 1)))
                              (i32.store offset=1292
                                (i32.const 0)
                                (local.get $l6))
                              (i32.store offset=1304
                                (i32.const 0)
                                (local.get $p0))
                              (i32.store
                                (i32.add
                                  (local.get $l3)
                                  (local.get $l4))
                                (local.get $l6))
                              (i32.store offset=4
                                (local.get $l3)
                                (i32.or
                                  (local.get $l5)
                                  (i32.const 3)))
                              (br $B45))
                            (i32.store offset=4
                              (local.get $l3)
                              (i32.or
                                (local.get $l4)
                                (i32.const 3)))
                            (i32.store offset=4
                              (local.tee $l4
                                (i32.add
                                  (local.get $l3)
                                  (local.get $l4)))
                              (i32.or
                                (i32.load offset=4
                                  (local.get $l4))
                                (i32.const 1)))
                            (i32.store offset=1304
                              (i32.const 0)
                              (i32.const 0))
                            (i32.store offset=1292
                              (i32.const 0)
                              (i32.const 0)))
                          (local.set $l4
                            (i32.add
                              (local.get $l3)
                              (i32.const 8)))
                          (br $B4))
                        (block $B47
                          (br_if $B47
                            (i32.le_u
                              (local.tee $l6
                                (i32.load offset=1296
                                  (i32.const 0)))
                              (local.get $l5)))
                          (i32.store offset=4
                            (local.tee $l4
                              (i32.add
                                (local.get $l2)
                                (local.get $l5)))
                            (i32.or
                              (local.tee $l3
                                (i32.sub
                                  (local.get $l6)
                                  (local.get $l5)))
                              (i32.const 1)))
                          (i32.store offset=1308
                            (i32.const 0)
                            (local.get $l4))
                          (i32.store offset=1296
                            (i32.const 0)
                            (local.get $l3))
                          (i32.store offset=4
                            (local.get $l2)
                            (i32.or
                              (local.get $l5)
                              (i32.const 3)))
                          (local.set $l4
                            (i32.add
                              (local.get $l2)
                              (i32.const 8)))
                          (br $B4))
                        (block $B48
                          (block $B49
                            (br_if $B49
                              (i32.eqz
                                (i32.load offset=1756
                                  (i32.const 0))))
                            (local.set $l3
                              (i32.load offset=1764
                                (i32.const 0)))
                            (br $B48))
                          (i64.store offset=1768 align=4
                            (i32.const 0)
                            (i64.const -1))
                          (i64.store offset=1760 align=4
                            (i32.const 0)
                            (i64.const 281474976776192))
                          (i32.store offset=1756
                            (i32.const 0)
                            (i32.xor
                              (i32.and
                                (i32.add
                                  (local.get $l1)
                                  (i32.const 12))
                                (i32.const -16))
                              (i32.const 1431655768)))
                          (i32.store offset=1776
                            (i32.const 0)
                            (i32.const 0))
                          (i32.store offset=1728
                            (i32.const 0)
                            (i32.const 0))
                          (local.set $l3
                            (i32.const 65536)))
                        (local.set $l4
                          (i32.const 0))
                        (block $B50
                          (br_if $B50
                            (i32.gt_u
                              (local.tee $l9
                                (i32.and
                                  (local.tee $p0
                                    (i32.add
                                      (local.get $l3)
                                      (local.tee $l8
                                        (i32.add
                                          (local.get $l5)
                                          (i32.const 71)))))
                                  (local.tee $l7
                                    (i32.sub
                                      (i32.const 0)
                                      (local.get $l3)))))
                              (local.get $l5)))
                          (i32.store offset=1780
                            (i32.const 0)
                            (i32.const 48))
                          (br $B4))
                        (block $B51
                          (br_if $B51
                            (i32.eqz
                              (local.tee $l4
                                (i32.load offset=1724
                                  (i32.const 0)))))
                          (block $B52
                            (br_if $B52
                              (i32.le_u
                                (local.tee $l10
                                  (i32.add
                                    (local.tee $l3
                                      (i32.load offset=1716
                                        (i32.const 0)))
                                    (local.get $l9)))
                                (local.get $l3)))
                            (br_if $B51
                              (i32.le_u
                                (local.get $l10)
                                (local.get $l4))))
                          (local.set $l4
                            (i32.const 0))
                          (i32.store offset=1780
                            (i32.const 0)
                            (i32.const 48))
                          (br $B4))
                        (br_if $B9
                          (i32.and
                            (i32.load8_u offset=1728
                              (i32.const 0))
                            (i32.const 4)))
                        (block $B53
                          (block $B54
                            (block $B55
                              (br_if $B55
                                (i32.eqz
                                  (local.get $l2)))
                              (local.set $l4
                                (i32.const 1732))
                              (loop $L56
                                (block $B57
                                  (br_if $B57
                                    (i32.gt_u
                                      (local.tee $l3
                                        (i32.load
                                          (local.get $l4)))
                                      (local.get $l2)))
                                  (br_if $B54
                                    (i32.gt_u
                                      (i32.add
                                        (local.get $l3)
                                        (i32.load offset=4
                                          (local.get $l4)))
                                      (local.get $l2))))
                                (br_if $L56
                                  (local.tee $l4
                                    (i32.load offset=8
                                      (local.get $l4))))))
                            (br_if $B10
                              (i32.eq
                                (local.tee $p0
                                  (call $sbrk
                                    (i32.const 0)))
                                (i32.const -1)))
                            (local.set $l7
                              (local.get $l9))
                            (block $B58
                              (br_if $B58
                                (i32.eqz
                                  (i32.and
                                    (local.tee $l3
                                      (i32.add
                                        (local.tee $l4
                                          (i32.load offset=1760
                                            (i32.const 0)))
                                        (i32.const -1)))
                                    (local.get $p0))))
                              (local.set $l7
                                (i32.add
                                  (i32.sub
                                    (local.get $l9)
                                    (local.get $p0))
                                  (i32.and
                                    (i32.add
                                      (local.get $l3)
                                      (local.get $p0))
                                    (i32.sub
                                      (i32.const 0)
                                      (local.get $l4))))))
                            (br_if $B10
                              (i32.le_u
                                (local.get $l7)
                                (local.get $l5)))
                            (br_if $B10
                              (i32.gt_u
                                (local.get $l7)
                                (i32.const 2147483646)))
                            (block $B59
                              (br_if $B59
                                (i32.eqz
                                  (local.tee $l4
                                    (i32.load offset=1724
                                      (i32.const 0)))))
                              (br_if $B10
                                (i32.le_u
                                  (local.tee $l6
                                    (i32.add
                                      (local.tee $l3
                                        (i32.load offset=1716
                                          (i32.const 0)))
                                      (local.get $l7)))
                                  (local.get $l3)))
                              (br_if $B10
                                (i32.gt_u
                                  (local.get $l6)
                                  (local.get $l4))))
                            (br_if $B53
                              (i32.ne
                                (local.tee $l4
                                  (call $sbrk
                                    (local.get $l7)))
                                (local.get $p0)))
                            (br $B8))
                          (br_if $B10
                            (i32.gt_u
                              (local.tee $l7
                                (i32.and
                                  (i32.sub
                                    (local.get $p0)
                                    (local.get $l6))
                                  (local.get $l7)))
                              (i32.const 2147483646)))
                          (br_if $B11
                            (i32.eq
                              (local.tee $p0
                                (call $sbrk
                                  (local.get $l7)))
                              (i32.add
                                (i32.load
                                  (local.get $l4))
                                (i32.load offset=4
                                  (local.get $l4)))))
                          (local.set $l4
                            (local.get $p0)))
                        (block $B60
                          (br_if $B60
                            (i32.eq
                              (local.get $l4)
                              (i32.const -1)))
                          (br_if $B60
                            (i32.le_u
                              (i32.add
                                (local.get $l5)
                                (i32.const 72))
                              (local.get $l7)))
                          (block $B61
                            (br_if $B61
                              (i32.le_u
                                (local.tee $l3
                                  (i32.and
                                    (i32.add
                                      (i32.sub
                                        (local.get $l8)
                                        (local.get $l7))
                                      (local.tee $l3
                                        (i32.load offset=1764
                                          (i32.const 0))))
                                    (i32.sub
                                      (i32.const 0)
                                      (local.get $l3))))
                                (i32.const 2147483646)))
                            (local.set $p0
                              (local.get $l4))
                            (br $B8))
                          (block $B62
                            (br_if $B62
                              (i32.eq
                                (call $sbrk
                                  (local.get $l3))
                                (i32.const -1)))
                            (local.set $l7
                              (i32.add
                                (local.get $l3)
                                (local.get $l7)))
                            (local.set $p0
                              (local.get $l4))
                            (br $B8))
                          (drop
                            (call $sbrk
                              (i32.sub
                                (i32.const 0)
                                (local.get $l7))))
                          (br $B10))
                        (local.set $p0
                          (local.get $l4))
                        (br_if $B8
                          (i32.ne
                            (local.get $l4)
                            (i32.const -1)))
                        (br $B10))
                      (local.set $l9
                        (i32.const 0))
                      (br $B5))
                    (local.set $p0
                      (i32.const 0))
                    (br $B6))
                  (br_if $B8
                    (i32.ne
                      (local.get $p0)
                      (i32.const -1))))
                (i32.store offset=1728
                  (i32.const 0)
                  (i32.or
                    (i32.load offset=1728
                      (i32.const 0))
                    (i32.const 4))))
              (br_if $B7
                (i32.gt_u
                  (local.get $l9)
                  (i32.const 2147483646)))
              (local.set $p0
                (call $sbrk
                  (local.get $l9)))
              (local.set $l4
                (call $sbrk
                  (i32.const 0)))
              (br_if $B7
                (i32.eq
                  (local.get $p0)
                  (i32.const -1)))
              (br_if $B7
                (i32.eq
                  (local.get $l4)
                  (i32.const -1)))
              (br_if $B7
                (i32.ge_u
                  (local.get $p0)
                  (local.get $l4)))
              (br_if $B7
                (i32.le_u
                  (local.tee $l7
                    (i32.sub
                      (local.get $l4)
                      (local.get $p0)))
                  (i32.add
                    (local.get $l5)
                    (i32.const 56)))))
            (i32.store offset=1716
              (i32.const 0)
              (local.tee $l4
                (i32.add
                  (i32.load offset=1716
                    (i32.const 0))
                  (local.get $l7))))
            (block $B63
              (br_if $B63
                (i32.le_u
                  (local.get $l4)
                  (i32.load offset=1720
                    (i32.const 0))))
              (i32.store offset=1720
                (i32.const 0)
                (local.get $l4)))
            (block $B64
              (block $B65
                (block $B66
                  (block $B67
                    (br_if $B67
                      (i32.eqz
                        (local.tee $l3
                          (i32.load offset=1308
                            (i32.const 0)))))
                    (local.set $l4
                      (i32.const 1732))
                    (loop $L68
                      (br_if $B66
                        (i32.eq
                          (local.get $p0)
                          (i32.add
                            (local.tee $l6
                              (i32.load
                                (local.get $l4)))
                            (local.tee $l9
                              (i32.load offset=4
                                (local.get $l4))))))
                      (br_if $L68
                        (local.tee $l4
                          (i32.load offset=8
                            (local.get $l4))))
                      (br $B65)))
                  (block $B69
                    (block $B70
                      (br_if $B70
                        (i32.eqz
                          (local.tee $l4
                            (i32.load offset=1300
                              (i32.const 0)))))
                      (br_if $B69
                        (i32.ge_u
                          (local.get $p0)
                          (local.get $l4))))
                    (i32.store offset=1300
                      (i32.const 0)
                      (local.get $p0)))
                  (local.set $l4
                    (i32.const 0))
                  (i32.store offset=1736
                    (i32.const 0)
                    (local.get $l7))
                  (i32.store offset=1732
                    (i32.const 0)
                    (local.get $p0))
                  (i32.store offset=1316
                    (i32.const 0)
                    (i32.const -1))
                  (i32.store offset=1320
                    (i32.const 0)
                    (i32.load offset=1756
                      (i32.const 0)))
                  (i32.store offset=1744
                    (i32.const 0)
                    (i32.const 0))
                  (loop $L71
                    (i32.store
                      (i32.add
                        (local.get $l4)
                        (i32.const 1344))
                      (local.tee $l3
                        (i32.add
                          (local.get $l4)
                          (i32.const 1332))))
                    (i32.store
                      (local.get $l3)
                      (local.tee $l6
                        (i32.add
                          (local.get $l4)
                          (i32.const 1324))))
                    (i32.store
                      (i32.add
                        (local.get $l4)
                        (i32.const 1336))
                      (local.get $l6))
                    (i32.store
                      (i32.add
                        (local.get $l4)
                        (i32.const 1352))
                      (local.tee $l6
                        (i32.add
                          (local.get $l4)
                          (i32.const 1340))))
                    (i32.store
                      (local.get $l6)
                      (local.get $l3))
                    (i32.store
                      (i32.add
                        (local.get $l4)
                        (i32.const 1360))
                      (local.tee $l3
                        (i32.add
                          (local.get $l4)
                          (i32.const 1348))))
                    (i32.store
                      (local.get $l3)
                      (local.get $l6))
                    (i32.store
                      (i32.add
                        (local.get $l4)
                        (i32.const 1356))
                      (local.get $l3))
                    (br_if $L71
                      (i32.ne
                        (local.tee $l4
                          (i32.add
                            (local.get $l4)
                            (i32.const 32)))
                        (i32.const 256))))
                  (i32.store offset=4
                    (local.tee $l3
                      (i32.add
                        (local.get $p0)
                        (local.tee $l4
                          (select
                            (i32.and
                              (i32.sub
                                (i32.const -8)
                                (local.get $p0))
                              (i32.const 15))
                            (i32.const 0)
                            (i32.and
                              (i32.add
                                (local.get $p0)
                                (i32.const 8))
                              (i32.const 15))))))
                    (i32.or
                      (local.tee $l4
                        (i32.sub
                          (local.tee $l6
                            (i32.add
                              (local.get $l7)
                              (i32.const -56)))
                          (local.get $l4)))
                      (i32.const 1)))
                  (i32.store offset=1312
                    (i32.const 0)
                    (i32.load offset=1772
                      (i32.const 0)))
                  (i32.store offset=1296
                    (i32.const 0)
                    (local.get $l4))
                  (i32.store offset=1308
                    (i32.const 0)
                    (local.get $l3))
                  (i32.store offset=4
                    (i32.add
                      (local.get $p0)
                      (local.get $l6))
                    (i32.const 56))
                  (br $B64))
                (br_if $B65
                  (i32.and
                    (i32.load8_u offset=12
                      (local.get $l4))
                    (i32.const 8)))
                (br_if $B65
                  (i32.lt_u
                    (local.get $l3)
                    (local.get $l6)))
                (br_if $B65
                  (i32.ge_u
                    (local.get $l3)
                    (local.get $p0)))
                (i32.store offset=4
                  (local.tee $p0
                    (i32.add
                      (local.get $l3)
                      (local.tee $l6
                        (select
                          (i32.and
                            (i32.sub
                              (i32.const -8)
                              (local.get $l3))
                            (i32.const 15))
                          (i32.const 0)
                          (i32.and
                            (i32.add
                              (local.get $l3)
                              (i32.const 8))
                            (i32.const 15))))))
                  (i32.or
                    (local.tee $l6
                      (i32.sub
                        (local.tee $l2
                          (i32.add
                            (i32.load offset=1296
                              (i32.const 0))
                            (local.get $l7)))
                        (local.get $l6)))
                    (i32.const 1)))
                (i32.store offset=4
                  (local.get $l4)
                  (i32.add
                    (local.get $l9)
                    (local.get $l7)))
                (i32.store offset=1312
                  (i32.const 0)
                  (i32.load offset=1772
                    (i32.const 0)))
                (i32.store offset=1296
                  (i32.const 0)
                  (local.get $l6))
                (i32.store offset=1308
                  (i32.const 0)
                  (local.get $p0))
                (i32.store offset=4
                  (i32.add
                    (local.get $l3)
                    (local.get $l2))
                  (i32.const 56))
                (br $B64))
              (block $B72
                (br_if $B72
                  (i32.ge_u
                    (local.get $p0)
                    (local.tee $l9
                      (i32.load offset=1300
                        (i32.const 0)))))
                (i32.store offset=1300
                  (i32.const 0)
                  (local.get $p0))
                (local.set $l9
                  (local.get $p0)))
              (local.set $l6
                (i32.add
                  (local.get $p0)
                  (local.get $l7)))
              (local.set $l4
                (i32.const 1732))
              (block $B73
                (block $B74
                  (block $B75
                    (block $B76
                      (block $B77
                        (block $B78
                          (block $B79
                            (loop $L80
                              (br_if $B79
                                (i32.eq
                                  (i32.load
                                    (local.get $l4))
                                  (local.get $l6)))
                              (br_if $L80
                                (local.tee $l4
                                  (i32.load offset=8
                                    (local.get $l4))))
                              (br $B78)))
                          (br_if $B77
                            (i32.eqz
                              (i32.and
                                (i32.load8_u offset=12
                                  (local.get $l4))
                                (i32.const 8)))))
                        (local.set $l4
                          (i32.const 1732))
                        (loop $L81
                          (block $B82
                            (br_if $B82
                              (i32.gt_u
                                (local.tee $l6
                                  (i32.load
                                    (local.get $l4)))
                                (local.get $l3)))
                            (br_if $B76
                              (i32.gt_u
                                (local.tee $l6
                                  (i32.add
                                    (local.get $l6)
                                    (i32.load offset=4
                                      (local.get $l4))))
                                (local.get $l3))))
                          (local.set $l4
                            (i32.load offset=8
                              (local.get $l4)))
                          (br $L81)))
                      (i32.store
                        (local.get $l4)
                        (local.get $p0))
                      (i32.store offset=4
                        (local.get $l4)
                        (i32.add
                          (i32.load offset=4
                            (local.get $l4))
                          (local.get $l7)))
                      (i32.store offset=4
                        (local.tee $l2
                          (i32.add
                            (local.get $p0)
                            (select
                              (i32.and
                                (i32.sub
                                  (i32.const -8)
                                  (local.get $p0))
                                (i32.const 15))
                              (i32.const 0)
                              (i32.and
                                (i32.add
                                  (local.get $p0)
                                  (i32.const 8))
                                (i32.const 15)))))
                        (i32.or
                          (local.get $l5)
                          (i32.const 3)))
                      (local.set $l4
                        (i32.sub
                          (local.tee $l7
                            (i32.add
                              (local.get $l6)
                              (select
                                (i32.and
                                  (i32.sub
                                    (i32.const -8)
                                    (local.get $l6))
                                  (i32.const 15))
                                (i32.const 0)
                                (i32.and
                                  (i32.add
                                    (local.get $l6)
                                    (i32.const 8))
                                  (i32.const 15)))))
                          (local.tee $l5
                            (i32.add
                              (local.get $l2)
                              (local.get $l5)))))
                      (block $B83
                        (br_if $B83
                          (i32.ne
                            (local.get $l7)
                            (local.get $l3)))
                        (i32.store offset=1308
                          (i32.const 0)
                          (local.get $l5))
                        (i32.store offset=1296
                          (i32.const 0)
                          (local.tee $l4
                            (i32.add
                              (i32.load offset=1296
                                (i32.const 0))
                              (local.get $l4))))
                        (i32.store offset=4
                          (local.get $l5)
                          (i32.or
                            (local.get $l4)
                            (i32.const 1)))
                        (br $B74))
                      (block $B84
                        (br_if $B84
                          (i32.ne
                            (local.get $l7)
                            (i32.load offset=1304
                              (i32.const 0))))
                        (i32.store offset=1304
                          (i32.const 0)
                          (local.get $l5))
                        (i32.store offset=1292
                          (i32.const 0)
                          (local.tee $l4
                            (i32.add
                              (i32.load offset=1292
                                (i32.const 0))
                              (local.get $l4))))
                        (i32.store offset=4
                          (local.get $l5)
                          (i32.or
                            (local.get $l4)
                            (i32.const 1)))
                        (i32.store
                          (i32.add
                            (local.get $l5)
                            (local.get $l4))
                          (local.get $l4))
                        (br $B74))
                      (block $B85
                        (br_if $B85
                          (i32.ne
                            (i32.and
                              (local.tee $l3
                                (i32.load offset=4
                                  (local.get $l7)))
                              (i32.const 3))
                            (i32.const 1)))
                        (local.set $l8
                          (i32.and
                            (local.get $l3)
                            (i32.const -8)))
                        (block $B86
                          (block $B87
                            (br_if $B87
                              (i32.gt_u
                                (local.get $l3)
                                (i32.const 255)))
                            (drop
                              (i32.eq
                                (local.tee $l6
                                  (i32.load offset=8
                                    (local.get $l7)))
                                (local.tee $p0
                                  (i32.add
                                    (i32.shl
                                      (local.tee $l9
                                        (i32.shr_u
                                          (local.get $l3)
                                          (i32.const 3)))
                                      (i32.const 3))
                                    (i32.const 1324)))))
                            (block $B88
                              (br_if $B88
                                (i32.ne
                                  (local.tee $l3
                                    (i32.load offset=12
                                      (local.get $l7)))
                                  (local.get $l6)))
                              (i32.store offset=1284
                                (i32.const 0)
                                (i32.and
                                  (i32.load offset=1284
                                    (i32.const 0))
                                  (i32.rotl
                                    (i32.const -2)
                                    (local.get $l9))))
                              (br $B86))
                            (drop
                              (i32.eq
                                (local.get $l3)
                                (local.get $p0)))
                            (i32.store offset=8
                              (local.get $l3)
                              (local.get $l6))
                            (i32.store offset=12
                              (local.get $l6)
                              (local.get $l3))
                            (br $B86))
                          (local.set $l10
                            (i32.load offset=24
                              (local.get $l7)))
                          (block $B89
                            (block $B90
                              (br_if $B90
                                (i32.eq
                                  (local.tee $p0
                                    (i32.load offset=12
                                      (local.get $l7)))
                                  (local.get $l7)))
                              (drop
                                (i32.lt_u
                                  (local.tee $l3
                                    (i32.load offset=8
                                      (local.get $l7)))
                                  (local.get $l9)))
                              (i32.store offset=8
                                (local.get $p0)
                                (local.get $l3))
                              (i32.store offset=12
                                (local.get $l3)
                                (local.get $p0))
                              (br $B89))
                            (block $B91
                              (br_if $B91
                                (local.tee $l6
                                  (i32.load
                                    (local.tee $l3
                                      (i32.add
                                        (local.get $l7)
                                        (i32.const 20))))))
                              (br_if $B91
                                (local.tee $l6
                                  (i32.load
                                    (local.tee $l3
                                      (i32.add
                                        (local.get $l7)
                                        (i32.const 16))))))
                              (local.set $p0
                                (i32.const 0))
                              (br $B89))
                            (loop $L92
                              (local.set $l9
                                (local.get $l3))
                              (br_if $L92
                                (local.tee $l6
                                  (i32.load
                                    (local.tee $l3
                                      (i32.add
                                        (local.tee $p0
                                          (local.get $l6))
                                        (i32.const 20))))))
                              (local.set $l3
                                (i32.add
                                  (local.get $p0)
                                  (i32.const 16)))
                              (br_if $L92
                                (local.tee $l6
                                  (i32.load offset=16
                                    (local.get $p0)))))
                            (i32.store
                              (local.get $l9)
                              (i32.const 0)))
                          (br_if $B86
                            (i32.eqz
                              (local.get $l10)))
                          (block $B93
                            (block $B94
                              (br_if $B94
                                (i32.ne
                                  (local.get $l7)
                                  (i32.load
                                    (local.tee $l3
                                      (i32.add
                                        (i32.shl
                                          (local.tee $l6
                                            (i32.load offset=28
                                              (local.get $l7)))
                                          (i32.const 2))
                                        (i32.const 1588))))))
                              (i32.store
                                (local.get $l3)
                                (local.get $p0))
                              (br_if $B93
                                (local.get $p0))
                              (i32.store offset=1288
                                (i32.const 0)
                                (i32.and
                                  (i32.load offset=1288
                                    (i32.const 0))
                                  (i32.rotl
                                    (i32.const -2)
                                    (local.get $l6))))
                              (br $B86))
                            (i32.store
                              (i32.add
                                (local.get $l10)
                                (select
                                  (i32.const 16)
                                  (i32.const 20)
                                  (i32.eq
                                    (i32.load offset=16
                                      (local.get $l10))
                                    (local.get $l7))))
                              (local.get $p0))
                            (br_if $B86
                              (i32.eqz
                                (local.get $p0))))
                          (i32.store offset=24
                            (local.get $p0)
                            (local.get $l10))
                          (block $B95
                            (br_if $B95
                              (i32.eqz
                                (local.tee $l3
                                  (i32.load offset=16
                                    (local.get $l7)))))
                            (i32.store offset=16
                              (local.get $p0)
                              (local.get $l3))
                            (i32.store offset=24
                              (local.get $l3)
                              (local.get $p0)))
                          (br_if $B86
                            (i32.eqz
                              (local.tee $l3
                                (i32.load offset=20
                                  (local.get $l7)))))
                          (i32.store
                            (i32.add
                              (local.get $p0)
                              (i32.const 20))
                            (local.get $l3))
                          (i32.store offset=24
                            (local.get $l3)
                            (local.get $p0)))
                        (local.set $l4
                          (i32.add
                            (local.get $l8)
                            (local.get $l4)))
                        (local.set $l3
                          (i32.load offset=4
                            (local.tee $l7
                              (i32.add
                                (local.get $l7)
                                (local.get $l8))))))
                      (i32.store offset=4
                        (local.get $l7)
                        (i32.and
                          (local.get $l3)
                          (i32.const -2)))
                      (i32.store
                        (i32.add
                          (local.get $l5)
                          (local.get $l4))
                        (local.get $l4))
                      (i32.store offset=4
                        (local.get $l5)
                        (i32.or
                          (local.get $l4)
                          (i32.const 1)))
                      (block $B96
                        (br_if $B96
                          (i32.gt_u
                            (local.get $l4)
                            (i32.const 255)))
                        (local.set $l3
                          (i32.add
                            (i32.and
                              (local.get $l4)
                              (i32.const -8))
                            (i32.const 1324)))
                        (block $B97
                          (block $B98
                            (br_if $B98
                              (i32.and
                                (local.tee $l6
                                  (i32.load offset=1284
                                    (i32.const 0)))
                                (local.tee $l4
                                  (i32.shl
                                    (i32.const 1)
                                    (i32.shr_u
                                      (local.get $l4)
                                      (i32.const 3))))))
                            (i32.store offset=1284
                              (i32.const 0)
                              (i32.or
                                (local.get $l6)
                                (local.get $l4)))
                            (local.set $l4
                              (local.get $l3))
                            (br $B97))
                          (local.set $l4
                            (i32.load offset=8
                              (local.get $l3))))
                        (i32.store offset=12
                          (local.get $l4)
                          (local.get $l5))
                        (i32.store offset=8
                          (local.get $l3)
                          (local.get $l5))
                        (i32.store offset=12
                          (local.get $l5)
                          (local.get $l3))
                        (i32.store offset=8
                          (local.get $l5)
                          (local.get $l4))
                        (br $B74))
                      (local.set $l3
                        (i32.const 31))
                      (block $B99
                        (br_if $B99
                          (i32.gt_u
                            (local.get $l4)
                            (i32.const 16777215)))
                        (local.set $l3
                          (i32.add
                            (i32.or
                              (i32.shl
                                (local.tee $l3
                                  (i32.sub
                                    (i32.shr_u
                                      (i32.shl
                                        (local.tee $p0
                                          (i32.shl
                                            (local.tee $l6
                                              (i32.shl
                                                (local.tee $l3
                                                  (i32.shr_u
                                                    (local.get $l4)
                                                    (i32.const 8)))
                                                (local.tee $l3
                                                  (i32.and
                                                    (i32.shr_u
                                                      (i32.add
                                                        (local.get $l3)
                                                        (i32.const 1048320))
                                                      (i32.const 16))
                                                    (i32.const 8)))))
                                            (local.tee $l6
                                              (i32.and
                                                (i32.shr_u
                                                  (i32.add
                                                    (local.get $l6)
                                                    (i32.const 520192))
                                                  (i32.const 16))
                                                (i32.const 4)))))
                                        (local.tee $p0
                                          (i32.and
                                            (i32.shr_u
                                              (i32.add
                                                (local.get $p0)
                                                (i32.const 245760))
                                              (i32.const 16))
                                            (i32.const 2))))
                                      (i32.const 15))
                                    (i32.or
                                      (i32.or
                                        (local.get $l3)
                                        (local.get $l6))
                                      (local.get $p0))))
                                (i32.const 1))
                              (i32.and
                                (i32.shr_u
                                  (local.get $l4)
                                  (i32.add
                                    (local.get $l3)
                                    (i32.const 21)))
                                (i32.const 1)))
                            (i32.const 28))))
                      (i32.store offset=28
                        (local.get $l5)
                        (local.get $l3))
                      (i64.store offset=16 align=4
                        (local.get $l5)
                        (i64.const 0))
                      (local.set $l6
                        (i32.add
                          (i32.shl
                            (local.get $l3)
                            (i32.const 2))
                          (i32.const 1588)))
                      (block $B100
                        (br_if $B100
                          (i32.and
                            (local.tee $p0
                              (i32.load offset=1288
                                (i32.const 0)))
                            (local.tee $l9
                              (i32.shl
                                (i32.const 1)
                                (local.get $l3)))))
                        (i32.store
                          (local.get $l6)
                          (local.get $l5))
                        (i32.store offset=1288
                          (i32.const 0)
                          (i32.or
                            (local.get $p0)
                            (local.get $l9)))
                        (i32.store offset=24
                          (local.get $l5)
                          (local.get $l6))
                        (i32.store offset=8
                          (local.get $l5)
                          (local.get $l5))
                        (i32.store offset=12
                          (local.get $l5)
                          (local.get $l5))
                        (br $B74))
                      (local.set $l3
                        (i32.shl
                          (local.get $l4)
                          (select
                            (i32.const 0)
                            (i32.sub
                              (i32.const 25)
                              (i32.shr_u
                                (local.get $l3)
                                (i32.const 1)))
                            (i32.eq
                              (local.get $l3)
                              (i32.const 31)))))
                      (local.set $p0
                        (i32.load
                          (local.get $l6)))
                      (loop $L101
                        (br_if $B75
                          (i32.eq
                            (i32.and
                              (i32.load offset=4
                                (local.tee $l6
                                  (local.get $p0)))
                              (i32.const -8))
                            (local.get $l4)))
                        (local.set $p0
                          (i32.shr_u
                            (local.get $l3)
                            (i32.const 29)))
                        (local.set $l3
                          (i32.shl
                            (local.get $l3)
                            (i32.const 1)))
                        (br_if $L101
                          (local.tee $p0
                            (i32.load
                              (local.tee $l9
                                (i32.add
                                  (i32.add
                                    (local.get $l6)
                                    (i32.and
                                      (local.get $p0)
                                      (i32.const 4)))
                                  (i32.const 16)))))))
                      (i32.store
                        (local.get $l9)
                        (local.get $l5))
                      (i32.store offset=24
                        (local.get $l5)
                        (local.get $l6))
                      (i32.store offset=12
                        (local.get $l5)
                        (local.get $l5))
                      (i32.store offset=8
                        (local.get $l5)
                        (local.get $l5))
                      (br $B74))
                    (i32.store offset=4
                      (local.tee $l2
                        (i32.add
                          (local.get $p0)
                          (local.tee $l4
                            (select
                              (i32.and
                                (i32.sub
                                  (i32.const -8)
                                  (local.get $p0))
                                (i32.const 15))
                              (i32.const 0)
                              (i32.and
                                (i32.add
                                  (local.get $p0)
                                  (i32.const 8))
                                (i32.const 15))))))
                      (i32.or
                        (local.tee $l4
                          (i32.sub
                            (local.tee $l9
                              (i32.add
                                (local.get $l7)
                                (i32.const -56)))
                            (local.get $l4)))
                        (i32.const 1)))
                    (i32.store offset=4
                      (i32.add
                        (local.get $p0)
                        (local.get $l9))
                      (i32.const 56))
                    (i32.store offset=4
                      (local.tee $l9
                        (select
                          (local.get $l3)
                          (local.tee $l9
                            (i32.add
                              (i32.add
                                (local.get $l6)
                                (select
                                  (i32.and
                                    (i32.sub
                                      (i32.const 55)
                                      (local.get $l6))
                                    (i32.const 15))
                                  (i32.const 0)
                                  (i32.and
                                    (i32.add
                                      (local.get $l6)
                                      (i32.const -55))
                                    (i32.const 15))))
                              (i32.const -63)))
                          (i32.lt_u
                            (local.get $l9)
                            (i32.add
                              (local.get $l3)
                              (i32.const 16)))))
                      (i32.const 35))
                    (i32.store offset=1312
                      (i32.const 0)
                      (i32.load offset=1772
                        (i32.const 0)))
                    (i32.store offset=1296
                      (i32.const 0)
                      (local.get $l4))
                    (i32.store offset=1308
                      (i32.const 0)
                      (local.get $l2))
                    (i64.store align=4
                      (i32.add
                        (local.get $l9)
                        (i32.const 16))
                      (i64.load offset=1740 align=4
                        (i32.const 0)))
                    (i64.store offset=8 align=4
                      (local.get $l9)
                      (i64.load offset=1732 align=4
                        (i32.const 0)))
                    (i32.store offset=1740
                      (i32.const 0)
                      (i32.add
                        (local.get $l9)
                        (i32.const 8)))
                    (i32.store offset=1736
                      (i32.const 0)
                      (local.get $l7))
                    (i32.store offset=1732
                      (i32.const 0)
                      (local.get $p0))
                    (i32.store offset=1744
                      (i32.const 0)
                      (i32.const 0))
                    (local.set $l4
                      (i32.add
                        (local.get $l9)
                        (i32.const 36)))
                    (loop $L102
                      (i32.store
                        (local.get $l4)
                        (i32.const 7))
                      (br_if $L102
                        (i32.lt_u
                          (local.tee $l4
                            (i32.add
                              (local.get $l4)
                              (i32.const 4)))
                          (local.get $l6))))
                    (br_if $B64
                      (i32.eq
                        (local.get $l9)
                        (local.get $l3)))
                    (i32.store offset=4
                      (local.get $l9)
                      (i32.and
                        (i32.load offset=4
                          (local.get $l9))
                        (i32.const -2)))
                    (i32.store
                      (local.get $l9)
                      (local.tee $p0
                        (i32.sub
                          (local.get $l9)
                          (local.get $l3))))
                    (i32.store offset=4
                      (local.get $l3)
                      (i32.or
                        (local.get $p0)
                        (i32.const 1)))
                    (block $B103
                      (br_if $B103
                        (i32.gt_u
                          (local.get $p0)
                          (i32.const 255)))
                      (local.set $l4
                        (i32.add
                          (i32.and
                            (local.get $p0)
                            (i32.const -8))
                          (i32.const 1324)))
                      (block $B104
                        (block $B105
                          (br_if $B105
                            (i32.and
                              (local.tee $l6
                                (i32.load offset=1284
                                  (i32.const 0)))
                              (local.tee $p0
                                (i32.shl
                                  (i32.const 1)
                                  (i32.shr_u
                                    (local.get $p0)
                                    (i32.const 3))))))
                          (i32.store offset=1284
                            (i32.const 0)
                            (i32.or
                              (local.get $l6)
                              (local.get $p0)))
                          (local.set $l6
                            (local.get $l4))
                          (br $B104))
                        (local.set $l6
                          (i32.load offset=8
                            (local.get $l4))))
                      (i32.store offset=12
                        (local.get $l6)
                        (local.get $l3))
                      (i32.store offset=8
                        (local.get $l4)
                        (local.get $l3))
                      (i32.store offset=12
                        (local.get $l3)
                        (local.get $l4))
                      (i32.store offset=8
                        (local.get $l3)
                        (local.get $l6))
                      (br $B64))
                    (local.set $l4
                      (i32.const 31))
                    (block $B106
                      (br_if $B106
                        (i32.gt_u
                          (local.get $p0)
                          (i32.const 16777215)))
                      (local.set $l4
                        (i32.add
                          (i32.or
                            (i32.shl
                              (local.tee $l4
                                (i32.sub
                                  (i32.shr_u
                                    (i32.shl
                                      (local.tee $l9
                                        (i32.shl
                                          (local.tee $l6
                                            (i32.shl
                                              (local.tee $l4
                                                (i32.shr_u
                                                  (local.get $p0)
                                                  (i32.const 8)))
                                              (local.tee $l4
                                                (i32.and
                                                  (i32.shr_u
                                                    (i32.add
                                                      (local.get $l4)
                                                      (i32.const 1048320))
                                                    (i32.const 16))
                                                  (i32.const 8)))))
                                          (local.tee $l6
                                            (i32.and
                                              (i32.shr_u
                                                (i32.add
                                                  (local.get $l6)
                                                  (i32.const 520192))
                                                (i32.const 16))
                                              (i32.const 4)))))
                                      (local.tee $l9
                                        (i32.and
                                          (i32.shr_u
                                            (i32.add
                                              (local.get $l9)
                                              (i32.const 245760))
                                            (i32.const 16))
                                          (i32.const 2))))
                                    (i32.const 15))
                                  (i32.or
                                    (i32.or
                                      (local.get $l4)
                                      (local.get $l6))
                                    (local.get $l9))))
                              (i32.const 1))
                            (i32.and
                              (i32.shr_u
                                (local.get $p0)
                                (i32.add
                                  (local.get $l4)
                                  (i32.const 21)))
                              (i32.const 1)))
                          (i32.const 28))))
                    (i32.store offset=28
                      (local.get $l3)
                      (local.get $l4))
                    (i64.store offset=16 align=4
                      (local.get $l3)
                      (i64.const 0))
                    (local.set $l6
                      (i32.add
                        (i32.shl
                          (local.get $l4)
                          (i32.const 2))
                        (i32.const 1588)))
                    (block $B107
                      (br_if $B107
                        (i32.and
                          (local.tee $l9
                            (i32.load offset=1288
                              (i32.const 0)))
                          (local.tee $l7
                            (i32.shl
                              (i32.const 1)
                              (local.get $l4)))))
                      (i32.store
                        (local.get $l6)
                        (local.get $l3))
                      (i32.store offset=1288
                        (i32.const 0)
                        (i32.or
                          (local.get $l9)
                          (local.get $l7)))
                      (i32.store offset=24
                        (local.get $l3)
                        (local.get $l6))
                      (i32.store offset=8
                        (local.get $l3)
                        (local.get $l3))
                      (i32.store offset=12
                        (local.get $l3)
                        (local.get $l3))
                      (br $B64))
                    (local.set $l4
                      (i32.shl
                        (local.get $p0)
                        (select
                          (i32.const 0)
                          (i32.sub
                            (i32.const 25)
                            (i32.shr_u
                              (local.get $l4)
                              (i32.const 1)))
                          (i32.eq
                            (local.get $l4)
                            (i32.const 31)))))
                    (local.set $l9
                      (i32.load
                        (local.get $l6)))
                    (loop $L108
                      (br_if $B73
                        (i32.eq
                          (i32.and
                            (i32.load offset=4
                              (local.tee $l6
                                (local.get $l9)))
                            (i32.const -8))
                          (local.get $p0)))
                      (local.set $l9
                        (i32.shr_u
                          (local.get $l4)
                          (i32.const 29)))
                      (local.set $l4
                        (i32.shl
                          (local.get $l4)
                          (i32.const 1)))
                      (br_if $L108
                        (local.tee $l9
                          (i32.load
                            (local.tee $l7
                              (i32.add
                                (i32.add
                                  (local.get $l6)
                                  (i32.and
                                    (local.get $l9)
                                    (i32.const 4)))
                                (i32.const 16)))))))
                    (i32.store
                      (local.get $l7)
                      (local.get $l3))
                    (i32.store offset=24
                      (local.get $l3)
                      (local.get $l6))
                    (i32.store offset=12
                      (local.get $l3)
                      (local.get $l3))
                    (i32.store offset=8
                      (local.get $l3)
                      (local.get $l3))
                    (br $B64))
                  (i32.store offset=12
                    (local.tee $l4
                      (i32.load offset=8
                        (local.get $l6)))
                    (local.get $l5))
                  (i32.store offset=8
                    (local.get $l6)
                    (local.get $l5))
                  (i32.store offset=24
                    (local.get $l5)
                    (i32.const 0))
                  (i32.store offset=12
                    (local.get $l5)
                    (local.get $l6))
                  (i32.store offset=8
                    (local.get $l5)
                    (local.get $l4)))
                (local.set $l4
                  (i32.add
                    (local.get $l2)
                    (i32.const 8)))
                (br $B4))
              (i32.store offset=12
                (local.tee $l4
                  (i32.load offset=8
                    (local.get $l6)))
                (local.get $l3))
              (i32.store offset=8
                (local.get $l6)
                (local.get $l3))
              (i32.store offset=24
                (local.get $l3)
                (i32.const 0))
              (i32.store offset=12
                (local.get $l3)
                (local.get $l6))
              (i32.store offset=8
                (local.get $l3)
                (local.get $l4)))
            (br_if $B7
              (i32.le_u
                (local.tee $l4
                  (i32.load offset=1296
                    (i32.const 0)))
                (local.get $l5)))
            (i32.store offset=4
              (local.tee $l6
                (i32.add
                  (local.tee $l3
                    (i32.load offset=1308
                      (i32.const 0)))
                  (local.get $l5)))
              (i32.or
                (local.tee $l4
                  (i32.sub
                    (local.get $l4)
                    (local.get $l5)))
                (i32.const 1)))
            (i32.store offset=1296
              (i32.const 0)
              (local.get $l4))
            (i32.store offset=1308
              (i32.const 0)
              (local.get $l6))
            (i32.store offset=4
              (local.get $l3)
              (i32.or
                (local.get $l5)
                (i32.const 3)))
            (local.set $l4
              (i32.add
                (local.get $l3)
                (i32.const 8)))
            (br $B4))
          (local.set $l4
            (i32.const 0))
          (i32.store offset=1780
            (i32.const 0)
            (i32.const 48))
          (br $B4))
        (block $B109
          (br_if $B109
            (i32.eqz
              (local.get $l2)))
          (block $B110
            (block $B111
              (br_if $B111
                (i32.ne
                  (local.get $l9)
                  (i32.load
                    (local.tee $l4
                      (i32.add
                        (i32.shl
                          (local.tee $l6
                            (i32.load offset=28
                              (local.get $l9)))
                          (i32.const 2))
                        (i32.const 1588))))))
              (i32.store
                (local.get $l4)
                (local.get $p0))
              (br_if $B110
                (local.get $p0))
              (i32.store offset=1288
                (i32.const 0)
                (local.tee $l10
                  (i32.and
                    (local.get $l10)
                    (i32.rotl
                      (i32.const -2)
                      (local.get $l6)))))
              (br $B109))
            (i32.store
              (i32.add
                (local.get $l2)
                (select
                  (i32.const 16)
                  (i32.const 20)
                  (i32.eq
                    (i32.load offset=16
                      (local.get $l2))
                    (local.get $l9))))
              (local.get $p0))
            (br_if $B109
              (i32.eqz
                (local.get $p0))))
          (i32.store offset=24
            (local.get $p0)
            (local.get $l2))
          (block $B112
            (br_if $B112
              (i32.eqz
                (local.tee $l4
                  (i32.load offset=16
                    (local.get $l9)))))
            (i32.store offset=16
              (local.get $p0)
              (local.get $l4))
            (i32.store offset=24
              (local.get $l4)
              (local.get $p0)))
          (br_if $B109
            (i32.eqz
              (local.tee $l4
                (i32.load
                  (i32.add
                    (local.get $l9)
                    (i32.const 20))))))
          (i32.store
            (i32.add
              (local.get $p0)
              (i32.const 20))
            (local.get $l4))
          (i32.store offset=24
            (local.get $l4)
            (local.get $p0)))
        (block $B113
          (block $B114
            (br_if $B114
              (i32.gt_u
                (local.get $l3)
                (i32.const 15)))
            (i32.store offset=4
              (local.get $l9)
              (i32.or
                (local.tee $l4
                  (i32.add
                    (local.get $l3)
                    (local.get $l5)))
                (i32.const 3)))
            (i32.store offset=4
              (local.tee $l4
                (i32.add
                  (local.get $l9)
                  (local.get $l4)))
              (i32.or
                (i32.load offset=4
                  (local.get $l4))
                (i32.const 1)))
            (br $B113))
          (i32.store offset=4
            (local.tee $p0
              (i32.add
                (local.get $l9)
                (local.get $l5)))
            (i32.or
              (local.get $l3)
              (i32.const 1)))
          (i32.store offset=4
            (local.get $l9)
            (i32.or
              (local.get $l5)
              (i32.const 3)))
          (i32.store
            (i32.add
              (local.get $p0)
              (local.get $l3))
            (local.get $l3))
          (block $B115
            (br_if $B115
              (i32.gt_u
                (local.get $l3)
                (i32.const 255)))
            (local.set $l4
              (i32.add
                (i32.and
                  (local.get $l3)
                  (i32.const -8))
                (i32.const 1324)))
            (block $B116
              (block $B117
                (br_if $B117
                  (i32.and
                    (local.tee $l6
                      (i32.load offset=1284
                        (i32.const 0)))
                    (local.tee $l3
                      (i32.shl
                        (i32.const 1)
                        (i32.shr_u
                          (local.get $l3)
                          (i32.const 3))))))
                (i32.store offset=1284
                  (i32.const 0)
                  (i32.or
                    (local.get $l6)
                    (local.get $l3)))
                (local.set $l3
                  (local.get $l4))
                (br $B116))
              (local.set $l3
                (i32.load offset=8
                  (local.get $l4))))
            (i32.store offset=12
              (local.get $l3)
              (local.get $p0))
            (i32.store offset=8
              (local.get $l4)
              (local.get $p0))
            (i32.store offset=12
              (local.get $p0)
              (local.get $l4))
            (i32.store offset=8
              (local.get $p0)
              (local.get $l3))
            (br $B113))
          (local.set $l4
            (i32.const 31))
          (block $B118
            (br_if $B118
              (i32.gt_u
                (local.get $l3)
                (i32.const 16777215)))
            (local.set $l4
              (i32.add
                (i32.or
                  (i32.shl
                    (local.tee $l4
                      (i32.sub
                        (i32.shr_u
                          (i32.shl
                            (local.tee $l5
                              (i32.shl
                                (local.tee $l6
                                  (i32.shl
                                    (local.tee $l4
                                      (i32.shr_u
                                        (local.get $l3)
                                        (i32.const 8)))
                                    (local.tee $l4
                                      (i32.and
                                        (i32.shr_u
                                          (i32.add
                                            (local.get $l4)
                                            (i32.const 1048320))
                                          (i32.const 16))
                                        (i32.const 8)))))
                                (local.tee $l6
                                  (i32.and
                                    (i32.shr_u
                                      (i32.add
                                        (local.get $l6)
                                        (i32.const 520192))
                                      (i32.const 16))
                                    (i32.const 4)))))
                            (local.tee $l5
                              (i32.and
                                (i32.shr_u
                                  (i32.add
                                    (local.get $l5)
                                    (i32.const 245760))
                                  (i32.const 16))
                                (i32.const 2))))
                          (i32.const 15))
                        (i32.or
                          (i32.or
                            (local.get $l4)
                            (local.get $l6))
                          (local.get $l5))))
                    (i32.const 1))
                  (i32.and
                    (i32.shr_u
                      (local.get $l3)
                      (i32.add
                        (local.get $l4)
                        (i32.const 21)))
                    (i32.const 1)))
                (i32.const 28))))
          (i32.store offset=28
            (local.get $p0)
            (local.get $l4))
          (i64.store offset=16 align=4
            (local.get $p0)
            (i64.const 0))
          (local.set $l6
            (i32.add
              (i32.shl
                (local.get $l4)
                (i32.const 2))
              (i32.const 1588)))
          (block $B119
            (br_if $B119
              (i32.and
                (local.get $l10)
                (local.tee $l5
                  (i32.shl
                    (i32.const 1)
                    (local.get $l4)))))
            (i32.store
              (local.get $l6)
              (local.get $p0))
            (i32.store offset=1288
              (i32.const 0)
              (i32.or
                (local.get $l10)
                (local.get $l5)))
            (i32.store offset=24
              (local.get $p0)
              (local.get $l6))
            (i32.store offset=8
              (local.get $p0)
              (local.get $p0))
            (i32.store offset=12
              (local.get $p0)
              (local.get $p0))
            (br $B113))
          (local.set $l4
            (i32.shl
              (local.get $l3)
              (select
                (i32.const 0)
                (i32.sub
                  (i32.const 25)
                  (i32.shr_u
                    (local.get $l4)
                    (i32.const 1)))
                (i32.eq
                  (local.get $l4)
                  (i32.const 31)))))
          (local.set $l5
            (i32.load
              (local.get $l6)))
          (block $B120
            (loop $L121
              (br_if $B120
                (i32.eq
                  (i32.and
                    (i32.load offset=4
                      (local.tee $l6
                        (local.get $l5)))
                    (i32.const -8))
                  (local.get $l3)))
              (local.set $l5
                (i32.shr_u
                  (local.get $l4)
                  (i32.const 29)))
              (local.set $l4
                (i32.shl
                  (local.get $l4)
                  (i32.const 1)))
              (br_if $L121
                (local.tee $l5
                  (i32.load
                    (local.tee $l7
                      (i32.add
                        (i32.add
                          (local.get $l6)
                          (i32.and
                            (local.get $l5)
                            (i32.const 4)))
                        (i32.const 16)))))))
            (i32.store
              (local.get $l7)
              (local.get $p0))
            (i32.store offset=24
              (local.get $p0)
              (local.get $l6))
            (i32.store offset=12
              (local.get $p0)
              (local.get $p0))
            (i32.store offset=8
              (local.get $p0)
              (local.get $p0))
            (br $B113))
          (i32.store offset=12
            (local.tee $l4
              (i32.load offset=8
                (local.get $l6)))
            (local.get $p0))
          (i32.store offset=8
            (local.get $l6)
            (local.get $p0))
          (i32.store offset=24
            (local.get $p0)
            (i32.const 0))
          (i32.store offset=12
            (local.get $p0)
            (local.get $l6))
          (i32.store offset=8
            (local.get $p0)
            (local.get $l4)))
        (local.set $l4
          (i32.add
            (local.get $l9)
            (i32.const 8)))
        (br $B4))
      (block $B122
        (br_if $B122
          (i32.eqz
            (local.get $l11)))
        (block $B123
          (block $B124
            (br_if $B124
              (i32.ne
                (local.get $p0)
                (i32.load
                  (local.tee $l4
                    (i32.add
                      (i32.shl
                        (local.tee $l6
                          (i32.load offset=28
                            (local.get $p0)))
                        (i32.const 2))
                      (i32.const 1588))))))
            (i32.store
              (local.get $l4)
              (local.get $l9))
            (br_if $B123
              (local.get $l9))
            (i32.store offset=1288
              (i32.const 0)
              (i32.and
                (local.get $l10)
                (i32.rotl
                  (i32.const -2)
                  (local.get $l6))))
            (br $B122))
          (i32.store
            (i32.add
              (local.get $l11)
              (select
                (i32.const 16)
                (i32.const 20)
                (i32.eq
                  (i32.load offset=16
                    (local.get $l11))
                  (local.get $p0))))
            (local.get $l9))
          (br_if $B122
            (i32.eqz
              (local.get $l9))))
        (i32.store offset=24
          (local.get $l9)
          (local.get $l11))
        (block $B125
          (br_if $B125
            (i32.eqz
              (local.tee $l4
                (i32.load offset=16
                  (local.get $p0)))))
          (i32.store offset=16
            (local.get $l9)
            (local.get $l4))
          (i32.store offset=24
            (local.get $l4)
            (local.get $l9)))
        (br_if $B122
          (i32.eqz
            (local.tee $l4
              (i32.load
                (i32.add
                  (local.get $p0)
                  (i32.const 20))))))
        (i32.store
          (i32.add
            (local.get $l9)
            (i32.const 20))
          (local.get $l4))
        (i32.store offset=24
          (local.get $l4)
          (local.get $l9)))
      (block $B126
        (block $B127
          (br_if $B127
            (i32.gt_u
              (local.get $l3)
              (i32.const 15)))
          (i32.store offset=4
            (local.get $p0)
            (i32.or
              (local.tee $l4
                (i32.add
                  (local.get $l3)
                  (local.get $l5)))
              (i32.const 3)))
          (i32.store offset=4
            (local.tee $l4
              (i32.add
                (local.get $p0)
                (local.get $l4)))
            (i32.or
              (i32.load offset=4
                (local.get $l4))
              (i32.const 1)))
          (br $B126))
        (i32.store offset=4
          (local.tee $l6
            (i32.add
              (local.get $p0)
              (local.get $l5)))
          (i32.or
            (local.get $l3)
            (i32.const 1)))
        (i32.store offset=4
          (local.get $p0)
          (i32.or
            (local.get $l5)
            (i32.const 3)))
        (i32.store
          (i32.add
            (local.get $l6)
            (local.get $l3))
          (local.get $l3))
        (block $B128
          (br_if $B128
            (i32.eqz
              (local.get $l8)))
          (local.set $l5
            (i32.add
              (i32.and
                (local.get $l8)
                (i32.const -8))
              (i32.const 1324)))
          (local.set $l4
            (i32.load offset=1304
              (i32.const 0)))
          (block $B129
            (block $B130
              (br_if $B130
                (i32.and
                  (local.tee $l9
                    (i32.shl
                      (i32.const 1)
                      (i32.shr_u
                        (local.get $l8)
                        (i32.const 3))))
                  (local.get $l7)))
              (i32.store offset=1284
                (i32.const 0)
                (i32.or
                  (local.get $l9)
                  (local.get $l7)))
              (local.set $l9
                (local.get $l5))
              (br $B129))
            (local.set $l9
              (i32.load offset=8
                (local.get $l5))))
          (i32.store offset=12
            (local.get $l9)
            (local.get $l4))
          (i32.store offset=8
            (local.get $l5)
            (local.get $l4))
          (i32.store offset=12
            (local.get $l4)
            (local.get $l5))
          (i32.store offset=8
            (local.get $l4)
            (local.get $l9)))
        (i32.store offset=1304
          (i32.const 0)
          (local.get $l6))
        (i32.store offset=1292
          (i32.const 0)
          (local.get $l3)))
      (local.set $l4
        (i32.add
          (local.get $p0)
          (i32.const 8))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l1)
        (i32.const 16)))
    (local.get $l4))
  (func $free (type $t6) (param $p0 i32)
    (call $dlfree
      (local.get $p0)))
  (func $dlfree (type $t6) (param $p0 i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32)
    (block $B0
      (br_if $B0
        (i32.eqz
          (local.get $p0)))
      (local.set $l3
        (i32.add
          (local.tee $l1
            (i32.add
              (local.get $p0)
              (i32.const -8)))
          (local.tee $p0
            (i32.and
              (local.tee $l2
                (i32.load
                  (i32.add
                    (local.get $p0)
                    (i32.const -4))))
              (i32.const -8)))))
      (block $B1
        (br_if $B1
          (i32.and
            (local.get $l2)
            (i32.const 1)))
        (br_if $B0
          (i32.eqz
            (i32.and
              (local.get $l2)
              (i32.const 3))))
        (br_if $B0
          (i32.lt_u
            (local.tee $l1
              (i32.sub
                (local.get $l1)
                (local.tee $l2
                  (i32.load
                    (local.get $l1)))))
            (local.tee $l4
              (i32.load offset=1300
                (i32.const 0)))))
        (local.set $p0
          (i32.add
            (local.get $l2)
            (local.get $p0)))
        (block $B2
          (br_if $B2
            (i32.eq
              (local.get $l1)
              (i32.load offset=1304
                (i32.const 0))))
          (block $B3
            (br_if $B3
              (i32.gt_u
                (local.get $l2)
                (i32.const 255)))
            (drop
              (i32.eq
                (local.tee $l4
                  (i32.load offset=8
                    (local.get $l1)))
                (local.tee $l6
                  (i32.add
                    (i32.shl
                      (local.tee $l5
                        (i32.shr_u
                          (local.get $l2)
                          (i32.const 3)))
                      (i32.const 3))
                    (i32.const 1324)))))
            (block $B4
              (br_if $B4
                (i32.ne
                  (local.tee $l2
                    (i32.load offset=12
                      (local.get $l1)))
                  (local.get $l4)))
              (i32.store offset=1284
                (i32.const 0)
                (i32.and
                  (i32.load offset=1284
                    (i32.const 0))
                  (i32.rotl
                    (i32.const -2)
                    (local.get $l5))))
              (br $B1))
            (drop
              (i32.eq
                (local.get $l2)
                (local.get $l6)))
            (i32.store offset=8
              (local.get $l2)
              (local.get $l4))
            (i32.store offset=12
              (local.get $l4)
              (local.get $l2))
            (br $B1))
          (local.set $l7
            (i32.load offset=24
              (local.get $l1)))
          (block $B5
            (block $B6
              (br_if $B6
                (i32.eq
                  (local.tee $l6
                    (i32.load offset=12
                      (local.get $l1)))
                  (local.get $l1)))
              (drop
                (i32.lt_u
                  (local.tee $l2
                    (i32.load offset=8
                      (local.get $l1)))
                  (local.get $l4)))
              (i32.store offset=8
                (local.get $l6)
                (local.get $l2))
              (i32.store offset=12
                (local.get $l2)
                (local.get $l6))
              (br $B5))
            (block $B7
              (br_if $B7
                (local.tee $l4
                  (i32.load
                    (local.tee $l2
                      (i32.add
                        (local.get $l1)
                        (i32.const 20))))))
              (br_if $B7
                (local.tee $l4
                  (i32.load
                    (local.tee $l2
                      (i32.add
                        (local.get $l1)
                        (i32.const 16))))))
              (local.set $l6
                (i32.const 0))
              (br $B5))
            (loop $L8
              (local.set $l5
                (local.get $l2))
              (br_if $L8
                (local.tee $l4
                  (i32.load
                    (local.tee $l2
                      (i32.add
                        (local.tee $l6
                          (local.get $l4))
                        (i32.const 20))))))
              (local.set $l2
                (i32.add
                  (local.get $l6)
                  (i32.const 16)))
              (br_if $L8
                (local.tee $l4
                  (i32.load offset=16
                    (local.get $l6)))))
            (i32.store
              (local.get $l5)
              (i32.const 0)))
          (br_if $B1
            (i32.eqz
              (local.get $l7)))
          (block $B9
            (block $B10
              (br_if $B10
                (i32.ne
                  (local.get $l1)
                  (i32.load
                    (local.tee $l2
                      (i32.add
                        (i32.shl
                          (local.tee $l4
                            (i32.load offset=28
                              (local.get $l1)))
                          (i32.const 2))
                        (i32.const 1588))))))
              (i32.store
                (local.get $l2)
                (local.get $l6))
              (br_if $B9
                (local.get $l6))
              (i32.store offset=1288
                (i32.const 0)
                (i32.and
                  (i32.load offset=1288
                    (i32.const 0))
                  (i32.rotl
                    (i32.const -2)
                    (local.get $l4))))
              (br $B1))
            (i32.store
              (i32.add
                (local.get $l7)
                (select
                  (i32.const 16)
                  (i32.const 20)
                  (i32.eq
                    (i32.load offset=16
                      (local.get $l7))
                    (local.get $l1))))
              (local.get $l6))
            (br_if $B1
              (i32.eqz
                (local.get $l6))))
          (i32.store offset=24
            (local.get $l6)
            (local.get $l7))
          (block $B11
            (br_if $B11
              (i32.eqz
                (local.tee $l2
                  (i32.load offset=16
                    (local.get $l1)))))
            (i32.store offset=16
              (local.get $l6)
              (local.get $l2))
            (i32.store offset=24
              (local.get $l2)
              (local.get $l6)))
          (br_if $B1
            (i32.eqz
              (local.tee $l2
                (i32.load offset=20
                  (local.get $l1)))))
          (i32.store
            (i32.add
              (local.get $l6)
              (i32.const 20))
            (local.get $l2))
          (i32.store offset=24
            (local.get $l2)
            (local.get $l6))
          (br $B1))
        (br_if $B1
          (i32.ne
            (i32.and
              (local.tee $l2
                (i32.load offset=4
                  (local.get $l3)))
              (i32.const 3))
            (i32.const 3)))
        (i32.store offset=4
          (local.get $l3)
          (i32.and
            (local.get $l2)
            (i32.const -2)))
        (i32.store offset=1292
          (i32.const 0)
          (local.get $p0))
        (i32.store
          (i32.add
            (local.get $l1)
            (local.get $p0))
          (local.get $p0))
        (i32.store offset=4
          (local.get $l1)
          (i32.or
            (local.get $p0)
            (i32.const 1)))
        (return))
      (br_if $B0
        (i32.ge_u
          (local.get $l1)
          (local.get $l3)))
      (br_if $B0
        (i32.eqz
          (i32.and
            (local.tee $l2
              (i32.load offset=4
                (local.get $l3)))
            (i32.const 1))))
      (block $B12
        (block $B13
          (br_if $B13
            (i32.and
              (local.get $l2)
              (i32.const 2)))
          (block $B14
            (br_if $B14
              (i32.ne
                (local.get $l3)
                (i32.load offset=1308
                  (i32.const 0))))
            (i32.store offset=1308
              (i32.const 0)
              (local.get $l1))
            (i32.store offset=1296
              (i32.const 0)
              (local.tee $p0
                (i32.add
                  (i32.load offset=1296
                    (i32.const 0))
                  (local.get $p0))))
            (i32.store offset=4
              (local.get $l1)
              (i32.or
                (local.get $p0)
                (i32.const 1)))
            (br_if $B0
              (i32.ne
                (local.get $l1)
                (i32.load offset=1304
                  (i32.const 0))))
            (i32.store offset=1292
              (i32.const 0)
              (i32.const 0))
            (i32.store offset=1304
              (i32.const 0)
              (i32.const 0))
            (return))
          (block $B15
            (br_if $B15
              (i32.ne
                (local.get $l3)
                (i32.load offset=1304
                  (i32.const 0))))
            (i32.store offset=1304
              (i32.const 0)
              (local.get $l1))
            (i32.store offset=1292
              (i32.const 0)
              (local.tee $p0
                (i32.add
                  (i32.load offset=1292
                    (i32.const 0))
                  (local.get $p0))))
            (i32.store offset=4
              (local.get $l1)
              (i32.or
                (local.get $p0)
                (i32.const 1)))
            (i32.store
              (i32.add
                (local.get $l1)
                (local.get $p0))
              (local.get $p0))
            (return))
          (local.set $p0
            (i32.add
              (i32.and
                (local.get $l2)
                (i32.const -8))
              (local.get $p0)))
          (block $B16
            (block $B17
              (br_if $B17
                (i32.gt_u
                  (local.get $l2)
                  (i32.const 255)))
              (drop
                (i32.eq
                  (local.tee $l4
                    (i32.load offset=8
                      (local.get $l3)))
                  (local.tee $l6
                    (i32.add
                      (i32.shl
                        (local.tee $l5
                          (i32.shr_u
                            (local.get $l2)
                            (i32.const 3)))
                        (i32.const 3))
                      (i32.const 1324)))))
              (block $B18
                (br_if $B18
                  (i32.ne
                    (local.tee $l2
                      (i32.load offset=12
                        (local.get $l3)))
                    (local.get $l4)))
                (i32.store offset=1284
                  (i32.const 0)
                  (i32.and
                    (i32.load offset=1284
                      (i32.const 0))
                    (i32.rotl
                      (i32.const -2)
                      (local.get $l5))))
                (br $B16))
              (drop
                (i32.eq
                  (local.get $l2)
                  (local.get $l6)))
              (i32.store offset=8
                (local.get $l2)
                (local.get $l4))
              (i32.store offset=12
                (local.get $l4)
                (local.get $l2))
              (br $B16))
            (local.set $l7
              (i32.load offset=24
                (local.get $l3)))
            (block $B19
              (block $B20
                (br_if $B20
                  (i32.eq
                    (local.tee $l6
                      (i32.load offset=12
                        (local.get $l3)))
                    (local.get $l3)))
                (drop
                  (i32.lt_u
                    (local.tee $l2
                      (i32.load offset=8
                        (local.get $l3)))
                    (i32.load offset=1300
                      (i32.const 0))))
                (i32.store offset=8
                  (local.get $l6)
                  (local.get $l2))
                (i32.store offset=12
                  (local.get $l2)
                  (local.get $l6))
                (br $B19))
              (block $B21
                (br_if $B21
                  (local.tee $l4
                    (i32.load
                      (local.tee $l2
                        (i32.add
                          (local.get $l3)
                          (i32.const 20))))))
                (br_if $B21
                  (local.tee $l4
                    (i32.load
                      (local.tee $l2
                        (i32.add
                          (local.get $l3)
                          (i32.const 16))))))
                (local.set $l6
                  (i32.const 0))
                (br $B19))
              (loop $L22
                (local.set $l5
                  (local.get $l2))
                (br_if $L22
                  (local.tee $l4
                    (i32.load
                      (local.tee $l2
                        (i32.add
                          (local.tee $l6
                            (local.get $l4))
                          (i32.const 20))))))
                (local.set $l2
                  (i32.add
                    (local.get $l6)
                    (i32.const 16)))
                (br_if $L22
                  (local.tee $l4
                    (i32.load offset=16
                      (local.get $l6)))))
              (i32.store
                (local.get $l5)
                (i32.const 0)))
            (br_if $B16
              (i32.eqz
                (local.get $l7)))
            (block $B23
              (block $B24
                (br_if $B24
                  (i32.ne
                    (local.get $l3)
                    (i32.load
                      (local.tee $l2
                        (i32.add
                          (i32.shl
                            (local.tee $l4
                              (i32.load offset=28
                                (local.get $l3)))
                            (i32.const 2))
                          (i32.const 1588))))))
                (i32.store
                  (local.get $l2)
                  (local.get $l6))
                (br_if $B23
                  (local.get $l6))
                (i32.store offset=1288
                  (i32.const 0)
                  (i32.and
                    (i32.load offset=1288
                      (i32.const 0))
                    (i32.rotl
                      (i32.const -2)
                      (local.get $l4))))
                (br $B16))
              (i32.store
                (i32.add
                  (local.get $l7)
                  (select
                    (i32.const 16)
                    (i32.const 20)
                    (i32.eq
                      (i32.load offset=16
                        (local.get $l7))
                      (local.get $l3))))
                (local.get $l6))
              (br_if $B16
                (i32.eqz
                  (local.get $l6))))
            (i32.store offset=24
              (local.get $l6)
              (local.get $l7))
            (block $B25
              (br_if $B25
                (i32.eqz
                  (local.tee $l2
                    (i32.load offset=16
                      (local.get $l3)))))
              (i32.store offset=16
                (local.get $l6)
                (local.get $l2))
              (i32.store offset=24
                (local.get $l2)
                (local.get $l6)))
            (br_if $B16
              (i32.eqz
                (local.tee $l2
                  (i32.load offset=20
                    (local.get $l3)))))
            (i32.store
              (i32.add
                (local.get $l6)
                (i32.const 20))
              (local.get $l2))
            (i32.store offset=24
              (local.get $l2)
              (local.get $l6)))
          (i32.store
            (i32.add
              (local.get $l1)
              (local.get $p0))
            (local.get $p0))
          (i32.store offset=4
            (local.get $l1)
            (i32.or
              (local.get $p0)
              (i32.const 1)))
          (br_if $B12
            (i32.ne
              (local.get $l1)
              (i32.load offset=1304
                (i32.const 0))))
          (i32.store offset=1292
            (i32.const 0)
            (local.get $p0))
          (return))
        (i32.store offset=4
          (local.get $l3)
          (i32.and
            (local.get $l2)
            (i32.const -2)))
        (i32.store
          (i32.add
            (local.get $l1)
            (local.get $p0))
          (local.get $p0))
        (i32.store offset=4
          (local.get $l1)
          (i32.or
            (local.get $p0)
            (i32.const 1))))
      (block $B26
        (br_if $B26
          (i32.gt_u
            (local.get $p0)
            (i32.const 255)))
        (local.set $l2
          (i32.add
            (i32.and
              (local.get $p0)
              (i32.const -8))
            (i32.const 1324)))
        (block $B27
          (block $B28
            (br_if $B28
              (i32.and
                (local.tee $l4
                  (i32.load offset=1284
                    (i32.const 0)))
                (local.tee $p0
                  (i32.shl
                    (i32.const 1)
                    (i32.shr_u
                      (local.get $p0)
                      (i32.const 3))))))
            (i32.store offset=1284
              (i32.const 0)
              (i32.or
                (local.get $l4)
                (local.get $p0)))
            (local.set $p0
              (local.get $l2))
            (br $B27))
          (local.set $p0
            (i32.load offset=8
              (local.get $l2))))
        (i32.store offset=12
          (local.get $p0)
          (local.get $l1))
        (i32.store offset=8
          (local.get $l2)
          (local.get $l1))
        (i32.store offset=12
          (local.get $l1)
          (local.get $l2))
        (i32.store offset=8
          (local.get $l1)
          (local.get $p0))
        (return))
      (local.set $l2
        (i32.const 31))
      (block $B29
        (br_if $B29
          (i32.gt_u
            (local.get $p0)
            (i32.const 16777215)))
        (local.set $l2
          (i32.add
            (i32.or
              (i32.shl
                (local.tee $l2
                  (i32.sub
                    (i32.shr_u
                      (i32.shl
                        (local.tee $l6
                          (i32.shl
                            (local.tee $l4
                              (i32.shl
                                (local.tee $l2
                                  (i32.shr_u
                                    (local.get $p0)
                                    (i32.const 8)))
                                (local.tee $l2
                                  (i32.and
                                    (i32.shr_u
                                      (i32.add
                                        (local.get $l2)
                                        (i32.const 1048320))
                                      (i32.const 16))
                                    (i32.const 8)))))
                            (local.tee $l4
                              (i32.and
                                (i32.shr_u
                                  (i32.add
                                    (local.get $l4)
                                    (i32.const 520192))
                                  (i32.const 16))
                                (i32.const 4)))))
                        (local.tee $l6
                          (i32.and
                            (i32.shr_u
                              (i32.add
                                (local.get $l6)
                                (i32.const 245760))
                              (i32.const 16))
                            (i32.const 2))))
                      (i32.const 15))
                    (i32.or
                      (i32.or
                        (local.get $l2)
                        (local.get $l4))
                      (local.get $l6))))
                (i32.const 1))
              (i32.and
                (i32.shr_u
                  (local.get $p0)
                  (i32.add
                    (local.get $l2)
                    (i32.const 21)))
                (i32.const 1)))
            (i32.const 28))))
      (i32.store offset=28
        (local.get $l1)
        (local.get $l2))
      (i64.store offset=16 align=4
        (local.get $l1)
        (i64.const 0))
      (local.set $l4
        (i32.add
          (i32.shl
            (local.get $l2)
            (i32.const 2))
          (i32.const 1588)))
      (block $B30
        (block $B31
          (br_if $B31
            (i32.and
              (local.tee $l6
                (i32.load offset=1288
                  (i32.const 0)))
              (local.tee $l3
                (i32.shl
                  (i32.const 1)
                  (local.get $l2)))))
          (i32.store
            (local.get $l4)
            (local.get $l1))
          (i32.store offset=1288
            (i32.const 0)
            (i32.or
              (local.get $l6)
              (local.get $l3)))
          (i32.store offset=24
            (local.get $l1)
            (local.get $l4))
          (i32.store offset=8
            (local.get $l1)
            (local.get $l1))
          (i32.store offset=12
            (local.get $l1)
            (local.get $l1))
          (br $B30))
        (local.set $l2
          (i32.shl
            (local.get $p0)
            (select
              (i32.const 0)
              (i32.sub
                (i32.const 25)
                (i32.shr_u
                  (local.get $l2)
                  (i32.const 1)))
              (i32.eq
                (local.get $l2)
                (i32.const 31)))))
        (local.set $l6
          (i32.load
            (local.get $l4)))
        (block $B32
          (loop $L33
            (br_if $B32
              (i32.eq
                (i32.and
                  (i32.load offset=4
                    (local.tee $l4
                      (local.get $l6)))
                  (i32.const -8))
                (local.get $p0)))
            (local.set $l6
              (i32.shr_u
                (local.get $l2)
                (i32.const 29)))
            (local.set $l2
              (i32.shl
                (local.get $l2)
                (i32.const 1)))
            (br_if $L33
              (local.tee $l6
                (i32.load
                  (local.tee $l3
                    (i32.add
                      (i32.add
                        (local.get $l4)
                        (i32.and
                          (local.get $l6)
                          (i32.const 4)))
                      (i32.const 16)))))))
          (i32.store
            (local.get $l3)
            (local.get $l1))
          (i32.store offset=24
            (local.get $l1)
            (local.get $l4))
          (i32.store offset=12
            (local.get $l1)
            (local.get $l1))
          (i32.store offset=8
            (local.get $l1)
            (local.get $l1))
          (br $B30))
        (i32.store offset=12
          (local.tee $p0
            (i32.load offset=8
              (local.get $l4)))
          (local.get $l1))
        (i32.store offset=8
          (local.get $l4)
          (local.get $l1))
        (i32.store offset=24
          (local.get $l1)
          (i32.const 0))
        (i32.store offset=12
          (local.get $l1)
          (local.get $l4))
        (i32.store offset=8
          (local.get $l1)
          (local.get $p0)))
      (i32.store offset=1316
        (i32.const 0)
        (select
          (local.tee $l1
            (i32.add
              (i32.load offset=1316
                (i32.const 0))
              (i32.const -1)))
          (i32.const -1)
          (local.get $l1)))))
  (func $calloc (type $t3) (param $p0 i32) (param $p1 i32) (result i32)
    (local $l2 i32) (local $l3 i64)
    (block $B0
      (block $B1
        (br_if $B1
          (local.get $p0))
        (local.set $l2
          (i32.const 0))
        (br $B0))
      (local.set $l2
        (i32.wrap_i64
          (local.tee $l3
            (i64.mul
              (i64.extend_i32_u
                (local.get $p0))
              (i64.extend_i32_u
                (local.get $p1))))))
      (br_if $B0
        (i32.lt_u
          (i32.or
            (local.get $p1)
            (local.get $p0))
          (i32.const 65536)))
      (local.set $l2
        (select
          (i32.const -1)
          (local.get $l2)
          (i32.ne
            (i32.wrap_i64
              (i64.shr_u
                (local.get $l3)
                (i64.const 32)))
            (i32.const 0)))))
    (block $B2
      (br_if $B2
        (i32.eqz
          (local.tee $p0
            (call $dlmalloc
              (local.get $l2)))))
      (br_if $B2
        (i32.eqz
          (i32.and
            (i32.load8_u
              (i32.add
                (local.get $p0)
                (i32.const -4)))
            (i32.const 3))))
      (drop
        (call $memset
          (local.get $p0)
          (i32.const 0)
          (local.get $l2))))
    (local.get $p0))
  (func $__wasi_fd_close (type $t2) (param $p0 i32) (result i32)
    (i32.and
      (call $__imported_wasi_snapshot_preview1_fd_close
        (local.get $p0))
      (i32.const 65535)))
  (func $__wasi_fd_fdstat_get (type $t3) (param $p0 i32) (param $p1 i32) (result i32)
    (i32.and
      (call $__imported_wasi_snapshot_preview1_fd_fdstat_get
        (local.get $p0)
        (local.get $p1))
      (i32.const 65535)))
  (func $__wasi_fd_read (type $t4) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (i32.and
      (call $__imported_wasi_snapshot_preview1_fd_read
        (local.get $p0)
        (local.get $p1)
        (local.get $p2)
        (local.get $p3))
      (i32.const 65535)))
  (func $__wasi_fd_seek (type $t5) (param $p0 i32) (param $p1 i64) (param $p2 i32) (param $p3 i32) (result i32)
    (i32.and
      (call $__imported_wasi_snapshot_preview1_fd_seek
        (local.get $p0)
        (local.get $p1)
        (local.get $p2)
        (local.get $p3))
      (i32.const 65535)))
  (func $__wasi_fd_write (type $t4) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (i32.and
      (call $__imported_wasi_snapshot_preview1_fd_write
        (local.get $p0)
        (local.get $p1)
        (local.get $p2)
        (local.get $p3))
      (i32.const 65535)))
  (func $__wasi_proc_exit (type $t6) (param $p0 i32)
    (call $__imported_wasi_snapshot_preview1_proc_exit
      (local.get $p0))
    (unreachable))
  (func $abort (type $t7)
    (unreachable)
    (unreachable))
  (func $sbrk (type $t2) (param $p0 i32) (result i32)
    (block $B0
      (br_if $B0
        (local.get $p0))
      (return
        (i32.shl
          (memory.size)
          (i32.const 16))))
    (block $B1
      (br_if $B1
        (i32.and
          (local.get $p0)
          (i32.const 65535)))
      (br_if $B1
        (i32.le_s
          (local.get $p0)
          (i32.const -1)))
      (block $B2
        (br_if $B2
          (i32.ne
            (local.tee $p0
              (memory.grow
                (i32.shr_u
                  (local.get $p0)
                  (i32.const 16))))
            (i32.const -1)))
        (i32.store offset=1780
          (i32.const 0)
          (i32.const 48))
        (return
          (i32.const -1)))
      (return
        (i32.shl
          (local.get $p0)
          (i32.const 16))))
    (call $abort)
    (unreachable))
  (func $dummy (type $t7))
  (func $__wasm_call_dtors (type $t7)
    (call $dummy)
    (call $__stdio_exit))
  (func $fwrite (type $t4) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    (local.set $l4
      (i32.mul
        (local.get $p2)
        (local.get $p1)))
    (block $B0
      (block $B1
        (br_if $B1
          (local.tee $l5
            (i32.load offset=16
              (local.get $p3))))
        (local.set $l6
          (i32.const 0))
        (br_if $B0
          (call $__towrite
            (local.get $p3)))
        (local.set $l5
          (i32.load offset=16
            (local.get $p3))))
      (block $B2
        (br_if $B2
          (i32.ge_u
            (i32.sub
              (local.get $l5)
              (local.tee $l7
                (i32.load offset=20
                  (local.get $p3))))
            (local.get $l4)))
        (local.set $l6
          (call_indirect $T0 (type $t0)
            (local.get $p3)
            (local.get $p0)
            (local.get $l4)
            (i32.load offset=32
              (local.get $p3))))
        (br $B0))
      (local.set $l8
        (i32.const 0))
      (block $B3
        (block $B4
          (br_if $B4
            (i32.ge_s
              (i32.load offset=64
                (local.get $p3))
              (i32.const 0)))
          (local.set $l5
            (local.get $l4))
          (br $B3))
        (local.set $l6
          (i32.add
            (local.get $p0)
            (local.get $l4)))
        (local.set $l8
          (i32.const 0))
        (local.set $l5
          (i32.const 0))
        (loop $L5
          (block $B6
            (br_if $B6
              (i32.add
                (local.get $l4)
                (local.get $l5)))
            (local.set $l5
              (local.get $l4))
            (br $B3))
          (br_if $L5
            (i32.ne
              (i32.load8_u
                (local.tee $l9
                  (i32.add
                    (local.tee $l5
                      (i32.add
                        (local.get $l5)
                        (i32.const -1)))
                    (local.get $l6))))
              (i32.const 10))))
        (br_if $B0
          (i32.lt_u
            (local.tee $l6
              (call_indirect $T0 (type $t0)
                (local.get $p3)
                (local.get $p0)
                (local.tee $l8
                  (i32.add
                    (i32.add
                      (local.get $l4)
                      (local.get $l5))
                    (i32.const 1)))
                (i32.load offset=32
                  (local.get $p3))))
            (local.get $l8)))
        (local.set $l5
          (i32.xor
            (local.get $l5)
            (i32.const -1)))
        (local.set $p0
          (i32.add
            (local.get $l9)
            (i32.const 1)))
        (local.set $l7
          (i32.load offset=20
            (local.get $p3))))
      (drop
        (call $memcpy
          (local.get $l7)
          (local.get $p0)
          (local.get $l5)))
      (i32.store offset=20
        (local.get $p3)
        (i32.add
          (i32.load offset=20
            (local.get $p3))
          (local.get $l5)))
      (local.set $l6
        (i32.add
          (local.get $l8)
          (local.get $l5))))
    (block $B7
      (br_if $B7
        (i32.ne
          (local.get $l6)
          (local.get $l4)))
      (return
        (select
          (local.get $p2)
          (i32.const 0)
          (local.get $p1))))
    (i32.div_u
      (local.get $l6)
      (local.get $p1)))
  (func $fflush (type $t2) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32) (local $l3 i32)
    (block $B0
      (br_if $B0
        (local.get $p0))
      (local.set $l1
        (i32.const 0))
      (block $B1
        (br_if $B1
          (i32.eqz
            (i32.load offset=1264
              (i32.const 0))))
        (local.set $l1
          (call $fflush
            (i32.load offset=1264
              (i32.const 0)))))
      (block $B2
        (br_if $B2
          (i32.eqz
            (i32.load offset=1784
              (i32.const 0))))
        (local.set $l1
          (i32.or
            (call $fflush
              (i32.load offset=1784
                (i32.const 0)))
            (local.get $l1))))
      (block $B3
        (br_if $B3
          (i32.eqz
            (local.tee $p0
              (i32.load
                (call $__ofl_lock)))))
        (loop $L4
          (block $B5
            (br_if $B5
              (i32.eq
                (i32.load offset=20
                  (local.get $p0))
                (i32.load offset=24
                  (local.get $p0))))
            (drop
              (call_indirect $T0 (type $t0)
                (local.get $p0)
                (i32.const 0)
                (i32.const 0)
                (i32.load offset=32
                  (local.get $p0))))
            (block $B6
              (block $B7
                (br_if $B7
                  (i32.load offset=20
                    (local.get $p0)))
                (local.set $l2
                  (i32.const -1))
                (br $B6))
              (block $B8
                (br_if $B8
                  (i32.eq
                    (local.tee $l2
                      (i32.load offset=4
                        (local.get $p0)))
                    (local.tee $l3
                      (i32.load offset=8
                        (local.get $p0)))))
                (drop
                  (call_indirect $T0 (type $t1)
                    (local.get $p0)
                    (i64.extend_i32_s
                      (i32.sub
                        (local.get $l2)
                        (local.get $l3)))
                    (i32.const 1)
                    (i32.load offset=36
                      (local.get $p0)))))
              (local.set $l2
                (i32.const 0))
              (i32.store offset=24
                (local.get $p0)
                (i32.const 0))
              (i64.store offset=16
                (local.get $p0)
                (i64.const 0))
              (i64.store offset=4 align=4
                (local.get $p0)
                (i64.const 0)))
            (local.set $l1
              (i32.or
                (local.get $l2)
                (local.get $l1))))
          (br_if $L4
            (local.tee $p0
              (i32.load offset=52
                (local.get $p0))))))
      (call $__ofl_unlock)
      (return
        (local.get $l1)))
    (block $B9
      (br_if $B9
        (i32.eq
          (i32.load offset=20
            (local.get $p0))
          (i32.load offset=24
            (local.get $p0))))
      (drop
        (call_indirect $T0 (type $t0)
          (local.get $p0)
          (i32.const 0)
          (i32.const 0)
          (i32.load offset=32
            (local.get $p0))))
      (br_if $B9
        (i32.load offset=20
          (local.get $p0)))
      (return
        (i32.const -1)))
    (block $B10
      (br_if $B10
        (i32.eq
          (local.tee $l1
            (i32.load offset=4
              (local.get $p0)))
          (local.tee $l2
            (i32.load offset=8
              (local.get $p0)))))
      (drop
        (call_indirect $T0 (type $t1)
          (local.get $p0)
          (i64.extend_i32_s
            (i32.sub
              (local.get $l1)
              (local.get $l2)))
          (i32.const 1)
          (i32.load offset=36
            (local.get $p0)))))
    (i32.store offset=24
      (local.get $p0)
      (i32.const 0))
    (i64.store offset=16
      (local.get $p0)
      (i64.const 0))
    (i64.store offset=4 align=4
      (local.get $p0)
      (i64.const 0))
    (i32.const 0))
  (func $__lseek (type $t1) (param $p0 i32) (param $p1 i64) (param $p2 i32) (result i64)
    (local $l3 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eqz
            (local.tee $p2
              (call $__wasi_fd_seek
                (local.get $p0)
                (local.get $p1)
                (i32.and
                  (local.get $p2)
                  (i32.const 255))
                (i32.add
                  (local.get $l3)
                  (i32.const 8))))))
        (i32.store offset=1780
          (i32.const 0)
          (select
            (i32.const 70)
            (local.get $p2)
            (i32.eq
              (local.get $p2)
              (i32.const 76))))
        (local.set $p1
          (i64.const -1))
        (br $B0))
      (local.set $p1
        (i64.load offset=8
          (local.get $l3))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 16)))
    (local.get $p1))
  (func $__stdio_seek (type $t1) (param $p0 i32) (param $p1 i64) (param $p2 i32) (result i64)
    (call $__lseek
      (i32.load offset=56
        (local.get $p0))
      (local.get $p1)
      (local.get $p2)))
  (func $__ofl_lock (type $t8) (result i32)
    (i32.const 2824))
  (func $__ofl_unlock (type $t7))
  (func $__stdio_exit (type $t7)
    (local $l0 i32) (local $l1 i32) (local $l2 i32)
    (block $B0
      (br_if $B0
        (i32.eqz
          (local.tee $l0
            (i32.load
              (call $__ofl_lock)))))
      (loop $L1
        (block $B2
          (br_if $B2
            (i32.eq
              (i32.load offset=20
                (local.get $l0))
              (i32.load offset=24
                (local.get $l0))))
          (drop
            (call_indirect $T0 (type $t0)
              (local.get $l0)
              (i32.const 0)
              (i32.const 0)
              (i32.load offset=32
                (local.get $l0)))))
        (block $B3
          (br_if $B3
            (i32.eq
              (local.tee $l1
                (i32.load offset=4
                  (local.get $l0)))
              (local.tee $l2
                (i32.load offset=8
                  (local.get $l0)))))
          (drop
            (call_indirect $T0 (type $t1)
              (local.get $l0)
              (i64.extend_i32_s
                (i32.sub
                  (local.get $l1)
                  (local.get $l2)))
              (i32.const 1)
              (i32.load offset=36
                (local.get $l0)))))
        (br_if $L1
          (local.tee $l0
            (i32.load offset=52
              (local.get $l0))))))
    (block $B4
      (br_if $B4
        (i32.eqz
          (local.tee $l0
            (i32.load offset=1144
              (i32.const 0)))))
      (block $B5
        (br_if $B5
          (i32.eq
            (i32.load offset=20
              (local.get $l0))
            (i32.load offset=24
              (local.get $l0))))
        (drop
          (call_indirect $T0 (type $t0)
            (local.get $l0)
            (i32.const 0)
            (i32.const 0)
            (i32.load offset=32
              (local.get $l0)))))
      (br_if $B4
        (i32.eq
          (local.tee $l1
            (i32.load offset=4
              (local.get $l0)))
          (local.tee $l2
            (i32.load offset=8
              (local.get $l0)))))
      (drop
        (call_indirect $T0 (type $t1)
          (local.get $l0)
          (i64.extend_i32_s
            (i32.sub
              (local.get $l1)
              (local.get $l2)))
          (i32.const 1)
          (i32.load offset=36
            (local.get $l0)))))
    (block $B6
      (br_if $B6
        (i32.eqz
          (local.tee $l0
            (i32.load offset=1264
              (i32.const 0)))))
      (block $B7
        (br_if $B7
          (i32.eq
            (i32.load offset=20
              (local.get $l0))
            (i32.load offset=24
              (local.get $l0))))
        (drop
          (call_indirect $T0 (type $t0)
            (local.get $l0)
            (i32.const 0)
            (i32.const 0)
            (i32.load offset=32
              (local.get $l0)))))
      (br_if $B6
        (i32.eq
          (local.tee $l1
            (i32.load offset=4
              (local.get $l0)))
          (local.tee $l2
            (i32.load offset=8
              (local.get $l0)))))
      (drop
        (call_indirect $T0 (type $t1)
          (local.get $l0)
          (i64.extend_i32_s
            (i32.sub
              (local.get $l1)
              (local.get $l2)))
          (i32.const 1)
          (i32.load offset=36
            (local.get $l0)))))
    (block $B8
      (br_if $B8
        (i32.eqz
          (local.tee $l0
            (i32.load offset=1784
              (i32.const 0)))))
      (block $B9
        (br_if $B9
          (i32.eq
            (i32.load offset=20
              (local.get $l0))
            (i32.load offset=24
              (local.get $l0))))
        (drop
          (call_indirect $T0 (type $t0)
            (local.get $l0)
            (i32.const 0)
            (i32.const 0)
            (i32.load offset=32
              (local.get $l0)))))
      (br_if $B8
        (i32.eq
          (local.tee $l1
            (i32.load offset=4
              (local.get $l0)))
          (local.tee $l2
            (i32.load offset=8
              (local.get $l0)))))
      (drop
        (call_indirect $T0 (type $t1)
          (local.get $l0)
          (i64.extend_i32_s
            (i32.sub
              (local.get $l1)
              (local.get $l2)))
          (i32.const 1)
          (i32.load offset=36
            (local.get $l0))))))
  (func $__toread (type $t2) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32)
    (i32.store offset=60
      (local.get $p0)
      (i32.or
        (i32.add
          (local.tee $l1
            (i32.load offset=60
              (local.get $p0)))
          (i32.const -1))
        (local.get $l1)))
    (block $B0
      (br_if $B0
        (i32.eq
          (i32.load offset=20
            (local.get $p0))
          (i32.load offset=24
            (local.get $p0))))
      (drop
        (call_indirect $T0 (type $t0)
          (local.get $p0)
          (i32.const 0)
          (i32.const 0)
          (i32.load offset=32
            (local.get $p0)))))
    (i32.store offset=24
      (local.get $p0)
      (i32.const 0))
    (i64.store offset=16
      (local.get $p0)
      (i64.const 0))
    (block $B1
      (br_if $B1
        (i32.eqz
          (i32.and
            (local.tee $l1
              (i32.load
                (local.get $p0)))
            (i32.const 4))))
      (i32.store
        (local.get $p0)
        (i32.or
          (local.get $l1)
          (i32.const 32)))
      (return
        (i32.const -1)))
    (i32.store offset=8
      (local.get $p0)
      (local.tee $l2
        (i32.add
          (i32.load offset=40
            (local.get $p0))
          (i32.load offset=44
            (local.get $p0)))))
    (i32.store offset=4
      (local.get $p0)
      (local.get $l2))
    (i32.shr_s
      (i32.shl
        (local.get $l1)
        (i32.const 27))
      (i32.const 31)))
  (func $fread (type $t4) (param $p0 i32) (param $p1 i32) (param $p2 i32) (param $p3 i32) (result i32)
    (local $l4 i32) (local $l5 i32) (local $l6 i32)
    (i32.store offset=60
      (local.get $p3)
      (i32.or
        (i32.add
          (local.tee $l4
            (i32.load offset=60
              (local.get $p3)))
          (i32.const -1))
        (local.get $l4)))
    (local.set $l5
      (i32.mul
        (local.get $p2)
        (local.get $p1)))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.ne
            (local.tee $l4
              (i32.load offset=4
                (local.get $p3)))
            (local.tee $l6
              (i32.load offset=8
                (local.get $p3)))))
        (local.set $l4
          (local.get $l5))
        (br $B0))
      (local.set $p0
        (call $memcpy
          (local.get $p0)
          (local.get $l4)
          (local.tee $l6
            (select
              (local.tee $l6
                (i32.sub
                  (local.get $l6)
                  (local.get $l4)))
              (local.get $l5)
              (i32.lt_u
                (local.get $l6)
                (local.get $l5))))))
      (i32.store offset=4
        (local.get $p3)
        (i32.add
          (local.get $l4)
          (local.get $l6)))
      (local.set $l4
        (i32.sub
          (local.get $l5)
          (local.get $l6)))
      (local.set $p0
        (i32.add
          (local.get $p0)
          (local.get $l6))))
    (local.set $l6
      (select
        (local.get $p2)
        (i32.const 0)
        (local.get $p1)))
    (block $B2
      (br_if $B2
        (i32.eqz
          (local.get $l4)))
      (loop $L3
        (block $B4
          (block $B5
            (br_if $B5
              (call $__toread
                (local.get $p3)))
            (br_if $B4
              (local.tee $p2
                (call_indirect $T0 (type $t0)
                  (local.get $p3)
                  (local.get $p0)
                  (local.get $l4)
                  (i32.load offset=28
                    (local.get $p3))))))
          (return
            (i32.div_u
              (i32.sub
                (local.get $l5)
                (local.get $l4))
              (local.get $p1))))
        (local.set $p0
          (i32.add
            (local.get $p0)
            (local.get $p2)))
        (br_if $L3
          (local.tee $l4
            (i32.sub
              (local.get $l4)
              (local.get $p2))))))
    (local.get $l6))
  (func $readv (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (local.set $l4
      (i32.const -1))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.gt_s
            (local.get $p2)
            (i32.const -1)))
        (i32.store offset=1780
          (i32.const 0)
          (i32.const 28))
        (br $B0))
      (block $B2
        (br_if $B2
          (i32.eqz
            (local.tee $p2
              (call $__wasi_fd_read
                (local.get $p0)
                (local.get $p1)
                (local.get $p2)
                (i32.add
                  (local.get $l3)
                  (i32.const 12))))))
        (i32.store offset=1780
          (i32.const 0)
          (local.get $p2))
        (local.set $l4
          (i32.const -1))
        (br $B0))
      (local.set $l4
        (i32.load offset=12
          (local.get $l3))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 16)))
    (local.get $l4))
  (func $read (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (i32.store offset=12
      (local.get $l3)
      (local.get $p2))
    (i32.store offset=8
      (local.get $l3)
      (local.get $p1))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eqz
            (local.tee $p2
              (call $__wasi_fd_read
                (local.get $p0)
                (i32.add
                  (local.get $l3)
                  (i32.const 8))
                (i32.const 1)
                (i32.add
                  (local.get $l3)
                  (i32.const 4))))))
        (i32.store offset=1780
          (i32.const 0)
          (select
            (i32.const 8)
            (local.get $p2)
            (i32.eq
              (local.get $p2)
              (i32.const 76))))
        (local.set $p2
          (i32.const -1))
        (br $B0))
      (local.set $p2
        (i32.load offset=4
          (local.get $l3))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 16)))
    (local.get $p2))
  (func $__stdio_read (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (i32.store
      (local.get $l3)
      (local.get $p1))
    (i32.store offset=12
      (local.get $l3)
      (local.tee $l4
        (i32.load offset=44
          (local.get $p0))))
    (i32.store offset=8
      (local.get $l3)
      (local.tee $l5
        (i32.load offset=40
          (local.get $p0))))
    (i32.store offset=4
      (local.get $l3)
      (local.tee $l6
        (i32.sub
          (local.get $p2)
          (i32.ne
            (local.get $l4)
            (i32.const 0)))))
    (local.set $l7
      (i32.load offset=56
        (local.get $p0)))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eqz
            (local.get $l6)))
        (local.set $l4
          (call $readv
            (local.get $l7)
            (local.get $l3)
            (i32.const 2)))
        (br $B0))
      (local.set $l4
        (call $read
          (local.get $l7)
          (local.get $l5)
          (local.get $l4))))
    (local.set $l6
      (i32.const 0))
    (block $B2
      (block $B3
        (br_if $B3
          (i32.gt_s
            (local.get $l4)
            (i32.const 0)))
        (i32.store
          (local.get $p0)
          (i32.or
            (i32.load
              (local.get $p0))
            (select
              (i32.const 32)
              (i32.const 16)
              (local.get $l4))))
        (br $B2))
      (block $B4
        (br_if $B4
          (i32.gt_u
            (local.get $l4)
            (local.tee $l7
              (i32.load offset=4
                (local.get $l3)))))
        (local.set $l6
          (local.get $l4))
        (br $B2))
      (i32.store offset=4
        (local.get $p0)
        (local.tee $l6
          (i32.load offset=40
            (local.get $p0))))
      (i32.store offset=8
        (local.get $p0)
        (i32.add
          (local.get $l6)
          (i32.sub
            (local.get $l4)
            (local.get $l7))))
      (block $B5
        (br_if $B5
          (i32.eqz
            (i32.load offset=44
              (local.get $p0))))
        (i32.store offset=4
          (local.get $p0)
          (i32.add
            (local.get $l6)
            (i32.const 1)))
        (i32.store8
          (i32.add
            (i32.add
              (local.get $p2)
              (local.get $p1))
            (i32.const -1))
          (i32.load8_u
            (local.get $l6))))
      (local.set $l6
        (local.get $p2)))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 16)))
    (local.get $l6))
  (func $__towrite (type $t2) (param $p0 i32) (result i32)
    (local $l1 i32)
    (i32.store offset=60
      (local.get $p0)
      (i32.or
        (i32.add
          (local.tee $l1
            (i32.load offset=60
              (local.get $p0)))
          (i32.const -1))
        (local.get $l1)))
    (block $B0
      (br_if $B0
        (i32.eqz
          (i32.and
            (local.tee $l1
              (i32.load
                (local.get $p0)))
            (i32.const 8))))
      (i32.store
        (local.get $p0)
        (i32.or
          (local.get $l1)
          (i32.const 32)))
      (return
        (i32.const -1)))
    (i64.store offset=4 align=4
      (local.get $p0)
      (i64.const 0))
    (i32.store offset=24
      (local.get $p0)
      (local.tee $l1
        (i32.load offset=40
          (local.get $p0))))
    (i32.store offset=20
      (local.get $p0)
      (local.get $l1))
    (i32.store offset=16
      (local.get $p0)
      (i32.add
        (local.get $l1)
        (i32.load offset=44
          (local.get $p0))))
    (i32.const 0))
  (func $close (type $t2) (param $p0 i32) (result i32)
    (block $B0
      (br_if $B0
        (local.tee $p0
          (call $__wasi_fd_close
            (local.get $p0))))
      (return
        (i32.const 0)))
    (i32.store offset=1780
      (i32.const 0)
      (local.get $p0))
    (i32.const -1))
  (func $__stdio_close (type $t2) (param $p0 i32) (result i32)
    (call $close
      (i32.load offset=56
        (local.get $p0))))
  (func $writev (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (local.set $l4
      (i32.const -1))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.gt_s
            (local.get $p2)
            (i32.const -1)))
        (i32.store offset=1780
          (i32.const 0)
          (i32.const 28))
        (br $B0))
      (block $B2
        (br_if $B2
          (i32.eqz
            (local.tee $p2
              (call $__wasi_fd_write
                (local.get $p0)
                (local.get $p1)
                (local.get $p2)
                (i32.add
                  (local.get $l3)
                  (i32.const 12))))))
        (i32.store offset=1780
          (i32.const 0)
          (local.get $p2))
        (local.set $l4
          (i32.const -1))
        (br $B0))
      (local.set $l4
        (i32.load offset=12
          (local.get $l3))))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 16)))
    (local.get $l4))
  (func $__stdio_write (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32) (local $l7 i32) (local $l8 i32) (local $l9 i32)
    (global.set $__stack_pointer
      (local.tee $l3
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 16))))
    (i32.store offset=12
      (local.get $l3)
      (local.get $p2))
    (i32.store offset=8
      (local.get $l3)
      (local.get $p1))
    (i32.store
      (local.get $l3)
      (local.tee $p1
        (i32.load offset=24
          (local.get $p0))))
    (i32.store offset=4
      (local.get $l3)
      (local.tee $p1
        (i32.sub
          (i32.load offset=20
            (local.get $p0))
          (local.get $p1))))
    (local.set $l4
      (i32.const 2))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eq
            (local.tee $l5
              (i32.add
                (local.get $p1)
                (local.get $p2)))
            (local.tee $p1
              (call $writev
                (i32.load offset=56
                  (local.get $p0))
                (local.get $l3)
                (i32.const 2)))))
        (local.set $l6
          (local.get $l3))
        (loop $L2
          (block $B3
            (br_if $B3
              (i32.gt_s
                (local.get $p1)
                (i32.const -1)))
            (local.set $p1
              (i32.const 0))
            (i32.store offset=24
              (local.get $p0)
              (i32.const 0))
            (i64.store offset=16
              (local.get $p0)
              (i64.const 0))
            (i32.store
              (local.get $p0)
              (i32.or
                (i32.load
                  (local.get $p0))
                (i32.const 32)))
            (br_if $B0
              (i32.eq
                (local.get $l4)
                (i32.const 2)))
            (local.set $p1
              (i32.sub
                (local.get $p2)
                (i32.load offset=4
                  (local.get $l6))))
            (br $B0))
          (i32.store
            (local.tee $l9
              (i32.add
                (local.get $l6)
                (i32.shl
                  (local.tee $l8
                    (i32.gt_u
                      (local.get $p1)
                      (local.tee $l7
                        (i32.load offset=4
                          (local.get $l6)))))
                  (i32.const 3))))
            (i32.add
              (i32.load
                (local.get $l9))
              (local.tee $l7
                (i32.sub
                  (local.get $p1)
                  (select
                    (local.get $l7)
                    (i32.const 0)
                    (local.get $l8))))))
          (i32.store
            (local.tee $l6
              (i32.add
                (local.get $l6)
                (select
                  (i32.const 12)
                  (i32.const 4)
                  (local.get $l8))))
            (i32.sub
              (i32.load
                (local.get $l6))
              (local.get $l7)))
          (local.set $l6
            (local.get $l9))
          (br_if $L2
            (i32.ne
              (local.tee $l5
                (i32.sub
                  (local.get $l5)
                  (local.get $p1)))
              (local.tee $p1
                (call $writev
                  (i32.load offset=56
                    (local.get $p0))
                  (local.get $l9)
                  (local.tee $l4
                    (i32.sub
                      (local.get $l4)
                      (local.get $l8)))))))))
      (i32.store offset=24
        (local.get $p0)
        (local.tee $p1
          (i32.load offset=40
            (local.get $p0))))
      (i32.store offset=20
        (local.get $p0)
        (local.get $p1))
      (i32.store offset=16
        (local.get $p0)
        (i32.add
          (local.get $p1)
          (i32.load offset=44
            (local.get $p0))))
      (local.set $p1
        (local.get $p2)))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l3)
        (i32.const 16)))
    (local.get $p1))
  (func $__isatty (type $t2) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32)
    (global.set $__stack_pointer
      (local.tee $l1
        (i32.sub
          (global.get $__stack_pointer)
          (i32.const 32))))
    (block $B0
      (block $B1
        (br_if $B1
          (local.tee $p0
            (call $__wasi_fd_fdstat_get
              (local.get $p0)
              (i32.add
                (local.get $l1)
                (i32.const 8)))))
        (local.set $p0
          (i32.const 59))
        (br_if $B1
          (i32.ne
            (i32.load8_u offset=8
              (local.get $l1))
            (i32.const 2)))
        (br_if $B1
          (i32.and
            (i32.load8_u offset=16
              (local.get $l1))
            (i32.const 36)))
        (local.set $l2
          (i32.const 1))
        (br $B0))
      (local.set $l2
        (i32.const 0))
      (i32.store offset=1780
        (i32.const 0)
        (local.get $p0)))
    (global.set $__stack_pointer
      (i32.add
        (local.get $l1)
        (i32.const 32)))
    (local.get $l2))
  (func $__stdout_write (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (i32.store offset=32
      (local.get $p0)
      (i32.const 4))
    (block $B0
      (br_if $B0
        (i32.and
          (i32.load8_u
            (local.get $p0))
          (i32.const 64)))
      (br_if $B0
        (call $__isatty
          (i32.load offset=56
            (local.get $p0))))
      (i32.store offset=64
        (local.get $p0)
        (i32.const -1)))
    (call $__stdio_write
      (local.get $p0)
      (local.get $p1)
      (local.get $p2)))
  (func $memset (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i64)
    (block $B0
      (br_if $B0
        (i32.lt_u
          (local.get $p2)
          (i32.const 33)))
      (memory.fill
        (local.get $p0)
        (local.get $p1)
        (local.get $p2))
      (return
        (local.get $p0)))
    (block $B1
      (br_if $B1
        (i32.eqz
          (local.get $p2)))
      (i32.store8
        (local.get $p0)
        (local.get $p1))
      (i32.store8
        (i32.add
          (local.tee $l3
            (i32.add
              (local.get $p2)
              (local.get $p0)))
          (i32.const -1))
        (local.get $p1))
      (br_if $B1
        (i32.lt_u
          (local.get $p2)
          (i32.const 3)))
      (i32.store8 offset=2
        (local.get $p0)
        (local.get $p1))
      (i32.store8 offset=1
        (local.get $p0)
        (local.get $p1))
      (i32.store8
        (i32.add
          (local.get $l3)
          (i32.const -3))
        (local.get $p1))
      (i32.store8
        (i32.add
          (local.get $l3)
          (i32.const -2))
        (local.get $p1))
      (br_if $B1
        (i32.lt_u
          (local.get $p2)
          (i32.const 7)))
      (i32.store8 offset=3
        (local.get $p0)
        (local.get $p1))
      (i32.store8
        (i32.add
          (local.get $l3)
          (i32.const -4))
        (local.get $p1))
      (br_if $B1
        (i32.lt_u
          (local.get $p2)
          (i32.const 9)))
      (i32.store
        (local.tee $l5
          (i32.add
            (local.get $p0)
            (local.tee $l4
              (i32.and
                (i32.sub
                  (i32.const 0)
                  (local.get $p0))
                (i32.const 3)))))
        (local.tee $l3
          (i32.mul
            (i32.and
              (local.get $p1)
              (i32.const 255))
            (i32.const 16843009))))
      (i32.store
        (i32.add
          (local.tee $p2
            (i32.add
              (local.get $l5)
              (local.tee $p1
                (i32.and
                  (i32.sub
                    (local.get $p2)
                    (local.get $l4))
                  (i32.const -4)))))
          (i32.const -4))
        (local.get $l3))
      (br_if $B1
        (i32.lt_u
          (local.get $p1)
          (i32.const 9)))
      (i32.store offset=8
        (local.get $l5)
        (local.get $l3))
      (i32.store offset=4
        (local.get $l5)
        (local.get $l3))
      (i32.store
        (i32.add
          (local.get $p2)
          (i32.const -8))
        (local.get $l3))
      (i32.store
        (i32.add
          (local.get $p2)
          (i32.const -12))
        (local.get $l3))
      (br_if $B1
        (i32.lt_u
          (local.get $p1)
          (i32.const 25)))
      (i32.store offset=24
        (local.get $l5)
        (local.get $l3))
      (i32.store offset=20
        (local.get $l5)
        (local.get $l3))
      (i32.store offset=16
        (local.get $l5)
        (local.get $l3))
      (i32.store offset=12
        (local.get $l5)
        (local.get $l3))
      (i32.store
        (i32.add
          (local.get $p2)
          (i32.const -16))
        (local.get $l3))
      (i32.store
        (i32.add
          (local.get $p2)
          (i32.const -20))
        (local.get $l3))
      (i32.store
        (i32.add
          (local.get $p2)
          (i32.const -24))
        (local.get $l3))
      (i32.store
        (i32.add
          (local.get $p2)
          (i32.const -28))
        (local.get $l3))
      (br_if $B1
        (i32.lt_u
          (local.tee $p1
            (i32.sub
              (local.get $p1)
              (local.tee $p2
                (i32.or
                  (i32.and
                    (local.get $l5)
                    (i32.const 4))
                  (i32.const 24)))))
          (i32.const 32)))
      (local.set $l6
        (i64.mul
          (i64.extend_i32_u
            (local.get $l3))
          (i64.const 4294967297)))
      (local.set $p2
        (i32.add
          (local.get $l5)
          (local.get $p2)))
      (loop $L2
        (i64.store offset=24
          (local.get $p2)
          (local.get $l6))
        (i64.store offset=16
          (local.get $p2)
          (local.get $l6))
        (i64.store offset=8
          (local.get $p2)
          (local.get $l6))
        (i64.store
          (local.get $p2)
          (local.get $l6))
        (local.set $p2
          (i32.add
            (local.get $p2)
            (i32.const 32)))
        (br_if $L2
          (i32.gt_u
            (local.tee $p1
              (i32.add
                (local.get $p1)
                (i32.const -32)))
            (i32.const 31)))))
    (local.get $p0))
  (func $memcpy (type $t0) (param $p0 i32) (param $p1 i32) (param $p2 i32) (result i32)
    (local $l3 i32) (local $l4 i32) (local $l5 i32) (local $l6 i32)
    (block $B0
      (block $B1
        (block $B2
          (br_if $B2
            (i32.gt_u
              (local.get $p2)
              (i32.const 32)))
          (br_if $B1
            (i32.eqz
              (i32.and
                (local.get $p1)
                (i32.const 3))))
          (br_if $B1
            (i32.eqz
              (local.get $p2)))
          (i32.store8
            (local.get $p0)
            (i32.load8_u
              (local.get $p1)))
          (local.set $l3
            (i32.add
              (local.get $p2)
              (i32.const -1)))
          (local.set $l4
            (i32.add
              (local.get $p0)
              (i32.const 1)))
          (br_if $B0
            (i32.eqz
              (i32.and
                (local.tee $l5
                  (i32.add
                    (local.get $p1)
                    (i32.const 1)))
                (i32.const 3))))
          (br_if $B0
            (i32.eqz
              (local.get $l3)))
          (i32.store8 offset=1
            (local.get $p0)
            (i32.load8_u offset=1
              (local.get $p1)))
          (local.set $l3
            (i32.add
              (local.get $p2)
              (i32.const -2)))
          (local.set $l4
            (i32.add
              (local.get $p0)
              (i32.const 2)))
          (br_if $B0
            (i32.eqz
              (i32.and
                (local.tee $l5
                  (i32.add
                    (local.get $p1)
                    (i32.const 2)))
                (i32.const 3))))
          (br_if $B0
            (i32.eqz
              (local.get $l3)))
          (i32.store8 offset=2
            (local.get $p0)
            (i32.load8_u offset=2
              (local.get $p1)))
          (local.set $l3
            (i32.add
              (local.get $p2)
              (i32.const -3)))
          (local.set $l4
            (i32.add
              (local.get $p0)
              (i32.const 3)))
          (br_if $B0
            (i32.eqz
              (i32.and
                (local.tee $l5
                  (i32.add
                    (local.get $p1)
                    (i32.const 3)))
                (i32.const 3))))
          (br_if $B0
            (i32.eqz
              (local.get $l3)))
          (i32.store8 offset=3
            (local.get $p0)
            (i32.load8_u offset=3
              (local.get $p1)))
          (local.set $l3
            (i32.add
              (local.get $p2)
              (i32.const -4)))
          (local.set $l4
            (i32.add
              (local.get $p0)
              (i32.const 4)))
          (local.set $l5
            (i32.add
              (local.get $p1)
              (i32.const 4)))
          (br $B0))
        (memory.copy
          (local.get $p0)
          (local.get $p1)
          (local.get $p2))
        (return
          (local.get $p0)))
      (local.set $l3
        (local.get $p2))
      (local.set $l4
        (local.get $p0))
      (local.set $l5
        (local.get $p1)))
    (block $B3
      (block $B4
        (br_if $B4
          (local.tee $p2
            (i32.and
              (local.get $l4)
              (i32.const 3))))
        (block $B5
          (block $B6
            (br_if $B6
              (i32.ge_u
                (local.get $l3)
                (i32.const 16)))
            (local.set $p2
              (local.get $l3))
            (br $B5))
          (block $B7
            (br_if $B7
              (i32.and
                (local.tee $p2
                  (i32.add
                    (local.get $l3)
                    (i32.const -16)))
                (i32.const 16)))
            (i64.store align=4
              (local.get $l4)
              (i64.load align=4
                (local.get $l5)))
            (i64.store offset=8 align=4
              (local.get $l4)
              (i64.load offset=8 align=4
                (local.get $l5)))
            (local.set $l4
              (i32.add
                (local.get $l4)
                (i32.const 16)))
            (local.set $l5
              (i32.add
                (local.get $l5)
                (i32.const 16)))
            (local.set $l3
              (local.get $p2)))
          (br_if $B5
            (i32.lt_u
              (local.get $p2)
              (i32.const 16)))
          (local.set $p2
            (local.get $l3))
          (loop $L8
            (i64.store align=4
              (local.get $l4)
              (i64.load align=4
                (local.get $l5)))
            (i64.store offset=8 align=4
              (local.get $l4)
              (i64.load offset=8 align=4
                (local.get $l5)))
            (i64.store offset=16 align=4
              (local.get $l4)
              (i64.load offset=16 align=4
                (local.get $l5)))
            (i64.store offset=24 align=4
              (local.get $l4)
              (i64.load offset=24 align=4
                (local.get $l5)))
            (local.set $l4
              (i32.add
                (local.get $l4)
                (i32.const 32)))
            (local.set $l5
              (i32.add
                (local.get $l5)
                (i32.const 32)))
            (br_if $L8
              (i32.gt_u
                (local.tee $p2
                  (i32.add
                    (local.get $p2)
                    (i32.const -32)))
                (i32.const 15)))))
        (block $B9
          (br_if $B9
            (i32.eqz
              (i32.and
                (local.get $p2)
                (i32.const 8))))
          (i64.store align=4
            (local.get $l4)
            (i64.load align=4
              (local.get $l5)))
          (local.set $l5
            (i32.add
              (local.get $l5)
              (i32.const 8)))
          (local.set $l4
            (i32.add
              (local.get $l4)
              (i32.const 8))))
        (block $B10
          (br_if $B10
            (i32.eqz
              (i32.and
                (local.get $p2)
                (i32.const 4))))
          (i32.store
            (local.get $l4)
            (i32.load
              (local.get $l5)))
          (local.set $l5
            (i32.add
              (local.get $l5)
              (i32.const 4)))
          (local.set $l4
            (i32.add
              (local.get $l4)
              (i32.const 4))))
        (block $B11
          (br_if $B11
            (i32.eqz
              (i32.and
                (local.get $p2)
                (i32.const 2))))
          (i32.store16 align=1
            (local.get $l4)
            (i32.load16_u align=1
              (local.get $l5)))
          (local.set $l4
            (i32.add
              (local.get $l4)
              (i32.const 2)))
          (local.set $l5
            (i32.add
              (local.get $l5)
              (i32.const 2))))
        (br_if $B3
          (i32.eqz
            (i32.and
              (local.get $p2)
              (i32.const 1))))
        (i32.store8
          (local.get $l4)
          (i32.load8_u
            (local.get $l5)))
        (return
          (local.get $p0)))
      (block $B12
        (block $B13
          (block $B14
            (block $B15
              (block $B16
                (br_if $B16
                  (i32.lt_u
                    (local.get $l3)
                    (i32.const 32)))
                (block $B17
                  (block $B18
                    (br_table $B15 $B18 $B17 $B3
                      (i32.add
                        (local.get $p2)
                        (i32.const -1))))
                  (i32.store16 align=1
                    (local.get $l4)
                    (i32.load
                      (local.get $l5)))
                  (i32.store offset=2
                    (local.get $l4)
                    (i32.load align=2
                      (i32.add
                        (local.get $l5)
                        (i32.const 2))))
                  (i64.store offset=6 align=4
                    (local.get $l4)
                    (i64.load align=2
                      (i32.add
                        (local.get $l5)
                        (i32.const 6))))
                  (local.set $p2
                    (i32.add
                      (local.get $l4)
                      (i32.const 18)))
                  (local.set $p1
                    (i32.add
                      (local.get $l5)
                      (i32.const 18)))
                  (local.set $l6
                    (i32.const 14))
                  (local.set $l5
                    (i32.load align=2
                      (i32.add
                        (local.get $l5)
                        (i32.const 14))))
                  (local.set $l3
                    (i32.const 14))
                  (br $B14))
                (i32.store8
                  (local.get $l4)
                  (i32.load
                    (local.get $l5)))
                (i32.store offset=1
                  (local.get $l4)
                  (i32.load align=1
                    (i32.add
                      (local.get $l5)
                      (i32.const 1))))
                (i64.store offset=5 align=4
                  (local.get $l4)
                  (i64.load align=1
                    (i32.add
                      (local.get $l5)
                      (i32.const 5))))
                (local.set $p2
                  (i32.add
                    (local.get $l4)
                    (i32.const 17)))
                (local.set $p1
                  (i32.add
                    (local.get $l5)
                    (i32.const 17)))
                (local.set $l6
                  (i32.const 13))
                (local.set $l5
                  (i32.load align=1
                    (i32.add
                      (local.get $l5)
                      (i32.const 13))))
                (local.set $l3
                  (i32.const 15))
                (br $B14))
              (block $B19
                (block $B20
                  (br_if $B20
                    (i32.and
                      (local.get $l3)
                      (i32.const 16)))
                  (local.set $p2
                    (local.get $l4))
                  (local.set $p1
                    (local.get $l5))
                  (br $B19))
                (i32.store8
                  (local.get $l4)
                  (i32.load8_u
                    (local.get $l5)))
                (i32.store offset=1 align=1
                  (local.get $l4)
                  (i32.load offset=1 align=1
                    (local.get $l5)))
                (i64.store offset=5 align=1
                  (local.get $l4)
                  (i64.load offset=5 align=1
                    (local.get $l5)))
                (i32.store16 offset=13 align=1
                  (local.get $l4)
                  (i32.load16_u offset=13 align=1
                    (local.get $l5)))
                (i32.store8 offset=15
                  (local.get $l4)
                  (i32.load8_u offset=15
                    (local.get $l5)))
                (local.set $p2
                  (i32.add
                    (local.get $l4)
                    (i32.const 16)))
                (local.set $p1
                  (i32.add
                    (local.get $l5)
                    (i32.const 16))))
              (br_if $B13
                (i32.and
                  (local.get $l3)
                  (i32.const 8)))
              (br $B12))
            (i32.store8
              (local.get $l4)
              (local.tee $p2
                (i32.load
                  (local.get $l5))))
            (i32.store8 offset=2
              (local.get $l4)
              (i32.shr_u
                (local.get $p2)
                (i32.const 16)))
            (i32.store8 offset=1
              (local.get $l4)
              (i32.shr_u
                (local.get $p2)
                (i32.const 8)))
            (i32.store offset=3
              (local.get $l4)
              (i32.load align=1
                (i32.add
                  (local.get $l5)
                  (i32.const 3))))
            (i64.store offset=7 align=4
              (local.get $l4)
              (i64.load align=1
                (i32.add
                  (local.get $l5)
                  (i32.const 7))))
            (local.set $p2
              (i32.add
                (local.get $l4)
                (i32.const 19)))
            (local.set $p1
              (i32.add
                (local.get $l5)
                (i32.const 19)))
            (local.set $l6
              (i32.const 15))
            (local.set $l5
              (i32.load align=1
                (i32.add
                  (local.get $l5)
                  (i32.const 15))))
            (local.set $l3
              (i32.const 13)))
          (i32.store
            (i32.add
              (local.get $l4)
              (local.get $l6))
            (local.get $l5)))
        (i64.store align=1
          (local.get $p2)
          (i64.load align=1
            (local.get $p1)))
        (local.set $p2
          (i32.add
            (local.get $p2)
            (i32.const 8)))
        (local.set $p1
          (i32.add
            (local.get $p1)
            (i32.const 8))))
      (block $B21
        (br_if $B21
          (i32.eqz
            (i32.and
              (local.get $l3)
              (i32.const 4))))
        (i32.store align=1
          (local.get $p2)
          (i32.load align=1
            (local.get $p1)))
        (local.set $p2
          (i32.add
            (local.get $p2)
            (i32.const 4)))
        (local.set $p1
          (i32.add
            (local.get $p1)
            (i32.const 4))))
      (block $B22
        (br_if $B22
          (i32.eqz
            (i32.and
              (local.get $l3)
              (i32.const 2))))
        (i32.store16 align=1
          (local.get $p2)
          (i32.load16_u align=1
            (local.get $p1)))
        (local.set $p2
          (i32.add
            (local.get $p2)
            (i32.const 2)))
        (local.set $p1
          (i32.add
            (local.get $p1)
            (i32.const 2))))
      (br_if $B3
        (i32.eqz
          (i32.and
            (local.get $l3)
            (i32.const 1))))
      (i32.store8
        (local.get $p2)
        (i32.load8_u
          (local.get $p1))))
    (local.get $p0))
  (func $strlen (type $t2) (param $p0 i32) (result i32)
    (local $l1 i32) (local $l2 i32)
    (local.set $l1
      (local.get $p0))
    (block $B0
      (block $B1
        (br_if $B1
          (i32.eqz
            (i32.and
              (local.get $p0)
              (i32.const 3))))
        (local.set $l1
          (local.get $p0))
        (br_if $B0
          (i32.eqz
            (i32.load8_u
              (local.get $p0))))
        (br_if $B1
          (i32.eqz
            (i32.and
              (local.tee $l1
                (i32.add
                  (local.get $p0)
                  (i32.const 1)))
              (i32.const 3))))
        (br_if $B0
          (i32.eqz
            (i32.load8_u
              (local.get $l1))))
        (br_if $B1
          (i32.eqz
            (i32.and
              (local.tee $l1
                (i32.add
                  (local.get $p0)
                  (i32.const 2)))
              (i32.const 3))))
        (br_if $B0
          (i32.eqz
            (i32.load8_u
              (local.get $l1))))
        (br_if $B1
          (i32.eqz
            (i32.and
              (local.tee $l1
                (i32.add
                  (local.get $p0)
                  (i32.const 3)))
              (i32.const 3))))
        (br_if $B0
          (i32.eqz
            (i32.load8_u
              (local.get $l1))))
        (local.set $l1
          (i32.add
            (local.get $p0)
            (i32.const 4))))
      (local.set $l1
        (i32.add
          (local.get $l1)
          (i32.const -5)))
      (loop $L2
        (local.set $l2
          (i32.add
            (local.get $l1)
            (i32.const 5)))
        (local.set $l1
          (i32.add
            (local.get $l1)
            (i32.const 4)))
        (br_if $L2
          (i32.eqz
            (i32.and
              (i32.and
                (i32.xor
                  (local.tee $l2
                    (i32.load
                      (local.get $l2)))
                  (i32.const -1))
                (i32.add
                  (local.get $l2)
                  (i32.const -16843009)))
              (i32.const -2139062144)))))
      (loop $L3
        (br_if $L3
          (i32.load8_u
            (local.tee $l1
              (i32.add
                (local.get $l1)
                (i32.const 1)))))))
    (i32.sub
      (local.get $l1)
      (local.get $p0)))
  (table $T0 6 6 funcref)
  (memory $memory (export "memory") 2)
  (global $__stack_pointer (mut i32) (i32.const 69408))
  (elem $e0 (i32.const 1) func $__stdio_close $__stdio_read $__stdio_seek $__stdio_write $__stdout_write)
  (data $.rodata (i32.const 1024) "\08\04\00\00\80\04\00\00")
  (data $.data (i32.const 1032) "\09\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\02\00\00\00\00\00\00\00\03\00\00\00\08\07\00\00\00\04\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\08\04\00\00\00\00\00\00\05\00\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\05\00\00\00\03\00\00\00\18\0b\00\00\00\04\00\00\00\00\00\00\00\00\00\00\01\00\00\00\00\00\00\00\0a\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\80\04\00\00"))
