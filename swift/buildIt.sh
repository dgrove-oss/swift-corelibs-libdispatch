#/bin/bash

cd Dispatch

# make Dispatch.swiftmodule
$SWIFT_ROOT/bin/swiftc -parse-as-library -I . -emit-module -emit-module-path . -Xcc -fblocks -Xlinker -ldispatch Dispatch.swift

cd ../samples

# compile a test program
$SWIFT_ROOT/bin/swiftc -I ../Dispatch -Xcc -fblocks -Xlinker -lBlocksRuntime -Xlinker -ldispatch average.swift

