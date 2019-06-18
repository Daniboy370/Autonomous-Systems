/*
 * HelperUnpackUDP.c
 *
 * Code generation for function 'HelperUnpackUDP'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "HelperUnpackUDP.h"
#include "HelperAircraftKalmanFilterSim_emxutil.h"
#include "error.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Variable Definitions */
static dsp_UDPReceiver_0 hUDPReceiver;
static boolean_T hUDPReceiver_not_empty;
static boolean_T resetSwitch;
static boolean_T pauseSwitch;
static emlrtRSInfo r_emlrtRSI = { 12,  /* lineNo */
  "toLogicalCheck",                    /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\eml\\+coder\\+internal\\toLogicalCheck.m"/* pathName */
};

static emlrtRSInfo s_emlrtRSI = { 70,  /* lineNo */
  "HelperUnpackUDP",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m"/* pathName */
};

static emlrtRSInfo t_emlrtRSI = { 80,  /* lineNo */
  "HelperUnpackUDP",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m"/* pathName */
};

static emlrtRSInfo u_emlrtRSI = { 100, /* lineNo */
  "HelperUnpackUDP",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m"/* pathName */
};

static emlrtRSInfo v_emlrtRSI = { 102, /* lineNo */
  "HelperUnpackUDP",                   /* fcnName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m"/* pathName */
};

static emlrtRTEInfo c_emlrtRTEI = { 15,/* lineNo */
  1,                                   /* colNo */
  "release",                           /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\scomp\\release.m"/* pName */
};

static emlrtRTEInfo d_emlrtRTEI = { 49,/* lineNo */
  20,                                  /* colNo */
  "step",                              /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\eml\\lib\\scomp\\step.m"/* pName */
};

static emlrtBCInfo emlrtBCI = { -1,    /* iFirst */
  -1,                                  /* iLast */
  104,                                 /* lineNo */
  25,                                  /* colNo */
  "",                                  /* aName */
  "HelperUnpackUDP",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo b_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  92,                                  /* lineNo */
  8,                                   /* colNo */
  "",                                  /* aName */
  "HelperUnpackUDP",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo c_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  96,                                  /* lineNo */
  8,                                   /* colNo */
  "",                                  /* aName */
  "HelperUnpackUDP",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m",/* pName */
  0                                    /* checkKind */
};

static emlrtBCInfo d_emlrtBCI = { -1,  /* iFirst */
  -1,                                  /* iLast */
  100,                                 /* lineNo */
  8,                                   /* colNo */
  "",                                  /* aName */
  "HelperUnpackUDP",                   /* fName */
  "C:\\Program Files\\MATLAB\\R2016b\\toolbox\\dsp\\dsputilities\\HelperUnpackUDP.m",/* pName */
  0                                    /* checkKind */
};

/* Function Definitions */
void HelperUnpackUDP(const emlrtStack *sp, real_T paramNew_data[], int32_T
                     paramNew_size[2], boolean_T *simControlFlags_resetObj,
                     boolean_T *simControlFlags_pauseSim, boolean_T
                     *simControlFlags_stopSim)
{
  dsp_UDPReceiver_0 *obj;
  char_T *sErr;
  int32_T samplesRead;
  int32_T loop_ub;
  int32_T i0;
  real_T b_paramNew_data[252];
  int32_T i1;
  emlrtStack st;
  emlrtStack b_st;
  st.prev = sp;
  st.tls = sp->tls;
  b_st.prev = &st;
  b_st.tls = st.tls;
  if (!hUDPReceiver_not_empty) {
    st.site = &s_emlrtRSI;

    /* System object Constructor function: dsp.UDPReceiver */
    hUDPReceiver.S0_isInitialized = 0;
    hUDPReceiver_not_empty = true;
  }

  *simControlFlags_resetObj = false;
  *simControlFlags_pauseSim = pauseSwitch;
  *simControlFlags_stopSim = false;
  st.site = &t_emlrtRSI;
  obj = &hUDPReceiver;
  if (hUDPReceiver.S0_isInitialized != 1) {
    if (hUDPReceiver.S0_isInitialized == 2) {
      emlrtErrorWithMessageIdR2012b(&st, &d_emlrtRTEI,
        "MATLAB:system:runtimeMethodCalledWhenReleasedCodegen", 0);
    }

    obj->S0_isInitialized = 1;

    /* System object Start function: dsp.UDPReceiver */
    sErr = GetErrorBuffer(&obj->W0_NetworkLib[0U]);
    CreateUDPInterface(&obj->W0_NetworkLib[0U]);
    if (*sErr == 0) {
      LibCreate_Network(&obj->W0_NetworkLib[0U], 0, "0.0.0.0", 25000, "0.0.0.0",
                        -1, 400, 8, 0);
    }

    if (*sErr == 0) {
      LibStart(&obj->W0_NetworkLib[0U]);
    }

    if (*sErr != 0) {
      DestroyUDPInterface(&obj->W0_NetworkLib[0U]);
      if (*sErr != 0) {
        PrintError(sErr);
      }
    }
  }

  /* System object Outputs function: dsp.UDPReceiver */
  sErr = GetErrorBuffer(&obj->W0_NetworkLib[0U]);
  obj->O0_Y0.size[0] = 255;
  obj->O0_Y0.size[1] = 1;
  samplesRead = 255;
  LibOutputs_Network(&obj->W0_NetworkLib[0U], &obj->O0_Y0.data[0U], &samplesRead);
  if (*sErr != 0) {
    PrintError(sErr);
  }

  obj->O0_Y0.size[0] = samplesRead;
  obj->O0_Y0.size[1] = 1;
  paramNew_size[0] = obj->O0_Y0.size[0];
  paramNew_size[1] = obj->O0_Y0.size[1];
  loop_ub = obj->O0_Y0.size[0] * obj->O0_Y0.size[1];
  for (i0 = 0; i0 < loop_ub; i0++) {
    paramNew_data[i0] = obj->O0_Y0.data[i0];
  }

  if (!((paramNew_size[0] == 0) || (paramNew_size[1] == 0))) {
    if (muIntScalarMax_sint32(paramNew_size[0], 1) < 4) {
      paramNew_size[0] = 0;
      paramNew_size[1] = 0;
    } else {
      i0 = paramNew_size[0] - 2;
      if (!((i0 >= 1) && (i0 <= paramNew_size[0]))) {
        emlrtDynamicBoundsCheckR2012b(i0, 1, paramNew_size[0], &b_emlrtBCI, sp);
      }

      if (paramNew_data[i0 - 1] != (real_T)resetSwitch) {
        *simControlFlags_resetObj = true;
        resetSwitch = !resetSwitch;
      }

      i0 = paramNew_size[0] - 1;
      if (!((i0 >= 1) && (i0 <= paramNew_size[0]))) {
        emlrtDynamicBoundsCheckR2012b(i0, 1, paramNew_size[0], &c_emlrtBCI, sp);
      }

      if (paramNew_data[i0 - 1] != (real_T)pauseSwitch) {
        pauseSwitch = !pauseSwitch;
        *simControlFlags_pauseSim = pauseSwitch;
      }

      if (!(paramNew_size[0] >= 1)) {
        emlrtDynamicBoundsCheckR2012b(paramNew_size[0], 1, paramNew_size[0],
          &d_emlrtBCI, sp);
      }

      st.site = &u_emlrtRSI;
      if (muDoubleScalarIsNaN(paramNew_data[paramNew_size[0] - 1])) {
        b_st.site = &r_emlrtRSI;
        error(&b_st);
      }

      if (paramNew_data[paramNew_size[0] - 1] != 0.0) {
        *simControlFlags_stopSim = true;
        st.site = &v_emlrtRSI;
        obj = &hUDPReceiver;
        if (hUDPReceiver.S0_isInitialized == 2) {
          emlrtErrorWithMessageIdR2012b(&st, &c_emlrtRTEI,
            "MATLAB:system:runtimeMethodCalledWhenReleasedCodegen", 0);
        }

        /* System object Destructor function: dsp.UDPReceiver */
        if (obj->S0_isInitialized == 1) {
          obj->S0_isInitialized = 2;

          /* System object Terminate function: dsp.UDPReceiver */
          sErr = GetErrorBuffer(&obj->W0_NetworkLib[0U]);
          LibTerminate(&obj->W0_NetworkLib[0U]);
          if (*sErr != 0) {
            PrintError(sErr);
          }

          LibDestroy(&obj->W0_NetworkLib[0U], 0);
          DestroyUDPInterface(&obj->W0_NetworkLib[0U]);
        }
      }

      if (1 > paramNew_size[0] - 3) {
        loop_ub = 0;
      } else {
        loop_ub = paramNew_size[0] - 3;
        if (!((loop_ub >= 1) && (loop_ub <= paramNew_size[0]))) {
          emlrtDynamicBoundsCheckR2012b(loop_ub, 1, paramNew_size[0], &emlrtBCI,
            sp);
        }
      }

      for (i0 = 0; i0 < loop_ub; i0++) {
        b_paramNew_data[i0] = paramNew_data[i0];
      }

      paramNew_size[0] = loop_ub;
      paramNew_size[1] = 1;
      for (i0 = 0; i0 < 1; i0++) {
        for (i1 = 0; i1 < loop_ub; i1++) {
          paramNew_data[i1] = b_paramNew_data[i1];
        }
      }
    }
  }
}

void HelperUnpackUDP_free(void)
{
  dsp_UDPReceiver_0 *obj;
  char_T *sErr;
  obj = &hUDPReceiver;

  /* System object Destructor function: dsp.UDPReceiver */
  if (hUDPReceiver.S0_isInitialized == 1) {
    hUDPReceiver.S0_isInitialized = 2;

    /* System object Terminate function: dsp.UDPReceiver */
    sErr = GetErrorBuffer(&obj->W0_NetworkLib[0U]);
    LibTerminate(&obj->W0_NetworkLib[0U]);
    if (*sErr != 0) {
      PrintError(sErr);
    }

    LibDestroy(&obj->W0_NetworkLib[0U], 0);
    DestroyUDPInterface(&obj->W0_NetworkLib[0U]);
  }
}

void HelperUnpackUDP_init(void)
{
  emxInitStruct_dsp_UDPReceiver_0(&hUDPReceiver);
  hUDPReceiver_not_empty = false;
  resetSwitch = false;
  pauseSwitch = false;
}

void pauseSwitch_not_empty_init(void)
{
}

void resetSwitch_not_empty_init(void)
{
}

/* End of code generation (HelperUnpackUDP.c) */
