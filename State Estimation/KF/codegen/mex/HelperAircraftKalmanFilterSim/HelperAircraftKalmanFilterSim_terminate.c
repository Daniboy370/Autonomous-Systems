/*
 * HelperAircraftKalmanFilterSim_terminate.c
 *
 * Code generation for function 'HelperAircraftKalmanFilterSim_terminate'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "HelperAircraftKalmanFilterSim_terminate.h"
#include "HelperUnpackUDP.h"
#include "_coder_HelperAircraftKalmanFilterSim_mex.h"
#include "HelperAircraftKalmanFilterSim_data.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Function Definitions */
void HelperAircraftKalmanFilterSim_atexit(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  mexFunctionCreateRootTLS();
  st.tls = emlrtRootTLSGlobal;
  emlrtEnterRtStackR2012b(&st);
  HelperUnpackUDP_free();
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
  emlrtDestroyArray(&eml_mx);
  emlrtDestroyArray(&b_eml_mx);
}

void HelperAircraftKalmanFilterSim_terminate(void)
{
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;
  emlrtLeaveRtStackR2012b(&st);
  emlrtDestroyRootTLS(&emlrtRootTLSGlobal);
}

/* End of code generation (HelperAircraftKalmanFilterSim_terminate.c) */
