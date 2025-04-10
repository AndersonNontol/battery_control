#include "driver/gpio.h"
#include "esp_sleep.h"
#include "hal/gpio_types.h"
#include "soc/gpio_num.h"
#include "ulp_common_defs.h"
#include "ulp_fsm_common.h"
#include <stdint.h>
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include <ulp_ulp_code.h>

const gpio_num_t OUTPUT_PIN = GPIO_NUM_2;

extern const uint8_t ulp_ulp_code_bin_start[] asm("_binary_ulp_ulp_code_bin_start");
extern const uint8_t ulp_ulp_code_bin_end[] asm("_binary_ulp_ulp_code_bin_end"); 

void app_main(void)
{
	gpio_set_direction(OUTPUT_PIN,GPIO_MODE_DEF_OUTPUT);
	gpio_set_level(OUTPUT_PIN, 1);	

	// Configurations in the main processor
	esp_err_t err1 = esp_sleep_enable_timer_wakeup(5*600000); 
	ESP_ERROR_CHECK(err1); 
	
	// set up the ULP program
	printf("Loading the ULP binary");
	esp_err_t err2 = ulp_load_binary(0, ulp_ulp_code_bin_start, (ulp_ulp_code_bin_end - ulp_ulp_code_bin_start)/sizeof(uint32_t));
	ESP_ERROR_CHECK(err2); 
	
	esp_err_t err3 = ulp_run(&ulp_entry - RTC_SLOW_MEM);
	ESP_ERROR_CHECK(err3); 
	esp_deep_sleep_start();
}