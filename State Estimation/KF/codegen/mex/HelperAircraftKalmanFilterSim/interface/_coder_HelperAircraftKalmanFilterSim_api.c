/*
 * _coder_HelperAircraftKalmanFilterSim_api.c
 *
 * Code generation for function '_coder_HelperAircraftKalmanFilterSim_api'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "_coder_HelperAircraftKalmanFilterSim_api.h"
#include "HelperAircraftKalmanFilterSim_data.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Function Declarations */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId);
static const mxArray *b_emlrt_marshallOut(const boolean_T u);
static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId);
static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *XNoise,
  const char_T *identifier);
static const mxArray *emlrt_marshallOut(const real_T u);

/* Function Definitions */
static real_T b_emlrt_marshallIn(const emlrtStack *sp, const mxArray *u, const
  emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = c_emlrt_marshallIn(sp, emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static const mxArray *b_emlrt_marshallOut(const boolean_T u)
{
  const mxArray *y;
  const mxArray *m3;
  y = NULL;
  m3 = emlrtCreateLogicalScalar(u);
  emlrtAssign(&y, m3);
  return y;
}

static real_T c_emlrt_marshallIn(const emlrtStack *sp, const mxArray *src, const
  emlrtMsgIdentifier *msgId)
{
  real_T ret;
  static const int32_T dims = 0;
  emlrtCheckBuiltInR2012b(sp, msgId, src, "double", false, 0U, &dims);
  ret = *(real_T *)mxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T emlrt_marshallIn(const emlrtStack *sp, const mxArray *XNoise,
  const char_T *identifier)
{
  real_T y;
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = identifier;
  thisId.fParent = NULL;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(sp, emlrtAlias(XNoise), &thisId);
  emlrtDestroyArray(&XNoise);
  return y;
}

static const mxArray *emlrt_marshallOut(const real_T u)
{
  const mxArray *y;
  const mxArray *m2;
  y = NULL;
  m2 = emlrtCreateDoubleScalar(u);
  emlrtAssign(&y, m2);
  return y;
}

void HelperAircraftKalmanFilterSim_api(const mxArray * const prhs[5], const
  mxArray *plhs[12])
{
  real_T XNoise;
  real_T YNoise;
  real_T XThrust;
  real_T YThrust;
  real_T Fs;
  real_T trueX;
  real_T trueY;
  real_T noisyX;
  real_T noisyY;
  real_T filteredX;
  real_T filteredY;
  boolean_T pauseSim;
  boolean_T stopSim;
  emlrtStack st = { NULL,              /* site */
    NULL,                              /* tls */
    NULL                               /* prev */
  };

  st.tls = emlrtRootTLSGlobal;

  /* Marshall function inputs */
  XNoise = emlrt_marshallIn(&st, emlrtAliasP(prhs[0]), "XNoise");
  YNoise = emlrt_marshallIn(&st, emlrtAliasP(prhs[1]), "YNoise");
  XThrust = emlrt_marshallIn(&st, emlrtAliasP(prhs[2]), "XThrust");
  YThrust = emlrt_marshallIn(&st, emlrtAliasP(prhs[3]), "YThrust");
  Fs = emlrt_marshallIn(&st, emlrtAliasP(prhs[4]), "Fs");

  /* Invoke the target function */
  HelperAircraftKalmanFilterSim(&st, &XNoise, &YNoise, &XThrust, &YThrust, Fs,
    &trueX, &trueY, &noisyX, &noisyY, &filteredX, &filteredY, &pauseSim,
    &stopSim);

  /* Marshall function outputs */
  plhs[0] = emlrt_marshallOut(trueX);
  plhs[1] = emlrt_marshallOut(trueY);
  plhs[2] = emlrt_marshallOut(noisyX);
  plhs[3] = emlrt_marshallOut(noisyY);
  plhs[4] = emlrt_marshallOut(filteredX);
  plhs[5] = emlrt_marshallOut(filteredY);
  plhs[6] = emlrt_marshallOut(XNoise);
  plhs[7] = emlrt_marshallOut(YNoise);
  plhs[8] = emlrt_marshallOut(XThrust);
  plhs[9] = emlrt_marshallOut(YThrust);
  plhs[10] = b_emlrt_marshallOut(pauseSim);
  plhs[11] = b_emlrt_marshallOut(stopSim);
}

/* End of code generation (_coder_HelperAircraftKalmanFilterSim_api.c) */
