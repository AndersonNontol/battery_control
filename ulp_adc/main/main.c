/* ULP Example 

	This code is copied exactly as it appears in GitHub
*/


#include "driver/rtc_io.h"
#include "esp_err.h"
#include "esp_sleep.h"
#include "freertos/idf_additions.h"
#include "soc/gpio_num.h"
#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

#include "ulp/example_config.h"
#include "ulp_adc.h"
#include "ulp_common.h"
#include "ulp_common_defs.h"
#include "ulp_fsm_common.h"
#include "ulp_adc_modified.h"  // There was a problem with the ulp_adc.h file produced after the adc.S file (Reason in adc_modified.S file)

extern const uint8_t ulp_main_bin_start[] asm("_binary_ulp_adc_modified_bin_start");
extern const uint8_t ulp_main_bin_end[] asm("_binary_ulp_adc_modified_bin_end");


/* 	This function is called once after power-on reset, to load ULP program into 
 *	RTC memory and configure the ADC
 */
static void init_ulp_program(void);

/*	This function is called every time before going into deep sleep.
 * 	It starts the ULP program and resets measurement counter.
 */
static void start_ulp_program(void);


void app_main(void)
{
	/* 	If user is using USB-serial-jtag then idf monitor needs some time to 
	 * 	re-connect to the USB port. We wait 1 sec here to allow for it to make the reconnection
	 * 	before we print anything. Otherwise the chip will go back to sleep again before the user 
	 *	has time to monitor any output.
	 */
	 
	 vTaskDelay(pdMS_TO_TICKS(1000));
	 
	 esp_sleep_wakeup_cause_t cause = esp_sleep_get_wakeup_cause();
	 if (cause != ESP_SLEEP_WAKEUP_ULP){
		 printf("Not ULP wakeup \n");
		 init_ulp_program();
	 }else{
		 printf("Deep sleep wakeup \n"); 
		 printf("ULP did %"PRIu32" measurements since last reset\n", ulp_sample_counter & UINT16_MAX);
		 printf("Thresholds: low=%"PRIu32"	high=%"PRIu32"\n", ulp_low_thr, ulp_high_thr);
		 ulp_last_result &= UINT16_MAX;
		 printf("Value=%"PRIu32" was %s threshold\n", ulp_last_result,
		 		ulp_last_result < ulp_low_thr ? "below" : "above");
	 }
	 printf("Entering deep sleep○\n\n");
	 start_ulp_program();
	 ESP_ERROR_CHECK(esp_sleep_enable_ulp_wakeup());
	 
	 #if !CONFIG_IDF_TARGET_ESP32
	 	/* RTC peipheral power domain needs to be kept on to keep SAR ADC related configs during sleep*/
	 	esp_sleep_pd_config(ESP_PD_DOMAIN_RTC_PERIPH, ESP_PD_OPTION_ON);
	 #endif
	 
	 esp_deep_sleep_start();
}

static void init_ulp_program(void)
{
	esp_err_t err = ulp_load_binary(0, ulp_main_bin_start,(ulp_main_bin_end- ulp_main_bin_start)/sizeof(uint32_t));
	ESP_ERROR_CHECK(err);

	ulp_adc_cfg_t cfg = {
		.adc_n		= EXAMPLE_ADC_UNIT,
		.channel	= EXAMPLE_ADC_CHANNEL,
		.width		= EXAMPLE_ADC_WIDTH,
		.atten		= EXAMPLE_ADC_ATTEN,
		.ulp_mode	= ADC_ULP_MODE_FSM,
	};
	 
	ESP_ERROR_CHECK(ulp_adc_init(&cfg));
	
	ulp_low_thr = EXAMPLE_ADC_LOW_TRESHOLD;
	ulp_high_thr = EXAMPLE_ADC_HIGH_TRESHOLD;
	
	/* Set ULP wake up period to 20ms */
	ulp_set_wakeup_period(0, 20000);
	
	#if CONFIG_IDF_TARGET_ESP32
		/*	Disconnect GPIO12 and GPIO15 to remove current drain through
		 * 	pullup/pulldown resistor on modules wich have these (e.g. ESP32-WROVER)
		 * 	GPIO12 may be pulled high to select flash voltage.
		*/
		rtc_gpio_isolate(GPIO_NUM_12);
		rtc_gpio_isolate(GPIO_NUM_15);
	#endif // CONFIG_IDF_TARGET_ESP32
	
	esp_deep_sleep_disable_rom_logging(); // suppress boot messages
}

static void start_ulp_program(void)
{
	/*	Reset sample counter */
	ulp_sample_counter = 0;
	
	/* 	Start the program */
	esp_err_t err = ulp_run(&ulp_entry - RTC_SLOW_MEM);
	ESP_ERROR_CHECK(err);
}
