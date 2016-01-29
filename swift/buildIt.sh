#/bin/bash

cd Dispatch

# helper functions for decls the swiftc importer doesn't handle
clang -c -fblocks Dispatch.c -o Dispatch.o

# make Dispatch.swiftmodule
$SWIFT_ROOT/bin/swiftc -parse-as-library -I . -emit-module -emit-library -emit-module-path . -Xcc -fblocks -Xlinker Dispatch.o Dispatch.swift -o libDispatchWrapper.so

cd ../samples

# compile a test program
$SWIFT_ROOT/bin/swiftc -I ../Dispatch -Xcc -fblocks -Xlinker -lBlocksRuntime -Xlinker -L../Dispatch -Xlinker -lDispatchWrapper average.swift

