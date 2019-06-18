/*
 * HelperAircraftKalmanFilterSim.h
 *
 * Code generation for function 'HelperAircraftKalmanFilterSim'
 *
 */

#ifndef HELPERAIRCRAFTKALMANFILTERSIM_H
#define HELPERAIRCRAFTKALMANFILTERSIM_H

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
extern void HelperAircraftKalmanFilterSim(const emlrtStack *sp, real_T *XNoise,
  real_T *YNoise, real_T *XThrust, real_T *YThrust, real_T Fs, real_T *trueX,
  real_T *trueY, real_T *noisyX, real_T *noisyY, real_T *filteredX, real_T
  *filteredY, boolean_T *pauseSim, boolean_T *stopSim);
extern void kalmanFilt_not_empty_init(void);

#endif

/* End of code generation (HelperAircraftKalmanFilterSim.h) */
