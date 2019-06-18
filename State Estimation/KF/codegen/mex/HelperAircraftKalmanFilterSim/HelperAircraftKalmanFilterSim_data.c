/*
 * HelperAircraftKalmanFilterSim_data.c
 *
 * Code generation for function 'HelperAircraftKalmanFilterSim_data'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "HelperAircraftKalmanFilterSim_data.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Variable Definitions */
emlrtCTX emlrtRootTLSGlobal = NULL;
const volatile char_T *emlrtBreakCheckR2012bFlagVar = NULL;
real_T thrustPrev[2];
real_T velocityPrev[2];
real_T positionPrev[2];
const mxArray *eml_mx;
const mxArray *b_eml_mx;
emlrtContext emlrtContextGlobal = { true,/* bFirstTime */
  false,                               /* bInitialized */
  131435U,                             /* fVersionInfo */
  NULL,                                /* fErrorFunction */
  "HelperAircraftKalmanFilterSim",     /* fFunctionName */
  NULL,                                /* fRTCallStack */
  false,                               /* bDebugMode */
  { 3594341889U, 2314118853U, 1362586384U, 2332303851U },/* fSigWrd */
  NULL                                 /* fSigMem */
};

/* End of code generation (HelperAircraftKalmanFilterSim_data.c) */
