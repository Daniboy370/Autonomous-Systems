@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2016b
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2016b\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=HelperAircraftKalmanFilterMEX
set MEX_NAME=HelperAircraftKalmanFilterMEX
set MEX_EXT=.mexw64
call "C:\PROGRA~1\MATLAB\R2016b\sys\lcc64\lcc64\mex\lcc64opts.bat"
echo # Make settings for HelperAircraftKalmanFilterSim > HelperAircraftKalmanFilterSim_mex.mki
echo COMPILER=%COMPILER%>> HelperAircraftKalmanFilterSim_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> HelperAircraftKalmanFilterSim_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> HelperAircraftKalmanFilterSim_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> HelperAircraftKalmanFilterSim_mex.mki
echo LINKER=%LINKER%>> HelperAircraftKalmanFilterSim_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> HelperAircraftKalmanFilterSim_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> HelperAircraftKalmanFilterSim_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> HelperAircraftKalmanFilterSim_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> HelperAircraftKalmanFilterSim_mex.mki
echo BORLAND=%BORLAND%>> HelperAircraftKalmanFilterSim_mex.mki
echo OMPFLAGS= >> HelperAircraftKalmanFilterSim_mex.mki
echo OMPLINKFLAGS= >> HelperAircraftKalmanFilterSim_mex.mki
echo EMC_COMPILER=lcc64>> HelperAircraftKalmanFilterSim_mex.mki
echo EMC_CONFIG=optim>> HelperAircraftKalmanFilterSim_mex.mki
"C:\Program Files\MATLAB\R2016b\bin\win64\gmake" -B -f HelperAircraftKalmanFilterSim_mex.mk
