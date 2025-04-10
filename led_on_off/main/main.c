#include <stdio.h>
#include <stdbool.h>
#include <unistd.h>

#include "driver/gpio.h"
#include "hal/gpio_types.h"

#define led GPIO_NUM_2

void app_main(void)
{
	gpio_set_direction(led, GPIO_MODE_OUTPUT);
	
    while (true) {
        printf("Hello from app_main!\n");
        
        gpio_set_level(led, 1);
        sleep(5);
        gpio_set_level(led, 0);
        sleep(5);
    }
}
