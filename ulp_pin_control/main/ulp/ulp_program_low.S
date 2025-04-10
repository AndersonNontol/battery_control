#include "soc/rtc_cntl_reg.h"
#include "soc/rtc_io_reg.h"
#include "soc/soc_ulp.h"

// This code will carry GPIO33 pin to LOW

	.bss
	.text

	.global low_entry
	//.global selector
	//.set selector, 0

low_entry:
	// GPIO33 = RTCIO8 = BIT 22 OF R0 --- GPIO02 = RTCIO12 = BIT 26
	//READ_RTC_REG(RTC_GPIO_IN_REG, 26, 1)
	WRITE_RTC_REG(RTC_GPIO_OUT_REG, 26, 1, 0)
