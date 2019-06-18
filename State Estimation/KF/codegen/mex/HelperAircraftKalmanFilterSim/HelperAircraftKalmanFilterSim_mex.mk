START_DIR = C:\Users\Daniel\Desktop\ESTIGA~1\KALMAN~1

MATLAB_ROOT = C:\PROGRA~1\MATLAB\R2016b
MAKEFILE = HelperAircraftKalmanFilterSim_mex.mk

include HelperAircraftKalmanFilterSim_mex.mki


SRC_FILES =  \
	HelperAircraftKalmanFilterSim_data.c \
	HelperAircraftKalmanFilterSim_initialize.c \
	HelperAircraftKalmanFilterSim_terminate.c \
	HelperAircraftKalmanFilterSim.c \
	KalmanFilter.c \
	error.c \
	HelperUnpackUDP.c \
	HelperGenerateRadarData.c \
	warning.c \
	_coder_HelperAircraftKalmanFilterSim_info.c \
	_coder_HelperAircraftKalmanFilterSim_api.c \
	_coder_HelperAircraftKalmanFilterSim_mex.c \
	HelperAircraftKalmanFilterSim_emxutil.c \
	HostLib_Network.c \
	HostLib_rtw.c

MEX_FILE_NAME_WO_EXT = HelperAircraftKalmanFilterMEX
MEX_FILE_NAME = $(MEX_FILE_NAME_WO_EXT).mexw64
TARGET = $(MEX_FILE_NAME)

SYS_LIBS = 


#
#====================================================================
# gmake makefile fragment for building MEX functions using LCC
# Copyright 2007-2016 The MathWorks, Inc.
#====================================================================
#
SHELL = cmd
OBJEXT = obj
CC = $(COMPILER)
LD = $(LINKER)
.SUFFIXES: .$(OBJEXT)

OBJLIST += $(SRC_FILES:.c=.$(OBJEXT))
MEXSTUB = $(MEX_FILE_NAME_WO_EXT)2.$(OBJEXT)
LCCSTUB = $(MEX_FILE_NAME_WO_EXT)_lccstub.$(OBJEXT)

target: $(TARGET)

ML_INCLUDES = -I"$(MATLAB_ROOT)\simulink\include"
ML_INCLUDES+= -I"$(MATLAB_ROOT)\toolbox\shared\simtargets"
SYS_INCLUDE = $(ML_INCLUDES)

LCC_ROOT = $(MATLAB_ROOT)\sys\lcc64\lcc64

# Additional includes

SYS_INCLUDE += -I"$(START_DIR)"
SYS_INCLUDE += -I"$(START_DIR)\codegen\mex\HelperAircraftKalmanFilterSim"
SYS_INCLUDE += -I".\interface"
SYS_INCLUDE += -I"$(MATLAB_ROOT)\toolbox\shared\dspblks\extern\include"
SYS_INCLUDE += -I"$(MATLAB_ROOT)\extern\include"
SYS_INCLUDE += -I"."

EML_LIBS = libemlrt.lib libcovrt.lib libut.lib libmwmathutil.lib
SYS_LIBS += $(EML_LIBS)

DIRECTIVES = $(MEX_FILE_NAME_WO_EXT)_mex.def

COMP_FLAGS = $(COMPFLAGS)
LINK_FLAGS0= $(subst $(MEXSTUB),$(LCCSTUB),$(LINKFLAGS))
LINK_FLAGS = $(filter-out "mexFunction.def", $(LINK_FLAGS0))


ifeq ($(EMC_CONFIG),optim)
  COMP_FLAGS += $(OPTIMFLAGS)
  LINK_FLAGS += $(LINKOPTIMFLAGS)
else
  COMP_FLAGS += $(DEBUGFLAGS)
  LINK_FLAGS += $(LINKDEBUGFLAGS)
endif
LINK_FLAGS += -o $(TARGET)
LINK_FLAGS += 

CFLAGS = $(COMP_FLAGS)   $(USER_INCLUDE) $(SYS_INCLUDE)

%.$(OBJEXT) : %.c
	$(CC) $(CFLAGS) "$<"

# Additional sources

%.$(OBJEXT) : $(MATLAB_ROOT)\toolbox\shared\dspblks\extern\src/%.c
	$(CC) -Fo"$@" $(CFLAGS) "$<"

%.$(OBJEXT) : $(START_DIR)/%.c
	$(CC) -Fo"$@" $(CFLAGS) "$<"

%.$(OBJEXT) : $(START_DIR)\codegen\mex\HelperAircraftKalmanFilterSim/%.c
	$(CC) -Fo"$@" $(CFLAGS) "$<"

%.$(OBJEXT) : interface/%.c
	$(CC) -Fo"$@" $(CFLAGS) "$<"



$(LCCSTUB) : $(LCC_ROOT)\mex\lccstub.c
	$(CC) -Fo$(LCCSTUB) $(CFLAGS) "$<"

$(TARGET): $(OBJLIST) $(LCCSTUB) $(MAKEFILE) $(DIRECTIVES)
	$(LD) $(OBJLIST) $(LINK_FLAGS) $(LINKFLAGSPOST) $(SYS_LIBS) $(DIRECTIVES)
	@cmd /C "echo Build completed using compiler $(EMC_COMPILER)"

#====================================================================

