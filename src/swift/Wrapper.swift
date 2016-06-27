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

/// Mirrors Objective-C DispatchObject class hierarchy

public class DispatchObject {
}


public class DispatchGroup : DispatchObject {
	internal let __wrapped:dispatch_group_t;

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
	internal let __wrapped:dispatch_semaphore_t;

	public init(value:Int) {
		__wrapped = dispatch_semaphore_create(value)
	}
}

public class DispatchIO : DispatchObject {
#if false
	public func setLimit(highWater: Int) {
	// FIXME: implement
	}
	public func setLimit(lowWater: Int) {
	// FIXME: implement
	}
#endif
}

public class DispatchQueue : DispatchObject {
	internal let __wrapped:dispatch_queue_t;

	internal init(__label:String, attr:DispatchQueueAttributes) {
		__wrapped = dispatch_queue_create(__label, attr)
	}
}

public class DispatchSourceType : DispatchObject {

}

public class DispatchSource : DispatchObject {

}

public class DispatchSourceMachSend : DispatchSource {

}

public class DispatchSourceMachReceive : DispatchSource {

}

public class DispatchSourceMemoryPressure : DispatchSource {

}

public class DispatchSourceProcess : DispatchSource {

}

public class DispatchSourceTimer : DispatchSource {

}

public class DispatchSourceFileSystemObject : DispatchSource {

}

public class DispatchSourceUserDataAdd : DispatchSource {

}

public class DispatchSourceUserDataOr : DispatchSource {

}


internal enum dispatch_qos_class_t : UInt  {
	case QOS_CLASS_USER_INTERACTIVE = 0x21
	case QOS_CLASS_USER_INITIATED = 0x19
	case QOS_CLASS_DEFAULT = 0x15
	case QOS_CLASS_UTILITY = 0x11
	case QOS_CLASS_BACKGROUND = 0x09
	case QOS_CLASS_UNSPECIFIED = 0x00
}
