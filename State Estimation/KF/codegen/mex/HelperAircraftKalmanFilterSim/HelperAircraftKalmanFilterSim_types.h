/*
 * HelperAircraftKalmanFilterSim_types.h
 *
 * Code generation for function 'HelperAircraftKalmanFilterSim'
 *
 */

#ifndef HELPERAIRCRAFTKALMANFILTERSIM_TYPES_H
#define HELPERAIRCRAFTKALMANFILTERSIM_TYPES_H

/* Include files */
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_cell_wrap_3
#define typedef_cell_wrap_3

typedef struct {
  uint32_T f1[8];
} cell_wrap_3;

#endif                                 /*typedef_cell_wrap_3*/

#ifndef typedef_dsp_KalmanFilter
#define typedef_dsp_KalmanFilter

typedef struct {
  int32_T isInitialized;
  boolean_T TunablePropsChanged;
  cell_wrap_3 inputVarSize[1];
  real_T StateTransitionMatrix[16];
  real_T ControlInputMatrix;
  real_T MeasurementMatrix[8];
  real_T ProcessNoiseCovariance[16];
  real_T MeasurementNoiseCovariance[4];
  real_T InitialStateEstimate[4];
  real_T InitialErrorCovarianceEstimate[16];
  boolean_T DisableCorrection;
  real_T StateEstimate[4];
  real_T ErrorCovarianceEstimate[16];
  real_T StateEstimatePrior[4];
  real_T ErrorCovarianceEstimatePrior[16];
  real_T privStateTransitionMatrix[16];
  real_T privMeasurementMatrix[8];
  real_T privProcessNoiseCovariance[16];
  real_T privMeasurementNoiseCovariance[4];
  real_T privInitialStateEstimate[4];
} dsp_KalmanFilter;

#endif                                 /*typedef_dsp_KalmanFilter*/

#ifndef struct_emxArray_real_T_255x1
#define struct_emxArray_real_T_255x1

struct emxArray_real_T_255x1
{
  real_T data[255];
  int32_T size[2];
};

#endif                                 /*struct_emxArray_real_T_255x1*/

#ifndef typedef_emxArray_real_T_255x1
#define typedef_emxArray_real_T_255x1

typedef struct emxArray_real_T_255x1 emxArray_real_T_255x1;

#endif                                 /*typedef_emxArray_real_T_255x1*/

#ifndef struct_dsp_UDPReceiver_0
#define struct_dsp_UDPReceiver_0

struct dsp_UDPReceiver_0
{
  int32_T S0_isInitialized;
  real_T W0_NetworkLib[137];
  emxArray_real_T_255x1 O0_Y0;
};

#endif                                 /*struct_dsp_UDPReceiver_0*/

#ifndef typedef_dsp_UDPReceiver_0
#define typedef_dsp_UDPReceiver_0

typedef struct dsp_UDPReceiver_0 dsp_UDPReceiver_0;

#endif                                 /*typedef_dsp_UDPReceiver_0*/
#endif

/* End of code generation (HelperAircraftKalmanFilterSim_types.h) */
