TOP=../..
include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE

PROD_NAME = basleracA130075gm
PROD_IOC_Linux  += $(PROD_NAME)
PROD_IOC_Darwin += $(PROD_NAME)

# <name>.dbd will be created from <name>Include.dbd
DBD += $(PROD_NAME).dbd
$(PROD_NAME)_DBD += aravisCameraSupport.dbd
$(PROD_NAME)_DBD += ffmpegServer.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
PROD_SRCS += $(PROD_NAME)_registerRecordDeviceDriver.cpp $(PROD_NAME)Main.cpp

# Add locally compiled object code
PROD_LIBS += ffmpegServer
PROD_LIBS += aravisCamera
PROD_LIBS += aravis-0.4
PROD_SYS_LIBS += giomm-2.4

# Add NDPluginDimFei
ifdef DIMFEI
  $(PROD_NAME)_DBD += NDPluginDimFei.dbd
  PROD_LIBS += NDPluginDimFei
endif

include $(ADCORE)/ADApp/commonDriverMakefile

#=============================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

