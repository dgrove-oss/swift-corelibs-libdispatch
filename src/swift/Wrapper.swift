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

import CDispatch

// This file contains declarations that are provided by the
// importer via Dispatch.apinote when the platform has Objective-C support

public class DispatchObject {
	// TODO: add deinit method to invoke dispatch_release on wrapped()

    internal func wrapped() -> dispatch_object_t {
	    assert(false, "should be override in subclass")
	}

	public func setTarget(queue:DispatchQueue) {
		dispatch_set_target_queue(wrapped(), queue.__wrapped)
	}

	public func activate() {
		dispatch_activate(wrapped())
	}

	public func suspend() {
		dispatch_suspend(wrapped())
	}

	public func resume() {
		dispatch_resume(wrapped())
	}		
}


public class DispatchGroup : DispatchObject {
	internal let __wrapped:dispatch_group_t;

	internal override func wrapped() -> dispatch_object_t {
		return _dispatch_pun_group_to_object(__wrapped)
	}

	public override init() {
		__wrapped = dispatch_group_create()
	}

	public func enter() {
		dispatch_group_enter(__wrapped)
	}

	public func leave() {
		dispatch_group_enter(__wrapped)
	}
}

public class DispatchSemaphore : DispatchObject {
	internal let __wrapped: dispatch_semaphore_t;

	internal override func wrapped() -> dispatch_object_t {
		return _dispatch_pun_semaphore_to_object(__wrapped)
	}

	public init(value: Int) {
		__wrapped = dispatch_semaphore_create(value)
	}
}

public class DispatchIO : DispatchObject {
	internal let __wrapped:dispatch_io_t

	internal override func wrapped() -> dispatch_object_t {
		return _dispatch_pun_io_to_object(__wrapped)
	}

	internal init(__type: UInt, fd: Int32, queue: DispatchQueue,
				  handler: (error: Int32) -> Void) {
		__wrapped = dispatch_io_create(__type, fd, queue.__wrapped, handler)
	}

	internal init(__type: UInt, path: UnsafePointer<Int8>, oflag: Int32,
				  mode: mode_t, queue: DispatchQueue, handler: (error: Int32) -> Void) {
		__wrapped = dispatch_io_create_with_path(__type, path, oflag, mode, queue.__wrapped, handler)
	}

	internal init(__type: UInt, io: DispatchIO,
				  queue: DispatchQueue, handler: (error: Int32) -> Void) {
		__wrapped = dispatch_io_create_with_io(__type, io.__wrapped, queue.__wrapped, handler)
	}

	public func barrier(execute: () -> ()) {
		dispatch_io_barrier(self.__wrapped, execute)
	}

	// FIXME: getter:DispatchIO.fileDescriptor(self:) ==> dispatch_io_get_descriptor

	public func setLimit(highWater: Int) {
		dispatch_io_set_high_water(__wrapped, highWater)
	}

	public func setLimit(lowWater: Int) {
		dispatch_io_set_low_water(__wrapped, lowWater)
	}
}

public class DispatchQueue : DispatchObject {
	internal let __wrapped:dispatch_queue_t;

	internal override func wrapped() -> dispatch_object_t {
		return _dispatch_pun_queue_to_object(__wrapped)
	}

	internal init(__label: String, attr: dispatch_queue_attr_t?) {
		__wrapped = dispatch_queue_create(__label, attr)
	}

	internal init(__label: String, attr:  dispatch_queue_attr_t?, queue: DispatchQueue?) {
		__wrapped = dispatch_queue_create_with_target(__label, attr, queue?.__wrapped)
	}

	internal init(queue:dispatch_queue_t) {
		__wrapped = queue
	}

	public func sync(execute workItem: @noescape ()->()) {
		dispatch_sync(self.__wrapped, workItem)
	}
}

public class DispatchSource : DispatchObject,
	DispatchSourceType,	DispatchSourceRead,
	DispatchSourceSignal, DispatchSourceTimer,
	DispatchSourceUserDataAdd, DispatchSourceUserDataOr,
	DispatchSourceFileSystemObject, DispatchSourceWrite {
	internal let __wrapped:dispatch_source_t

	internal override func wrapped() -> dispatch_object_t {
		return _dispatch_pun_source_to_object(__wrapped)
	}

	internal init(source:dispatch_source_t) {
		__wrapped = source
	}
}

public protocol DispatchSourceType {
#if false // crashes the swift compiler
  typealias DispatchSourceHandler = @convention(block) () -> Void

  func setEventHandler(handler: DispatchSourceHandler?)

  func setCancelHandler(handler: DispatchSourceHandler?)

  func setRegistrationHandler(handler: DispatchSourceHandler?)
#endif
  func cancel()

  func resume()

  func suspend()

  var handle: UInt { get }

  var mask: UInt { get }

  var data: UInt { get }

  var isCancelled: Bool { get }
}

public protocol DispatchSourceUserDataAdd : DispatchSourceType {
  func mergeData(value: UInt)
}

public protocol DispatchSourceUserDataOr {
#if false /*FIXME: clashes with UserDataAdd?? */
  func mergeData(value: UInt)
#endif
}

#if HAVE_MACH
public protocol DispatchSourceMachSend : DispatchSourceType {

  public var handle: mach_port_t { get }

  public var data: DispatchSource.MachSendEvent { get }

  public var mask: DispatchSource.MachSendEvent { get }

}
#endif

#if HAVE_MACH
public protocol DispatchSourceMachReceive : DispatchSourceType {
  var handle: mach_port_t { get }
}
#endif

#if HAVE_MACH
public protocol DispatchSourceMemoryPressure : DispatchSourceType {

  public var data: DispatchSource.MemoryPressureEvent { get }

  public var mask: DispatchSource.MemoryPressureEvent { get }

}
#endif

#if HAVE_MACH
public protocol DispatchSourceProcess : DispatchSourceType {
  var handle: pid_t { get }

  var data: DispatchSource.ProcessEvent { get }

  var mask: DispatchSource.ProcessEvent { get }
}
#endif

public protocol DispatchSourceRead : DispatchSourceType {

}

public protocol DispatchSourceSignal : DispatchSourceType {

}

public protocol DispatchSourceTimer : DispatchSourceType {
  func setTimer(start: DispatchTime, leeway: DispatchTimeInterval)

  func setTimer(walltime start: DispatchWallTime, leeway: DispatchTimeInterval)

  func setTimer(start: DispatchTime, interval: DispatchTimeInterval, leeway: DispatchTimeInterval)

  func setTimer(start: DispatchTime, interval: Double, leeway: DispatchTimeInterval)

  func setTimer(walltime start: DispatchWallTime, interval: DispatchTimeInterval, leeway: DispatchTimeInterval)

  func setTimer(walltime start: DispatchWallTime, interval: Double, leeway: DispatchTimeInterval)
}

public protocol DispatchSourceFileSystemObject : DispatchSourceType {
  var handle: Int32 { get }

  var data: DispatchSource.FileSystemEvent { get }

  var mask: DispatchSource.FileSystemEvent { get }
}

public protocol DispatchSourceWrite : DispatchSourceType {

}


internal enum _OSQoSClass : UInt32  {
	case QOS_CLASS_USER_INTERACTIVE = 0x21
	case QOS_CLASS_USER_INITIATED = 0x19
	case QOS_CLASS_DEFAULT = 0x15
	case QOS_CLASS_UTILITY = 0x11
	case QOS_CLASS_BACKGROUND = 0x09
	case QOS_CLASS_UNSPECIFIED = 0x00

	internal init?(qosClass:dispatch_qos_class_t) {
		switch qosClass {
		case 0x21: self = .QOS_CLASS_USER_INTERACTIVE
		case 0x19: self = .QOS_CLASS_USER_INITIATED
		case 0x15: self = .QOS_CLASS_DEFAULT
		case 0x11: self = QOS_CLASS_UTILITY
		case 0x09: self = QOS_CLASS_BACKGROUND
		case 0x00: self = QOS_CLASS_UNSPECIFIED
		default: return nil
		}
	}
}


@_silgen_name("_dispatch_pun_group_to_object")
internal func _dispatch_pun_group_to_object(_ group:dispatch_group_t) -> dispatch_object_t

@_silgen_name("_dispatch_pun_semaphore_to_object")
internal func _dispatch_pun_semaphore_to_object(_ semaphore:dispatch_semaphore_t) -> dispatch_object_t

@_silgen_name("_dispatch_pun_io_to_object")
internal func _dispatch_pun_io_to_object(_ io:dispatch_io_t) -> dispatch_object_t

@_silgen_name("_dispatch_pun_queue_to_object")
internal func _dispatch_pun_queue_to_object(_ queue:dispatch_queue_t) -> dispatch_object_t

@_silgen_name("_dispatch_pun_source_to_object")
internal func _dispatch_pun_source_to_object(_ source:dispatch_source_t) -> dispatch_object_t
