
LOCAL_DIR := $(SRCDIR)/8k/vdec

#-----------------------------------------------------------------------------
#                 Common definitons
#-----------------------------------------------------------------------------

CFLAGS   := $(QCT_CFLAGS)

CPPFLAGS := $(QCT_CPPFLAGS)
CPPFLAGS += -I$(KERNEL_DIR)/include
CPPFLAGS += -I$(KERNEL_DIR)/arch/arm/include
CPPFLAGS += -I$(LOCAL_DIR)/src
CPPFLAGS += -I$(SRCDIR)/../mm-core/omxcore/inc
CPPFLAGS += -DPROFILE_DECODER
CPPFLAGS += -Duint32_t="unsigned int"
CPPFLAGS += -Duint16_t="unsigned short"
CPPFLAGS += -Duint8_t="unsigned char"
CPPFLAGS += -Du32="unsigned int"
CPPFLAGS += -Du8="unsigned char"

#-----------------------------------------------------------------------------
#             Make the Shared library
#-----------------------------------------------------------------------------

vpath %.c $(LOCAL_DIR)/src
vpath %.cpp $(LOCAL_DIR)/src

SRCS := adsp.c
SRCS += pmem.c
SRCS += qutility.c
SRCS += vdec.cpp
SRCS += omx_vdec.cpp
SRCS += omx_vdec_linux.cpp
SRCS += omx_vdec_inpbuf.cpp
SRCS += MP4_Utils.cpp
SRCS += H264_Utils.cpp

all: libOmxVdec.so.$(LIBVER)

MM_VDEC_OMX_LDLIBS := -lpthread
MM_VDEC_OMX_LDLIBS += -lrt
MM_VDEC_OMX_LDLIBS += -lstdc++

libOmxVdec.so.$(LIBVER): $(SRCS)
	$(CC) $(CPPFLAGS) $(QCT_CFLAGS_SO) $(QCT_LDFLAGS_SO) -Wl,-soname,libOmxVdec.so.$(LIBMAJOR) -o $@ $^ $(MM_VDEC_OMX_LDLIBS)

#-----------------------------------------------------------------------------
#             Make the apps-test (mm-vdec-omx-test)
#-----------------------------------------------------------------------------

mm-vdec-omx-test: libOmxVdec.so.$(LIBVER)

all: mm-vdec-omx-test

vpath %.c $(LOCAL_DIR)/test
vpath %.cpp $(LOCAL_DIR)/test

MM_VDEC_OMX_TEST_LDLIBS := -lpthread
MM_VDEC_OMX_TEST_LDLIBS += -ldl
MM_VDEC_OMX_TEST_LDLIBS += libOmxVdec.so.$(LIBVER)
MM_VDEC_OMX_TEST_LDLIBS += $(SYSROOT_DIR)/libOmxCore.so

TEST_SRCS := omx_vdec_test.cpp queue.c
TEST_SRCS += queue.c

mm-vdec-omx-test: $(TEST_SRCS)
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(MM_VDEC_OMX_TEST_LDLIBS)

#-----------------------------------------------------------------------------
#                     END
#-----------------------------------------------------------------------------
