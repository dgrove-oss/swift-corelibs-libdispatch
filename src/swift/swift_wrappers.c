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

#include <dispatch/dispatch.h>

DISPATCH_EXPORT
dispatch_queue_attr_t 
_swift_dispatch_queue_serial(void) {
  return DISPATCH_QUEUE_SERIAL;
}

DISPATCH_EXPORT
dispatch_queue_attr_t 
_swift_dispatch_queue_concurrent(void) {
  return DISPATCH_QUEUE_CONCURRENT;
}

DISPATCH_EXPORT
dispatch_data_t
_swift_dispatch_data_empty(void) {
  return dispatch_data_empty;
}

DISPATCH_EXPORT
void
_swift_dispatch_resume_for_queue(dispatch_queue_t obj) {
	dispatch_resume(obj);
}
DISPATCH_EXPORT
void
_swift_dispatch_resume_for_source(dispatch_source_t obj) {
	dispatch_resume(obj);
}

DISPATCH_EXPORT
void
_swift_dispatch_suspend_for_queue(dispatch_queue_t obj) {
	dispatch_suspend(obj);
}
DISPATCH_EXPORT
void
_swift_dispatch_suspend_for_source(dispatch_source_t obj) {
	dispatch_suspend(obj);
}

// RR overloads for dispatch_object_t types exposed in public API
#define OBJECT_T_RR_FUNS(t)				           \
DISPATCH_EXPORT  								   \
void										       \
_swift_dispatch_retain_for_##t(dispatch_##t obj) { \
	dispatch_retain(obj);						   \
}                                                  \
DISPATCH_EXPORT  								   \
void										       \
_swift_dispatch_release_for_##t(dispatch_##t obj) {\
	dispatch_release(obj);						   \
}

OBJECT_T_RR_FUNS(queue_t)
OBJECT_T_RR_FUNS(queue_attr_t)
OBJECT_T_RR_FUNS(group_t)
OBJECT_T_RR_FUNS(source_t)
OBJECT_T_RR_FUNS(semaphore_t)
OBJECT_T_RR_FUNS(io_t)


#define SOURCE(t)                               \
  DISPATCH_EXPORT                               \
  dispatch_source_type_t                        \
  _swift_dispatch_source_type_##t(void) {       \
    return DISPATCH_SOURCE_TYPE_##t;            \
  }

SOURCE(DATA_ADD)
SOURCE(DATA_OR)
SOURCE(PROC)
SOURCE(READ)
SOURCE(SIGNAL)
SOURCE(TIMER)
SOURCE(VNODE)
SOURCE(WRITE)
