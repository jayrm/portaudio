#!/usr/bin/make -f
#
# makefile to build static libportaudio.a for windows
#
# using mingw-w64 gcc to test freebasic portaudio example on windows
# build with WASAPI and WDMKS api's only.
#
# Note: This is not a full build of all APIs and was tested on Win10 only.
#       Building in with WMME and DS API's cause default API to be one
#       one of these, and while no errors are raised, did not get any sound.
#       Basically, not an expert on this library and so decided to build
#       something that kind of works for testing and playing around but
#       someone that knows more about how this library works would need
#       to have a look getting everything working.  ~ Jeff M
#

CC := gcc
CXX := g++
RM := rm
AR := ar

LIBNAME := portaudio

CFLAGS += -I./include
CFLAGS += -I./src/common
CFLAGS += -I./src/os/win

CFLAGS += -O2 -fno-ident
CFLAGS += -fno-strict-aliasing -frounding-math -fno-math-errno -fwrapv -fno-exceptions -fno-asynchronous-unwind-tables -funwind-tables

# If compiled with -Wall, there are a number of warnings raised in current source
# CFLAGS += -Wall
# CFLAGS += -Wno-maybe-uninitialized
# CFLAGS += -Wno-missing-braces
# CFLAGS += -Wno-switch
# CFLAGS += -Wno-unknown-pragmas
# CFLAGS += -Wno-unused-but-set-variable
# CFLAGS += -Wno-unused-function
# CFLAGS += -Wno-unused-value
# CFLAGS += -Wno-unused-variable

# If compiled with -Wexta, there are a number of warnings raised in current source
# CFLAGS += -Wextra
# CFLAGS += -Wno-unused-parameter
# CFLAGS += -Wno-empty-body
# CFLAGS += -Wno-sign-compare
# CFLAGS += -Wno-missing-field-initializers
# CFLAGS += -Wno-cast-function-type

# portaudio APIs / options to include in the library
# CFLAGS += -DPA_USE_ASIO=1
CFLAGS += -DPA_USE_DS=1
CFLAGS += -DPA_USE_WMME=1
CFLAGS += -DPA_USE_WASAPI=1
CFLAGS += -DPA_USE_WDMKS=1
# CFLAGS += -DPA_USE_SKELETON=1
CFLAGS += -DPAWIN_USE_WDMKS_DEVICE_INFO=1
# CFLAGS += -DPA_ENABLE_DEBUG_OUTPUT=1
# CFLAGS += -DPA_WIN_DS_USE_WMME_TIMER=1
# CFLAGS += -DPA_ENABLE_DEBUG_OUTPUT=1
# CFLAGS += -DPA_LOG_API_CALLS=1

# source files (list taken from msvc/portaudio.dsp)
SRCS := ./src/common/pa_allocation.c
SRCS += ./src/common/pa_converters.c
SRCS += ./src/common/pa_cpuload.c
SRCS += ./src/common/pa_debugprint.c
SRCS += ./src/common/pa_dither.c
SRCS += ./src/common/pa_front.c
SRCS += ./src/common/pa_process.c
SRCS += ./src/common/pa_ringbuffer.c
SRCS += ./src/common/pa_stream.c

# dsound
SRCS += ./src/hostapi/dsound/pa_win_ds.c
SRCS += ./src/hostapi/dsound/pa_win_ds_dynlink.c

# wmme
SRCS += ./src/hostapi/wmme/pa_win_wmme.c

# wasapi
SRCS += ./src/hostapi/wasapi/pa_win_wasapi.c

# wdm-ks
SRCS += ./src/hostapi/wdmks/pa_win_wdmks.c

# win
SRCS += ./src/os/win/pa_win_hostapis.c
SRCS += ./src/os/win/pa_win_util.c
SRCS += ./src/os/win/pa_win_version.c
SRCS += ./src/os/win/pa_win_waveformat.c
SRCS += ./src/os/win/pa_win_wdmks_utils.c
SRCS += ./src/os/win/pa_win_coinitialize.c

# other
# SRCS += ./src/hostapi/skeleton/pa_hostapi_skeleton.c
# SRCS += ./src/os/win/pa_x86_plain_converters.c

OBJS := $(patsubst %.c,%.o,$(SRCS))
OBJS := $(patsubst %.cpp,%.o,$(OBJS))

all: $(OBJS) lib$(LIBNAME).a

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

%.o: %.cpp
	$(CXX) -c $(CFLAGS) $(CPPFLAGS) -o $@ $<

lib$(LIBNAME).a: $(OBJS)
	$(RM) -f $@
	$(AR) rs $@ $(OBJS)

clean:
	$(RM) $(OBJS) lib$(LIBNAME).a
