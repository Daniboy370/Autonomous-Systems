/*
 * warning.c
 *
 * Code generation for function 'warning'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "warning.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Variable Definitions */
static emlrtMCInfo emlrtMCI = { 14,    /* lineNo */
  25,                                  /* colNo */
  "warning",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\shared\\coder\\coder\\+coder\\+internal\\warning.m"/* pName */
};

static emlrtMCInfo b_emlrtMCI = { 14,  /* lineNo */
  9,                                   /* colNo */
  "warning",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\shared\\coder\\coder\\+coder\\+internal\\warning.m"/* pName */
};

static emlrtRSInfo fb_emlrtRSI = { 14, /* lineNo */
  "warning",                           /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\shared\\coder\\coder\\+coder\\+internal\\warning.m"/* pathName */
};

/* Function Declarations */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location);
static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location);

/* Function Definitions */
static void b_feval(const emlrtStack *sp, const mxArray *b, const mxArray *c,
                    emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  pArrays[0] = b;
  pArrays[1] = c;
  emlrtCallMATLABR2012b(sp, 0, NULL, 2, pArrays, "feval", true, location);
}

static const mxArray *feval(const emlrtStack *sp, const mxArray *b, const
  mxArray *c, emlrtMCInfo *location)
{
  const mxArray *pArrays[2];
  const mxArray *m4;
  pArrays[0] = b;
  pArrays[1] = c;
  return emlrtCallMATLABR2012b(sp, 1, &m4, 2, pArrays, "feval", true, location);
}

void warning(const emlrtStack *sp)
{
  int32_T i2;
  char_T msgID[27];
  static const char_T cv0[27] = { 'C', 'o', 'd', 'e', 'r', ':', 'M', 'A', 'T',
    'L', 'A', 'B', ':', 's', 'i', 'n', 'g', 'u', 'l', 'a', 'r', 'M', 'a', 't',
    'r', 'i', 'x' };

  const mxArray *y;
  char_T u[7];
  static const char_T cv1[7] = { 'w', 'a', 'r', 'n', 'i', 'n', 'g' };

  const mxArray *m1;
  static const int32_T iv2[2] = { 1, 7 };

  const mxArray *b_y;
  char_T b_u[7];
  static const char_T cv2[7] = { 'm', 'e', 's', 's', 'a', 'g', 'e' };

  static const int32_T iv3[2] = { 1, 7 };

  const mxArray *c_y;
  static const int32_T iv4[2] = { 1, 27 };

  emlrtStack st;
  st.prev = sp;
  st.tls = sp->tls;
  for (i2 = 0; i2 < 27; i2++) {
    msgID[i2] = cv0[i2];
  }

  for (i2 = 0; i2 < 7; i2++) {
    u[i2] = cv1[i2];
  }

  y = NULL;
  m1 = emlrtCreateCharArray(2, iv2);
  emlrtInitCharArrayR2013a(sp, 7, m1, &u[0]);
  emlrtAssign(&y, m1);
  for (i2 = 0; i2 < 7; i2++) {
    b_u[i2] = cv2[i2];
  }

  b_y = NULL;
  m1 = emlrtCreateCharArray(2, iv3);
  emlrtInitCharArrayR2013a(sp, 7, m1, &b_u[0]);
  emlrtAssign(&b_y, m1);
  c_y = NULL;
  m1 = emlrtCreateCharArray(2, iv4);
  emlrtInitCharArrayR2013a(sp, 27, m1, &msgID[0]);
  emlrtAssign(&c_y, m1);
  st.site = &fb_emlrtRSI;
  b_feval(&st, y, feval(&st, b_y, c_y, &emlrtMCI), &b_emlrtMCI);
}

/* End of code generation (warning.c) */
