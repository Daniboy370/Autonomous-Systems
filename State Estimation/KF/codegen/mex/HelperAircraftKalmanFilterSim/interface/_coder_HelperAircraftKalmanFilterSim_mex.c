/*
 * _coder_HelperAircraftKalmanFilterSim_mex.c
 *
 * Code generation for function '_coder_HelperAircraftKalmanFilterSim_mex'
 *
 */

/* Include files */
#include "HelperAircraftKalmanFilterSim.h"
#include "_coder_HelperAircraftKalmanFilterSim_mex.h"
#include "HelperAircraftKalmanFilterSim_terminate.h"
#include "_coder_HelperAircraftKalmanFilterSim_api.h"
#include "HelperAircraftKalmanFilterSim_initialize.h"
#include "HelperAircraftKalmanFilterSim_data.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Function Declarations */
static void d_HelperAircraftKalmanFilterSim(int32_T nlhs, mxArray *plhs[12],
  int32_T nrhs, const mxArray *prhs[5]);

/* Function Definitions */
static void d_HelperAircraftKalmanFilterSim(int32_T nlhs, mxArray *plhs[12],
  int32_T nrhs, const mxArray *prhs[5])
{
  int32_T n;
  const mxArray *inputs[5];
  const mxArray *outputs[12];
  int32_T b_nlhs;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Check for proper number of arguments. */
  if (nrhs != 5) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:WrongNumberOfInputs", 5, 12, 5, 4,
                        29, "HelperAircraftKalmanFilterSim");
  }

  if (nlhs > 12) {
    emlrtErrMsgIdAndTxt(&st, "EMLRT:runTime:TooManyOutputArguments", 3, 4, 29,
                        "HelperAircraftKalmanFilterSim");
  }

  /* Temporary copy for mex inputs. */
  for (n = 0; n < nrhs; n++) {
    inputs[n] = prhs[n];
    if (*emlrtBreakCheckR2012bFlagVar != 0) {
      emlrtBreakCheckR2012b(&st);
    }
  }

  /* Call the function. */
  HelperAircraftKalmanFilterSim_api(inputs, outputs);

  /* Copy over outputs to the caller. */
  if (nlhs < 1) {
    b_nlhs = 1;
  } else {
    b_nlhs = nlhs;
  }

  emlrtReturnArrays(b_nlhs, plhs, outputs);

  /* Module termination. */
  HelperAircraftKalmanFilterSim_terminate();
}

void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs, const mxArray
                 *prhs[])
{
  mexAtExit(HelperAircraftKalmanFilterSim_atexit);

  /* Initialize the memory manager. */
  /* Module initialization. */
  HelperAircraftKalmanFilterSim_initialize();

  /* Dispatch the entry-point. */
  d_HelperAircraftKalmanFilterSim(nlhs, plhs, nrhs, prhs);
}

emlrtCTX mexFunctionCreateRootTLS(void)
{
  emlrtCreateRootTLS(&emlrtRootTLSGlobal, &emlrtContextGlobal, NULL, 1);
  return emlrtRootTLSGlobal;
}

/* End of code generation (_coder_HelperAircraftKalmanFilterSim_mex.c) */
