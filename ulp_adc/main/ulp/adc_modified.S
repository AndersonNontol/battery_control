/* 	ULP assembly files are passed through C preprocessor first, so include directives
	and C macros may be used in these files

	IMPORTANT: I changed the name of this file from adc.S to adc_modified.S because the main.c
	file needed an ulp_adc.h library that was being confused with the ulp_adc.h header produced
	as a result of the adc.S file. The content of this file does not change compared to the one
	in GitHub.
*/

#include "soc/rtc_cntl_reg.h"
#include "soc/rtc_io_reg.h"
#include "soc/soc_ulp.h"
#include "example_config.h"

	.set adc_channel, EXAMPLE_ADC_CHANNEL

	/* 	Configure the number of ADC samples to average on eache measurement.
		For convenience, make it a power of 2. */
	.set adc_oversampling_factor_log, 2
	.set adc_oversampling_factor, (1 << adc_oversampling_factor_log)

	/*	Define variables, which go into .bss section (zero-initialized data) */
	.bss

	/*	Low threshold of ADC reading.
		Set by the main program. */
	.global low_thr
low_thr: .long 0


	/*	High threshold of ADC reading.
		Set by the main program. */
	.global high_thr
high_thr:
	.long 0

	/*	Counter of measurements done */
	.global sample_counter
sample_counter:
	.long 0

	.global last_result
last_result:
	.long 0


	/*	Code goes into .text section */
	.text
	.global entry
entry:
	/*	increment sample counter */
	move r3, sample_counter
	ld r2, r3, 0
	add r2, r2, 1
	st r2, r3, 0

	/* 	do measuremets using ADC */
	/*	r0 will be used as accumulator */
	move r0, 0
	/*	initialize the loop counter */
	stage_rst
measure:
	/*	measure and add value to accumulator */
	adc r1, 0, adc_channel + 1
	add r0, r0, r1
	/* 	increment loop counter and check exit condition */
	stage_inc 1
	jumps measure, adc_oversampling_factor, lt


	/*	divide accumulator by adc_oversampling_factor.
		Since it is chosen as a power of two, use right shif */
	rsh r0, r0, adc_oversampling_factor_log
	/*	averaged value is now in r0; store it into last_result */
	move r3, last_result
	st r0, r3, 0

	/* compare with low_thr; wake up if value < low_thr */
	move r3, low_thr
	ld r3, r3, 0
	sub r3, r0, r3
	jump wake_up, ov


	/*	compare with high_thr; wake up if value > high_thr */
	move r3, high_thr
	ld r3, r3, 0
	sub r3, r3, r0
	jump wake_up, ov


	/*	value within range, end the program */
	.global exit									// If the program gets this point it doesn't have
exit:												// any chance to get out
	halt


	.global wake_up
wake_up:
	/*	Check if the system can be woken up  */
	READ_RTC_FIELD(RTC_CNTL_LOW_POWER_ST_REG, RTC_CNTL_RDY_FOR_WAKEUP)
	and r0, r0, 1
	jump exit, eq

	/* 	Wake up the SoC, end program */
	wake
	WRITE_RTC_FIELD(RTC_CNTL_STATE0_REG, RTC_CNTL_ULP_CP_SLP_TIMER_EN, 0)
	halt
