/*
 * KalmanFilter.c
 *
 * Code generation for function 'KalmanFilter'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "KalmanFilter.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Variable Definitions */
static emlrtRTEInfo b_emlrtRTEI = { 305,/* lineNo */
  13,                                  /* colNo */
  "KalmanFilter",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsp\\+dsp\\KalmanFilter.m"/* pName */
};

static emlrtRTEInfo e_emlrtRTEI = { 604,/* lineNo */
  13,                                  /* colNo */
  "KalmanFilter",                      /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsp\\+dsp\\KalmanFilter.m"/* pName */
};

/* Function Definitions */
void KalmanFilter_resetImpl(dsp_KalmanFilter *obj)
{
  int32_T i;
  for (i = 0; i < 4; i++) {
    obj->StateEstimate[i] = obj->privInitialStateEstimate[i];
  }

  for (i = 0; i < 16; i++) {
    obj->ErrorCovarianceEstimate[i] = obj->InitialErrorCovarianceEstimate[i];
  }

  for (i = 0; i < 4; i++) {
    obj->StateEstimatePrior[i] = 0.0;
  }

  for (i = 0; i < 16; i++) {
    obj->ErrorCovarianceEstimatePrior[i] = 0.0;
  }
}

void KalmanFilter_validateInputsImpl(const emlrtStack *sp, const real_T z[2])
{
  boolean_T b[2];
  boolean_T b_b[2];
  int32_T i;
  boolean_T y;
  boolean_T exitg1;
  for (i = 0; i < 2; i++) {
    b[i] = muDoubleScalarIsInf(z[i]);
    b_b[i] = muDoubleScalarIsNaN(z[i]);
  }

  y = true;
  i = 0;
  exitg1 = false;
  while ((!exitg1) && (i < 2)) {
    if (!((!b[i]) && (!b_b[i]))) {
      y = false;
      exitg1 = true;
    } else {
      i++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2012b(sp, &e_emlrtRTEI,
      "dsp:system:KalmanFilter:inputsNotNumericRealFinite", 3, 4, 11,
      "Measurement");
  }
}

void c_KalmanFilter_set_MeasurementN(const emlrtStack *sp, dsp_KalmanFilter *obj,
  const real_T val[4])
{
  boolean_T b[4];
  boolean_T b_b[4];
  int32_T k;
  boolean_T y;
  boolean_T exitg1;
  for (k = 0; k < 4; k++) {
    b[k] = muDoubleScalarIsInf(val[k]);
    b_b[k] = muDoubleScalarIsNaN(val[k]);
  }

  y = true;
  k = 0;
  exitg1 = false;
  while ((!exitg1) && (k < 4)) {
    if (!((!b[k]) && (!b_b[k]))) {
      y = false;
      exitg1 = true;
    } else {
      k++;
    }
  }

  if (!y) {
    emlrtErrorWithMessageIdR2012b(sp, &b_emlrtRTEI,
      "dsp:system:AdaptiveFilter:mustBeNumericSquareMatrix", 3, 4, 26,
      "MeasurementNoiseCovariance");
  }

  for (k = 0; k < 4; k++) {
    obj->MeasurementNoiseCovariance[k] = val[k];
  }
}

/* End of code generation (KalmanFilter.c) */
