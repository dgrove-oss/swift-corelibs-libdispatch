#
#
#

if SWIFT_INSTALL
dispatchdir=${prefix}/lib/swift/dispatch
else
dispatchdir=$(includedir)/dispatch
endif

dispatch_HEADERS=	\
	base.h			\
	block.h			\
	data.h			\
	dispatch.h		\
	group.h			\
	introspection.h	\
	io.h			\
	module.map		\
	object.h		\
	once.h			\
	queue.h			\
	semaphore.h		\
	source.h		\
	time.h

MODULEMAPS=module.map

if HAVE_SWIFT
SWIFT_M4FLAGS=-DHAVE_SWIFT=true
endif

$(builddir)/module.map:	 $(srcdir)/module.map.in
	m4 $(SWIFT_M4FLAGS) $<  > $@

BUILT_SOURCES=$(MODULEMAPS)
CLEANFILES=$(BUILT_SOURCES)
