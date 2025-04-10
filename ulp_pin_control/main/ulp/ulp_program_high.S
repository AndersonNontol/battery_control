#include "soc/rtc_cntl_reg.h"
#include "soc/rtc_io_reg.h"
#include "soc/soc_ulp.h"

// This code will carry GPIO33 pin to HIGH

	.bss
	.text

	.global high_entry
	//.global selector
	//.set selector, 1

high_entry:
	// GPIO33 = RTCIO8 = BIT 22 OF R0 --- GPIO02 = RTCIO12 = BIT 26
	//READ_RTC_REG(RTC_GPIO_IN_REG, 26, 1)
	WRITE_RTC_REG(RTC_GPIO_OUT_REG, 26, 1, 1)
