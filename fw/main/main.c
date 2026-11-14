#include "config.h"
#include "esp_log.h"
#include "nvs_flash.h"

#define TAG "MAIN"

void app_main(void)
{
    esp_err_t ret = nvs_flash_init();
    if (ret == ESP_ERR_NVS_NO_FREE_PAGES || ret == ESP_ERR_NVS_NEW_VERSION_FOUND) {
        nvs_flash_erase();
        nvs_flash_init();
    }

    ESP_LOGI(TAG, "=== %s fw-v%s ===", PRODUCT_CODE, FW_VERSION);
}
