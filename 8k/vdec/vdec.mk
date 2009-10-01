##############################################################################
#--------------------------------------------------------------------------
#Copyright (c) 2009, Code Aurora Forum. All rights reserved.

#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#    * Neither the name of Code Aurora nor
#      the names of its contributors may be used to endorse or promote
#      products derived from this software without specific prior written
#      permission.

#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
#CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
#EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#--------------------------------------------------------------------------
##############################################################################

LOCAL_DIR := $(SRCDIR)/8k/vdec

#-----------------------------------------------------------------------------
#                 Common definitons
#-----------------------------------------------------------------------------

CFLAGS   := $(QCT_CFLAGS)

CPPFLAGS := $(QCT_CPPFLAGS)
CPPFLAGS += -I$(KERNEL_DIR)/include
CPPFLAGS += -I$(KERNEL_OBJDIR)/include
CPPFLAGS += -I$(KERNEL_OBJDIR)/include2
CPPFLAGS += -I$(LOCAL_DIR)/src
CPPFLAGS += -I$(SYSROOT_INC)/omx-mm-core
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

all: libmm-vdec-omx.so.$(LIBVER)

MM_VDEC_OMX_LDLIBS := -lpthread
MM_VDEC_OMX_LDLIBS += -lrt
MM_VDEC_OMX_LDLIBS += -lstdc++

libmm-vdec-omx.so.$(LIBVER): $(SRCS)
	$(CC) $(CPPFLAGS) $(QCT_CFLAGS_SO) $(QCT_LDFLAGS_SO) -Wl,-soname,libmm-vdec-omx.so.$(LIBMAJOR) -o $@ $^ $(MM_VDEC_OMX_LDLIBS)

#-----------------------------------------------------------------------------
#             Make the apps-test (mm-adec-omxevrc-test)
#-----------------------------------------------------------------------------

mm-vdec-omx-test: libmm-vdec-omx.so.$(LIBVER)

all: mm-vdec-omx-test

vpath %.c $(LOCAL_DIR)/test
vpath %.cpp $(LOCAL_DIR)/test

MM_VDEC_OMX_TEST_LDLIBS := -lpthread
MM_VDEC_OMX_TEST_LDLIBS += -ldl
MM_VDEC_OMX_TEST_LDLIBS += libmm-vdec-omx.so.$(LIBVER)
MM_VDEC_OMX_TEST_LDLIBS += $(SYSROOT_DIR)/libmm-omxcore.so

TEST_SRCS = omx_vdec_test.cpp queue.c

mm-vdec-omx-test: $(TEST_SRCS)
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(MM_VDEC_OMX_TEST_LDLIBS)

#-----------------------------------------------------------------------------
#                     END
#-----------------------------------------------------------------------------
