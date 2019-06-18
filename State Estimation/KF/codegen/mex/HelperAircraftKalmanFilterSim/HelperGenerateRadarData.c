/*
 * HelperGenerateRadarData.c
 *
 * Code generation for function 'HelperGenerateRadarData'
 *
 */

/* Include files */
#include "rt_nonfinite.h"
#include "HelperAircraftKalmanFilterSim.h"
#include "HelperGenerateRadarData.h"
#include "HelperAircraftKalmanFilterSim_data.h"
#include "HostLib_Network.h"
#include "HostLib_rtw.h"

/* Function Definitions */
void HelperGenerateRadarData_init(void)
{
  int32_T i3;

  /*  Initial values  */
  for (i3 = 0; i3 < 2; i3++) {
    thrustPrev[i3] = 0.0;
    velocityPrev[i3] = 4.0 * (real_T)i3;
    positionPrev[i3] = 2000.0 + -6000.0 * (real_T)i3;
  }
}

void positionPrev_not_empty_init(void)
{
}

void thrustPrev_not_empty_init(void)
{
}

void velocityPrev_not_empty_init(void)
{
}

/* End of code generation (HelperGenerateRadarData.c) */
