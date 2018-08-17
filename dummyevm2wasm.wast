;;
;; Dummy EVM2WASM contract. Just reverts signaling a failure.
;;

(module
  (import "ethereum" "revert" (func $revert (param i32 i32)))
  (memory 1)
  (export "memory" (memory 0))
  (export "main" (func $main))
  (func $main
    (call $revert (i32.const 0) (i32.const 0))))