//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

@_exported import Dispatch
import CDispatch

//===----------------------------------------------------------------------===//
// Linux-specific overlay layer to compensate for lack of Objective-C
//
//   CDispatch classes and APIs are wrapped in Swift objects/functions
//   to achieve API compatibility with Darwin platforms and integration with
//   Swift retain/release operations.
//
//   Injecting an extra level of wrapping is sub-optimal, but pushing the Swift
//   object model down into the C libdispatch implementation is too invasive
//   a change to undertake at this stage of development.
//===----------------------------------------------------------------------===//


// Define Swift-level class hierarchy for subset of dispatch types
// returned from API methods with DISPATCH_RETURNS_RETAINED

public typealias dispatch_object_t = DispatchObject
public class DispatchObject {
  let cobj:COpaquePointer;

  deinit {
      CDispatch.dispatch_release(_to_dot(cobj))
  }

  init(_ cobj:COpaquePointer) {
    self.cobj = cobj;
  }
}

public typealias dispatch_data_t = DispatchData
public class DispatchData : DispatchObject {
}


public typealias dispatch_group_t = DispatchGroup
public class DispatchGroup : DispatchObject {
}


public typealias dispatch_io_t = DispatchIO
public class DispatchIO : DispatchObject {
}


public typealias dispatch_queue_t = DispatchQueue
public class DispatchQueue : DispatchObject {
}


public typealias dispatch_semaphore_t = DispatchSemaphore
public class DispatchSemaphore : DispatchObject {
}


public typealias dispatch_source_t = DispatchSource
public class DispatchSource : DispatchObject {
}


// base.h -- fine

// time.h -- fine

// object.h

// dispatch_retain/dispatch_release intentionally suppressed.

public func dispatch_get_context(object:dispatch_object_t) -> UnsafeMutablePointer<Void> {
  return CDispatch.dispatch_get_context(_to_dot(object.cobj))
}

public func dispatch_set_context(object:dispatch_object_t, _ context:UnsafeMutablePointer<Void>) -> Void {
  CDispatch.dispatch_set_context(_to_dot(object.cobj), context)
}

public func dispatch_set_finalizer_f(object:dispatch_object_t, 
		                             _ finalizer:dispatch_function_t) -> Void {
  CDispatch.dispatch_set_finalizer_f(_to_dot(object.cobj), finalizer)
}

public func dispatch_suspend(object:dispatch_object_t) -> Void {
  CDispatch.dispatch_suspend(_to_dot(object.cobj))
}  

public func dispatch_resume(object:dispatch_object_t) -> Void {
  CDispatch.dispatch_resume(_to_dot(object.cobj))
}  




















public func dispatch_queue_create(label:UnsafePointer<Int8>,
								  _ attr:dispatch_queue_attr_t) -> dispatch_queue_t! {
  return DispatchQueue(CDispatch.dispatch_queue_create(label, attr))
}


public func dispatch_semaphore_create(value:Int) -> dispatch_semaphore_t! {
  return DispatchSemaphore(CDispatch.dispatch_semaphore_create(value))
}




@_silgen_name("_swift_dispatch_object_type_punner")
internal func _to_dot(x:COpaquePointer) -> CDispatch.dispatch_object_t



/// The type of blocks submitted to dispatch queues, which take no arguments
/// and have no return value.
///
/// The dispatch_block_t typealias is different from usual closures in that it
/// uses @convention(block). This is to avoid unnecessary bridging between
/// C blocks and Swift closures, which interferes with Grand Central Dispatch
/// APIs that depend on the referential identity of a block.
public typealias dispatch_block_t = @convention(block) () -> Void

//===----------------------------------------------------------------------===//
// Macros
// FIXME: rdar://16851050 update API so these import better
//===----------------------------------------------------------------------===//

// dispatch/io.h
public var DISPATCH_IO_STREAM: dispatch_io_type_t {
  return 0
}
public var DISPATCH_IO_RANDOM: dispatch_io_type_t {
  return 1
}

public var DISPATCH_IO_STOP: dispatch_io_close_flags_t {
  return 1
}
public var DISPATCH_IO_STRICT_INTERVAL: dispatch_io_interval_flags_t {
  return 1
}

public var DISPATCH_QUEUE_SERIAL: dispatch_queue_attr_t {
  return nil
}
public var DISPATCH_CURRENT_QUEUE_LABEL: dispatch_queue_t? {
  return nil
}
public var DISPATCH_TARGET_QUEUE_DEFAULT: dispatch_queue_t? {
  return nil
}
public var DISPATCH_QUEUE_PRIORITY_HIGH: dispatch_queue_priority_t {
  return 2
}
public var DISPATCH_QUEUE_PRIORITY_DEFAULT: dispatch_queue_priority_t {
  return 0
}
public var DISPATCH_QUEUE_PRIORITY_LOW: dispatch_queue_priority_t {
  return -2
}
public var DISPATCH_QUEUE_PRIORITY_BACKGROUND: dispatch_queue_priority_t {
  return -32768
}

public var DISPATCH_QUEUE_CONCURRENT: dispatch_queue_attr_t {
  return _swift_dispatch_queue_concurrent()
}

@warn_unused_result
@_silgen_name("_swift_dispatch_queue_concurrent")
internal func _swift_dispatch_queue_concurrent() -> dispatch_queue_attr_t

// dispatch/data.h
public var dispatch_data_empty: dispatch_data_t {
  return _swift_dispatch_data_empty()
}

@warn_unused_result
@_silgen_name("_swift_dispatch_data_empty")
internal func _swift_dispatch_data_empty() -> dispatch_data_t

// dispatch/source.h
// FIXME: DISPATCH_SOURCE_TYPE_*
public var DISPATCH_PROC_EXIT: dispatch_source_proc_flags_t {
  return 0x80000000
}
public var DISPATCH_PROC_FORK: dispatch_source_proc_flags_t { return 0x40000000 }
public var DISPATCH_PROC_EXEC: dispatch_source_proc_flags_t { return 0x20000000 }
public var DISPATCH_PROC_SIGNAL: dispatch_source_proc_flags_t { return 0x08000000 }
public var DISPATCH_VNODE_DELETE: dispatch_source_vnode_flags_t { return 0x1 }
public var DISPATCH_VNODE_WRITE:  dispatch_source_vnode_flags_t { return 0x2 }
public var DISPATCH_VNODE_EXTEND: dispatch_source_vnode_flags_t { return 0x4 }
public var DISPATCH_VNODE_ATTRIB: dispatch_source_vnode_flags_t { return 0x8 }
public var DISPATCH_VNODE_LINK:   dispatch_source_vnode_flags_t { return 0x10 }
public var DISPATCH_VNODE_RENAME: dispatch_source_vnode_flags_t { return 0x20 }
public var DISPATCH_VNODE_REVOKE: dispatch_source_vnode_flags_t { return 0x40 }
public var DISPATCH_TIMER_STRICT: dispatch_source_timer_flags_t { return 1 }

public var DISPATCH_SOURCE_TYPE_DATA_ADD: dispatch_source_type_t {
  return _swift_dispatch_source_type_data_add()
}
public var DISPATCH_SOURCE_TYPE_DATA_OR: dispatch_source_type_t {
  return _swift_dispatch_source_type_data_or()
}
public var DISPATCH_SOURCE_TYPE_READ: dispatch_source_type_t {
  return _swift_dispatch_source_type_read()
}
public var DISPATCH_SOURCE_TYPE_PROC: dispatch_source_type_t {
  return _swift_dispatch_source_type_proc()
}
public var DISPATCH_SOURCE_TYPE_SIGNAL: dispatch_source_type_t {
  return _swift_dispatch_source_type_signal()
}
public var DISPATCH_SOURCE_TYPE_TIMER: dispatch_source_type_t {
  return _swift_dispatch_source_type_timer()
}
public var DISPATCH_SOURCE_TYPE_VNODE: dispatch_source_type_t {
  return _swift_dispatch_source_type_vnode()
}
public var DISPATCH_SOURCE_TYPE_WRITE: dispatch_source_type_t {
  return _swift_dispatch_source_type_write()
}

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_DATA_ADD")
internal func _swift_dispatch_source_type_data_add() -> dispatch_source_type_t

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_DATA_OR")
internal func _swift_dispatch_source_type_data_or() -> dispatch_source_type_t

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_PROC")
internal func _swift_dispatch_source_type_proc() -> dispatch_source_type_t

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_READ")
internal func _swift_dispatch_source_type_read() -> dispatch_source_type_t

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_SIGNAL")
internal func _swift_dispatch_source_type_signal() -> dispatch_source_type_t

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_TIMER")
internal func _swift_dispatch_source_type_timer() -> dispatch_source_type_t

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_VNODE")
internal func _swift_dispatch_source_type_vnode() -> dispatch_source_type_t

@warn_unused_result
@_silgen_name("_swift_dispatch_source_type_WRITE")
internal func _swift_dispatch_source_type_write() -> dispatch_source_type_t

// dispatch/time.h
// DISPATCH_TIME_NOW: ok
// DISPATCH_TIME_FOREVER: ok
