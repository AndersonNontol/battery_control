#include "soc/rtc_cntl_reg.h"
#include "soc/rtc_io_reg.h"
#include "soc/soc_ulp.h"

	.bss
	.text
	// According the esp info the internal clock has 150kHz
	// #define DELAY_COUNT 700000
	.set ticks_number, 120
	.global entry
entry: // like turn_on, just to reduce the code
	STAGE_RST
	READ_RTC_REG(RTC_GPIO_IN_REG, 26, 1) 		// RTC_GPIO_IN_NEXT_S = 14, GPIO033 = RTCIO08 = bit 22, GPIO02 = RTCIO12, BIT 26
	JUMPS turn_off, 1, EQ						// If it is turned on, then turn it off
	WRITE_RTC_REG(RTC_GPIO_OUT_REG, 26, 1, 1)	// If it was turned of, then turn it on
	JUMP timer									// Otherwise go to timer
timer:
	STAGE_INC 0.0001									// Increment the stage register by 1
	JUMPS entry, ticks_number, LE				// While stage register is less or equal than ticks_number
turn_off:
	WRITE_RTC_REG(RTC_GPIO_OUT_REG, 26, 1, 0)	// If it was turned on, then turn it off
	JUMP timer									// Otherwise go to timer
