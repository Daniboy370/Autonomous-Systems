/*
 * HelperAircraftKalmanFilterSim_initialize.c
 *
 * Code generation for function 'HelperAircraftKalmanFilterSim_initialize'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "HelperAircraftKalmanFilterSim_initialize.h"
#include "HelperGenerateRadarData.h"
#include "HelperUnpackUDP.h"
#include "_coder_HelperAircraftKalmanFilterSim_mex.h"
#include "HelperAircraftKalmanFilterSim_data.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Function Declarations */
static void c_HelperAircraftKalmanFilterSim(void);

/* Function Definitions */
static void c_HelperAircraftKalmanFilterSim(void)
{
  const mxArray *m0;
  static const int32_T iv0[2] = { 0, 0 };

  static const int32_T iv1[2] = { 0, 0 };

  emlrtAssignP(&b_eml_mx, NULL);
  emlrtAssignP(&eml_mx, NULL);
  positionPrev_not_empty_init();
  velocityPrev_not_empty_init();
  thrustPrev_not_empty_init();
  pauseSwitch_not_empty_init();
  resetSwitch_not_empty_init();
  kalmanFilt_not_empty_init();
  m0 = emlrtCreateNumericArray(2, iv0, mxDOUBLE_CLASS, mxREAL);
  emlrtAssignP(&b_eml_mx, m0);
  m0 = emlrtCreateCharArray(2, iv1);
  emlrtAssignP(&eml_mx, m0);
  HelperUnpackUDP_init();
  HelperGenerateRadarData_init();
}

void HelperAircraftKalmanFilterSim_initialize(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  emlrtBreakCheckR2012bFlagVar = emlrtGetBreakCheckFlagAddressR2012b();
  st.tls = emlrtRootTLSGlobal;
  emlrtClearAllocCountR2012b(&st, false, 0U, 0);
  emlrtEnterRtStackR2012b(&st);
  emlrtLicenseCheckR2012b(&st, "Signal_Blocks", 2);
  if (emlrtFirstTimeR2012b(emlrtRootTLSGlobal)) {
    c_HelperAircraftKalmanFilterSim();
  }
}

/* End of code generation (HelperAircraftKalmanFilterSim_initialize.c) */
