#include "soc/rtc_cntl_reg.h"
#include "soc/rtc_io_reg.h"
#include "soc/soc_ulp.h"

	.bss
	.text

	.global entry

entry:
	// reset the stage counter
	STAGE_RST
try_wakeup:
	// try 10 times to wake up the chip
	STAGE_INC 1
	// run out of tries?
	JUMPS exit, 10, GT
	// are we ready to wake up?
	READ_RTC_FIELD(RTC_CNTL_LOW_POWER_ST_REG, RTC_CNTL_RDY_FOR_WAKEUP)
	AND r0, r0, 1
	// if not, try again
	JUMP try_wakeup, eq
	WAKE

exit:
	HALT
