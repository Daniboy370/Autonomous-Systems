/*
 * KalmanFilter.h
 *
 * Code generation for function 'KalmanFilter'
 *
 */

#ifndef KALMANFILTER_H
#define KALMANFILTER_H

/* Include files */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "rtwtypes.h"
#include "HelperAircraftKalmanFilterSim_types.h"

/* Function Declarations */
extern void KalmanFilter_resetImpl(dsp_KalmanFilter *obj);
extern void KalmanFilter_validateInputsImpl(const emlrtStack *sp, const real_T
  z[2]);
extern void c_KalmanFilter_set_MeasurementN(const emlrtStack *sp,
  dsp_KalmanFilter *obj, const real_T val[4]);

#endif

/* End of code generation (KalmanFilter.h) */
