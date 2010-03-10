
LOCAL_DIR := $(SRCDIR)/8k/venc-omx

#-----------------------------------------------------------------------------
#                 Common definitons
#-----------------------------------------------------------------------------

CFLAGS   := $(QCT_CFLAGS)

CPPFLAGS := $(QCT_CPPFLAGS)
CPPFLAGS += -I$(KERNEL_DIR)/include
CPPFLAGS += -I$(KERNEL_DIR)/arch/arm/include
CPPFLAGS += -DPROFILE_DECODER
CPPFLAGS += -DVENC_MSG_ERROR_ENABLE
CPPFLAGS += -DVENC_MSG_FATAL_ENABLE
CPPFLAGS += -DQCOM_OMX_VENC_EXT
CPPFLAGS += -I$(SRCDIR)/../../opensource/omx/mm-core/omxcore/inc
CPPFLAGS += -I$(LOCAL_DIR)/common/inc
CPPFLAGS += -I$(LOCAL_DIR)/device/inc
CPPFLAGS += -I$(LOCAL_DIR)/omx/inc
CPPFLAGS += -I$(LOCAL_DIR)/test/common/inc
CPPFLAGS += -Du32="unsigned int"

#-----------------------------------------------------------------------------
#             Make the Shared library
#-----------------------------------------------------------------------------

vpath %.c $(LOCAL_DIR)/device/src
vpath %.c $(LOCAL_DIR)/omx/src
vpath %.cpp $(LOCAL_DIR)/omx/src

SRCS := OMX_Venc.cpp
SRCS += OMX_VencBufferManager.cpp
SRCS += venc_device.c

all: libOmxVidEnc.so.$(LIBVER)

MM_VENC_OMX_LDLIBS := -lpthread
MM_VENC_OMX_LDLIBS += -lrt
MM_VENC_OMX_LDLIBS += -lstdc++

libOmxVidEnc.so.$(LIBVER): $(SRCS)
	$(CC) $(CPPFLAGS) $(QCT_CFLAGS_SO) $(QCT_LDFLAGS_SO) -Wl,-soname,libOmxVidEnc.so.$(LIBMAJOR) -o $@ $^ $(MM_VENC_OMX_LDLIBS)

#-----------------------------------------------------------------------------
#             Make the apps-test (mm-venc-omx-test)
#-----------------------------------------------------------------------------

mm-venc-omx-test: libOmxVidEnc.so.$(LIBVER)

all: mm-venc-omx-test

vpath %.c $(LOCAL_DIR)/common/src
vpath %.cpp $(LOCAL_DIR)/test/common/src
vpath %.cpp $(LOCAL_DIR)/test/app/src

MM_VENC_OMX_TEST_LDLIBS := -lpthread
MM_VENC_OMX_TEST_LDLIBS += -ldl
MM_VENC_OMX_TEST_LDLIBS += libOmxVidEnc.so.$(LIBVER)
MM_VENC_OMX_TEST_LDLIBS += $(SYSROOT_DIR)/libOmxCore.so

TEST_SRCS := venctest_App.cpp
TEST_SRCS += venctest_Config.cpp
TEST_SRCS += venctest_Pmem.cpp
TEST_SRCS += venctest_Encoder.cpp
TEST_SRCS += venctest_Script.cpp
TEST_SRCS += venctest_File.cpp
TEST_SRCS += venctest_FileSink.cpp
TEST_SRCS += venctest_Mutex.cpp
TEST_SRCS += venctest_Parser.cpp
TEST_SRCS += venctest_FileSource.cpp
TEST_SRCS += venctest_Queue.cpp
TEST_SRCS += venctest_Signal.cpp
TEST_SRCS += venctest_SignalQueue.cpp
TEST_SRCS += venctest_Sleeper.cpp
TEST_SRCS += venctest_Thread.cpp
TEST_SRCS += venctest_Time.cpp
TEST_SRCS += venctest_StatsThread.cpp
TEST_SRCS += venctest_TestCaseFactory.cpp
TEST_SRCS += venctest_ITestCase.cpp
TEST_SRCS += venctest_TestEncode.cpp
TEST_SRCS += venctest_TestIFrameRequest.cpp
TEST_SRCS += venctest_TestGetSyntaxHdr.cpp
TEST_SRCS += venctest_TestEOS.cpp
TEST_SRCS += venctest_TestChangeQuality.cpp
TEST_SRCS += venctest_TestChangeIntraPeriod.cpp
TEST_SRCS += venctest_TestStateExecutingToIdle.cpp
TEST_SRCS += venctest_TestStatePause.cpp
TEST_SRCS += venctest_TestFlush.cpp
TEST_SRCS += venc_queue.c
TEST_SRCS += venc_semaphore.c
TEST_SRCS += venc_mutex.c
TEST_SRCS += venc_time.c
TEST_SRCS += venc_sleep.c
TEST_SRCS += venc_signal.c
TEST_SRCS += venc_file.c
TEST_SRCS += venc_thread.c

mm-venc-omx-test: $(TEST_SRCS)
	$(CC) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(MM_VENC_OMX_TEST_LDLIBS)

#-----------------------------------------------------------------------------
#                     END
#-----------------------------------------------------------------------------
