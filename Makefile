#################
# custom ffmpeg #
#################

BUILD_FEATURES += --enable-fontconfig
BUILD_FEATURES += --enable-gmp
BUILD_FEATURES += --enable-gnutls
BUILD_FEATURES += --enable-gpl
BUILD_FEATURES += --enable-libaom
BUILD_FEATURES += --enable-libass
BUILD_FEATURES += --enable-libbluray
BUILD_FEATURES += --enable-libbs2b
BUILD_FEATURES += --enable-libdav1d
BUILD_FEATURES += --enable-libdrm
BUILD_FEATURES += --enable-libfreetype
BUILD_FEATURES += --enable-libfribidi
BUILD_FEATURES += --enable-libmodplug
BUILD_FEATURES += --enable-libmp3lame
BUILD_FEATURES += --enable-libopenjpeg
BUILD_FEATURES += --enable-libopenmpt
BUILD_FEATURES += --enable-libopus
BUILD_FEATURES += --enable-libpulse
BUILD_FEATURES += --enable-librsvg
BUILD_FEATURES += --enable-libsoxr
BUILD_FEATURES += --enable-libsvtav1
BUILD_FEATURES += --enable-libtheora
BUILD_FEATURES += --enable-libv4l2
BUILD_FEATURES += --enable-libvidstab
BUILD_FEATURES += --enable-libvorbis
BUILD_FEATURES += --enable-libvpl
BUILD_FEATURES += --enable-libvpx
BUILD_FEATURES += --enable-libwebp
BUILD_FEATURES += --enable-libx264
BUILD_FEATURES += --enable-libx265
BUILD_FEATURES += --enable-libxcb
BUILD_FEATURES += --enable-libxml2
BUILD_FEATURES += --enable-libxvid
BUILD_FEATURES += --enable-libzimg
BUILD_FEATURES += --enable-lto
BUILD_FEATURES += --enable-opengl
BUILD_FEATURES += --enable-shared
BUILD_FEATURES += --enable-version3

BUILD_PKGS +=	libaom-dev
BUILD_PKGS += libass-dev
BUILD_PKGS += libbluray-dev
BUILD_PKGS += libbs2b-dev
BUILD_PKGS += libbs2b-dev
BUILD_PKGS += libcaca-dev
BUILD_PKGS += libcodec2-dev
BUILD_PKGS += libdav1d-dev
BUILD_PKGS += libdrm-dev
BUILD_PKGS += libfdk-aac-dev
BUILD_PKGS += libflac++-dev
BUILD_PKGS += libflac-dev
BUILD_PKGS += libgnutls28-dev
BUILD_PKGS += libmfx-dev
BUILD_PKGS += libmp3lame-dev
BUILD_PKGS += libogg-dev
BUILD_PKGS += libopenjp2-7-dev
BUILD_PKGS += libopenmpt-dev
BUILD_PKGS += libopenmpt-modplug-dev
BUILD_PKGS += libopus-dev
BUILD_PKGS += librsvg2-dev
BUILD_PKGS += libsdl2-dev
BUILD_PKGS += libshine-dev
BUILD_PKGS += libsnappy-dev
BUILD_PKGS += libsoxr-dev
BUILD_PKGS += libtheora-dev
BUILD_PKGS += libtwolame-dev
BUILD_PKGS += libv4l-dev
BUILD_PKGS += libva-dev
BUILD_PKGS += libvdpau-dev
BUILD_PKGS += libvidstab-dev
BUILD_PKGS += libvorbis-dev
BUILD_PKGS += libvpl-dev
BUILD_PKGS += libvpx-dev
BUILD_PKGS += libwebp-dev
BUILD_PKGS += libx264-dev
BUILD_PKGS += libx265-dev
BUILD_PKGS += libxcb-shape0-dev
BUILD_PKGS += libxcb-shm0-dev
BUILD_PKGS += libxcb-xfixes0-dev
BUILD_PKGS += libxml2-dev
BUILD_PKGS += libxv-dev
BUILD_PKGS += libxvidcore-dev
BUILD_PKGS += libxvmc-dev
BUILD_PKGS += libzimg-dev
BUILD_PKGS += libzmq3-dev
BUILD_PKGS += libzvbi-dev

RUN_PKGS += build-essential
RUN_PKGS += cmake
RUN_PKGS += git
RUN_PKGS += nasm
RUN_PKGS += libvpl2
RUN_PKGS += libflac8

BUILD_DIR_FFMPEG := $(BUILD_DIR)/ffmpeg
BUILD_DIR_AV1CODEC := $(BUILD_DIR)/av1_codec

NPROC := $(shell nproc)
NPROC ?= 2

LD_LIBRARY_PATH += ":/usr/local/lib"
PKG_CONFIG_PATH += ":/usr/local/lib/pkgconfig"

$(BUILD_DIR):
	mkdir -p $@

.PHONY: install_codec
install_codec: $(BUILD_DIR_AV1CODEC)
$(BUILD_DIR_AV1CODEC): $(BUILD_DIR)
	rm -rf $@
	git clone --depth=1 https://gitlab.com/AOMediaCodec/SVT-AV1.git $@
	cd $@/Build && \
		cmake .. -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release;
	$(MAKE) -j $(NPROC) -C $@/Build
	cd $@/Build; make install

.PHONY: install_ffmpeg
install_ffmpeg: $(BUILD_DIR_FFMPEG)
$(BUILD_DIR_FFMPEG): $(BUILD_DIR)
	rm -rf $@
	git clone --depth 1 https://git.ffmpeg.org/ffmpeg.git $@
	cd $@; \
		LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) \
		PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
		./configure $(BUILD_FEATURES);
	$(MAKE) -j $(NPROC) -C $@
	cd $@; make install;

.PHONY: prepare
prepare:
	apt update
	apt -qy install $(BUILD_PKGS) $(RUN_PKGS)

.PHONY: install
install: prepare install_codec install_ffmpeg
	#$(MAKE) $(BUILD_DIR_AV1CODEC)
	#$(MAKE) $(BUILD_DIR_FFMPEG)
	ldconfig
	mkdir -p /usr/local/lib/dgtr
	cp Makefile.dgtr /usr/local/lib/dgtr/Makefile
	cp config.mk /usr/local/lib/dgtr/config.mk
	cp scripts/dgtr /usr/local/bin/dgtr
	chmod +x /usr/local/bin/dgtr

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)
	apt purge -qy $(BUILD_PKGS)
