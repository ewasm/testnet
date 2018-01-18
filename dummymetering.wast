;;
;; Dummy sentinel contract. Accepts any input and passes it through.
;;

(module
  (import "ethereum" "callDataSize" (func $callDataSize (result i32)))
  (import "ethereum" "callDataCopy" (func $callDataCopy (param i32 i32 i32)))
  (import "ethereum" "return" (func $return (param i32 i32)))
  (func $main (export "main")
    (local $size i32)
    (set_local $size (call $callDataSize))
    (call $callDataCopy (i32.const 0) (i32.const 0) (get_local $size))
    (call $return (i32.const 0) (get_local $size))))