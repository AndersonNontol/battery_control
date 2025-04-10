#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>
#include "driver/gpio.h"
#include "driver/rtc_io.h"
#include "esp_err.h"
#include "esp_sleep.h"
#include "freertos/idf_additions.h"
#include "freertos/projdefs.h"
#include "hal/gpio_types.h"
#include "hal/rtc_io_types.h"
#include "soc/gpio_num.h"
#include "ulp_common.h"
#include "ulp_common_defs.h"
#include "ulp_fsm_common.h"
#include <esp_log.h>
#include <ulp_main.h>

/* This program is based in this youtube video: https://www.youtube.com/watch?v=KQS_xDDWfLw
There are some slightly changes in order to make the program work. But basically it is the same.
*/

const gpio_num_t BUTTON_PIN = GPIO_NUM_0;
const gpio_num_t LED_PIN = GPIO_NUM_2;


extern const uint8_t ulp_main_bin_start[] asm("_binary_ulp_main_bin_start");
extern const uint8_t ulp_main_bin_end[]   asm("_binary_ulp_main_bin_end");




void app_main(void)
{
   // turn on the LED
   gpio_set_direction(LED_PIN, GPIO_MODE_DEF_OUTPUT);
   gpio_set_level(LED_PIN, 1); 
   
   // did we wake up from the ULP?
   esp_sleep_wakeup_cause_t wake_cause = esp_sleep_get_wakeup_cause();
   if(wake_cause != ESP_SLEEP_WAKEUP_ULP)
   {
	   // we were woken up for some other reason or it's a fresh boot
	   // setup the ULP program
	   printf("Loading the ULP binary");
	   esp_err_t err = ulp_load_binary(0, ulp_main_bin_start, (ulp_main_bin_end - ulp_main_bin_start)/ sizeof(uint32_t));
	   ESP_ERROR_CHECK(err);
   }
   else
   {
	   printf("Woken up by the ULP");
   }
   gpio_set_direction(BUTTON_PIN, GPIO_MODE_INPUT);
   gpio_set_pull_mode(BUTTON_PIN, GPIO_PULLUP_ONLY);
   // wait for the button to be pushed
   printf("Waiting for the button to be pushed");
   while(gpio_get_level(BUTTON_PIN) == 1)
   {
	   vTaskDelay(pdMS_TO_TICKS(100));
   }
   //goto sleep
   printf("Going to sleep");
   esp_err_t err = esp_sleep_enable_ulp_wakeup();
   ESP_ERROR_CHECK(err);
   err = ulp_set_wakeup_period(0, 5000000); // 5 seconds
   ESP_ERROR_CHECK(err);
   err = ulp_run(&ulp_entry - RTC_SLOW_MEM);
   ESP_ERROR_CHECK(err);
   esp_deep_sleep_start();
}
