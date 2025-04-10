#include "driver/gpio.h"
#include "esp_attr.h"
#include "esp_err.h"
#include "esp_sleep.h"
#include "hal/gpio_types.h"
#include "soc/gpio_num.h"
#include "ulp_common_defs.h"
#include "ulp_fsm_common.h"
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <sys/_intsup.h>
#include <sys/unistd.h>
#include <unistd.h>
#include <ulp_program.h>

/*
	ulp_pin_control project puts the ESP32 main core to deep sleep mode every "X" 
	minutes. On every of this sleep modes it will put the GPIO33 to high and low
	alternately
	The variable "selector" that is below must be shared with the .S programs
*/

const gpio_num_t OUTPUT_PIN = GPIO_NUM_2;
RTC_DATA_ATTR int selector = 1; 

// The commented lines below, would not be considered, because these do not appear in the ulp_program.bin.S file

//extern const uint8_t ulp_ulp_program_low_bin_start[] asm("_binary_ulp_ulp_program_low_bin_start");
//extern const uint8_t ulp_ulp_program_low_bin_end[] asm("_binary_ulp_ulp_program_low_bin_end");

// The lines below are based in the names that appear in the ulp_program.bin.S file
extern const uint8_t ulp_program_bin_start[] asm("_binary_ulp_program_bin_start");
extern const uint8_t ulp_program_bin_end[] asm("_binary_ulp_program_bin_end");

void app_main(void)
{
	printf("testing");
	gpio_set_direction(OUTPUT_PIN, GPIO_MODE_DEF_OUTPUT);
	esp_err_t err1 = esp_sleep_enable_timer_wakeup(120*1000000);
	ESP_ERROR_CHECK(err1);
	
	esp_err_t err2 = ulp_load_binary(0, ulp_program_bin_start, (ulp_program_bin_end -ulp_program_bin_start)/sizeof(uint32_t));
	ESP_ERROR_CHECK(err2);
	
	printf("testing");
	
	if (selector == 0) {
		printf("Loading the ULP to make pin low");
		//esp_err_t err2 = ulp_load_binary(0, ulp_program_bin_start, (ulp_program_bin_end -ulp_program_bin_start)/sizeof(uint32_t));
		//ESP_ERROR_CHECK(err2); 
			
		esp_err_t err3 = ulp_run(&ulp_low_entry - RTC_SLOW_MEM);
		ESP_ERROR_CHECK(err3);
		selector = 1;
		esp_deep_sleep_start();
    }else if (selector == 1) {
		printf("Loading the ULP to make pin high");
		//esp_err_t err4 = ulp_load_binary(0, ulp_program_bin_start, (ulp_program_bin_end -ulp_program_bin_start)/sizeof(uint32_t));
		//ESP_ERROR_CHECK(err4); 
			
		esp_err_t err5 = ulp_run(&ulp_high_entry - RTC_SLOW_MEM);
		ESP_ERROR_CHECK(err5);
		selector = 0;
		esp_deep_sleep_start();
	}
	printf("Getting out the sleep mode"); 
}