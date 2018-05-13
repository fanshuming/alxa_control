.PHONY: all clean

#export CROSS_COMPILE="/home/fanshuming/qz_proj/qz_mtk_openwrt/openwrt/staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin/"
CROSS_COMPILE=/home/fanshuming/qz_proj/qz_mtk_openwrt/openwrt/staging_dir/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin/
CC=mipsel-openwrt-linux-uclibc-gcc-4.8.3

INSTALL=install
STRIP=mipsel-openwrt-linux-uclibc-strip

LDFLAGS += -L/home/fanshuming/qz_proj/qz_mtk_openwrt/openwrt/build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/c-ares-1.10.0/.libs  -lcares
LDFLAGS += -L/home/fanshuming/qz_proj/qz_mtk_openwrt/openwrt/build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/openssl-1.0.2m  -lssl
LDFLAGS += -L/home/fanshuming/qz_proj/qz_mtk_openwrt/openwrt/build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/openssl-1.0.2m  -lcrypto
LDFLAGS += -L/home/fanshuming/qz_proj/qz_mtk_openwrt/openwrt/build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/mosquitto-ssl/mosquitto-1.4.10/lib -lmosquitto

LDFLAGS += -lpthread -lm

CFLAGS = -I/home/fanshuming/qz_proj/qz_mtk_openwrt/openwrt/build_dir/target-mipsel_24kec+dsp_uClibc-0.9.33.2/mosquitto-ssl/mosquitto-1.4.10/lib -I./include
CFLAGS += -lpthread -lcurl -lmsc -lasound -lm
#CFLAGS += -lpthread -lcurl -lmsc -lasound -lm

all : mosquitto_pub mosquitto_sub

mosquitto_pub : src/pub_client.o src/client_shared.o src/spim.o src/utils.o src/cJSON.o
	#echo "${CROSS_COMPILE}${CC} $^ -o $@ ${LDFLAGS}"
	${CROSS_COMPILE}${CC} $^ -o $@ ${LDFLAGS}

mosquitto_sub : src/sub_client.o src/client_shared.o src/spim.o src/online_play.o src/crc.o src/ssap_protocol.o src/utils.o src/cJSON.o src/pub_client_src.o
	#echo "${CROSS_COMPILE}${CC} $^ -o $@ ${LDFLAGS}"
	${CROSS_COMPILE}${CC} $^ -o $@ ${LDFLAGS}

pub_client.o : src/pub_client.c
	echo "-------------------"
	echo "${CROSS_COMPILE}"
	echo "-------------------"
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@

sub_client.o : src/sub_client.c  include/pub_client_src.h src/pub_client_src.c
	echo "${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@"
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@

client_shared.o : src/client_shared.c include/client_shared.h
	echo "${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@"
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@
spim.o: src/spim.c include/spim.h
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@

online_play.o : src/online_play.c include/online_play.h include/crc.h
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@ 

crc.o : src/crc.c  include/crc.h
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@ 

ssap_protocol.o : src/ssap_protocol.c  include/ssap_protocol.h
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@ 

utils.o : src/utils.c
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@ 

cJSON.o : src/cJSON.c
	${CROSS_COMPILE}${CC} ${CFLAGS} -c $< -o $@ 

install : all
	$(INSTALL) -d ./bin
	echo "$(INSTALL) -s --strip-program=${CROSS_COMPILE}${STRIP} mosquitto_pub bin/mosquitto_pub"
	$(INSTALL) -s --strip-program=${CROSS_COMPILE}${STRIP} mosquitto_pub bin/mosquitto_pub
	$(INSTALL) -s --strip-program=${CROSS_COMPILE}${STRIP} mosquitto_sub bin/mosquitto_sub

uninstall :
	-rm -f bin/mosquitto_pub
	-rm -f bin/mosquitto_sub

reallyclean : clean

clean : 
	-rm -f src/*.o mosquitto_pub mosquitto_sub

