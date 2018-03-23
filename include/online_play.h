#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <sys/stat.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <curl/curl.h>

#include "crc.h"
#include "ssap_protocol.h"
#include "string_convert.h"
#include "spim.h"
#include "queue.h"
#include "log.h"

#define SONG_FILE_NAME "test.mp3"
#define PLAY_URL_ADDR_MAX_SIZE 100

struct MemoryStruct {
  char *memory;
  size_t size;
};

static bool spim_connected_spis_flag = false;
static sequeue_t *song_data_queue;
static bool download_finish_flag = false;
static uint8_t  long_file_name[FILE_NAME_MAX] = {0};
static uint8_t play_url_addr[PLAY_URL_ADDR_MAX_SIZE] = {0};
static uint8_t *default_play_url_addr = "https://www.topqizhi.com/chengdu.mp3";
static bool set_url_addr_flag = false;
static uint32_t   decoder_type = MP3_DECODER;
static bool pcm2wave_flag = false;
static pthread_mutex_t spi_send_data_mutex = PTHREAD_MUTEX_INITIALIZER;
static uint8_t song_play_status = SSAP_CMD_RESP_UNKOWN;
static uint8_t audio_playing_state = AUDIO_IDLE;

static wav_header_t wave_header = {
    .riff_type = "RIFF",
    .riff_size = 0x000804a4,
    .wave_type = "WAVE",
    .format_type = "fmt ",

    .format_size = 0x10,
    .compression_code = 1, //WAVE_FORMAT_PCM
    .num_channels = 1,
    .sample_rate = 16000,
    .bytes_per_second = 0x7d000000, //通道数×每秒数据位数×每样本的数据位数/8

    .block_align = 0x02,
    .bits_per_sample = 16,
    .data_type = "data",
    .data_size = 0x00080480,
};

void set_audio_state(uint8_t state)；

uint8_t geet_audio_state(void)；
void set_pcm_param(uint8_t param_type, uint16_t param)；

static pthread_t web_download_id;
static pthread_t download_data_to_spim_process_id;
void set_online_play_url(uint8_t *url_addr)；

static handle_response_count = 0;
uint32_t handle_spis_response(bool *frame_end_flag, bool *slice_end_flag,
					SSAPCmdResponseContext handle_response_context, bool data_buffer_flag)；

uint32_t send_command_data_count = 0;
SSAPCmdResponseContext spim_send_command_data(uint8_t *data_buffer, uint32_t buffer_len, uint8_t data_command, uint32_t slice_len)；


/**
 * @brief web downlaod mp3 transfer to spis
 * @param[in]  NONE
 * @param[out] NONE
 */
uint32_t enq_count = 0;
uint32_t deq_count = 0;
static int *fp_mp3 = NULL;
void download_data_to_spim_process_thread(void)；

static size_t WriteMemoryCallback(void *contents, size_t size, size_t nmemb, void *userp)；
/**
 * @brief downlaod mp3
 * @param[in]  NONE
 * @param[out] NONE
 */
void web_download_thread(uint8_t *audio_url_addr)；

void change_play_song_mode_thread()；

void set_sofa_command_thread()；

/**
 * @brief spi master send token to keep touch with spi slave
 * @param[in]  NONE
 * @param[out] NONE
 */
#define SPIM_TOKEN_COMMAND_CONTEXT_SIZE 7
void spim_token_thread(void)；


