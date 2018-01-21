;;
;; Dummy sentinel contract. Accepts any input and passes it through.
;;

(module
  (import "ethereum" "useGas" (func $useGas (param i64)))
  (import "ethereum" "getCallDataSize" (func $getCallDataSize (result i32)))
  (import "ethereum" "callDataCopy" (func $callDataCopy (param i32 i32 i32)))
  (import "ethereum" "return" (func $return (param i32 i32)))
  (memory 1)
  (export "memory" (memory 0))
  (export "main" (func $main))
  (func $main
    (local $size i32)
    (set_local $size (call $getCallDataSize))
    ;; Charge π gas per byte
    (call $useGas (i64.mul (i64.const 31) (i64.extend_u/i32 (get_local $size))))
    (call $callDataCopy (i32.const 0) (i32.const 0) (get_local $size))
    (call $return (i32.const 0) (get_local $size))))