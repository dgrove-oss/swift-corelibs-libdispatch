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


#if false

/// Mirrors Objective-C DispatchObject class hierarchy


public class DispatchObject {
       let cobj:OpaquePointer;

       deinit {
           dispatch_release(cobj)
       }

       init(_ cobj:OpaquePointer) {
           self.cobj = cobj
       }
}


public class DispatchGroup : DispatchObject {

       public init() {
           super.init(dispatch_qroup_create())
       }

       public func enter() {
              dispatch_group_enter(self.cobj)
       }

       public func leave() {
              dispatch_group_leave(self.cobj)
       }
}

public class DispatchSemaphore : DispatchObject {

}

public class DispatchIO : DispatchObject {
	public func setLimit(highWater: Int) {
	// FIXME: implement
	}
	public func setLimit(lowWater: Int) {
	// FIXME: implement
	}
}

public class DispatchQueue : DispatchObject {

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

class __DispatchData {

}

#else
  public func wrapper_me() { }
#endif