include config.mk

#######################################
# Functional parts of Makefile follow #
#                                     #
# Beware - there be dragons ;)        #
#######################################

FFMPEG := ffmpeg
MKDIR  := mkdir
RCLONE := rclone
FIND   := find
SED    := sed

##################
### TRANSCODER ###
##################

FF_OPTS     := -y -movflags +faststart
PUBDIR      := pub
SOURCE      ?= no-file
SOURCE_SHA  := $(shell sha1sum $(SOURCE) 2>/dev/null | cut -d' ' -f1)
SOURCE_NAME := $(basename $(notdir $(SOURCE)))

all: flac

$(PUBDIR)/$(SOURCE_SHA):
	$(MKDIR) -p $@

$(SOURCE):
ifeq ($(SOURCE),)
	@echo "No source file provided! Usage: make SOURCE=path/to/video.mov" && false
endif

.PHONY: pcm
pcm: $(PUBDIR)/$(SOURCE_SHA) $(PUBDIR)/$(SOURCE_SHA)/$(SOURCE_NAME)-av1-pcm.mp4
$(PUBDIR)/$(SOURCE_SHA)/$(SOURCE_NAME)-av1-pcm.mp4: $(SOURCE)
	$(FFMPEG) -i $< $(FF_OPTS) $(FF_AUDIO_COPY) $(FF_VIDEO_AV1) $@

.PHONY: flac
flac: $(PUBDIR)/$(SOURCE_SHA) $(PUBDIR)/$(SOURCE_SHA)/$(SOURCE_NAME)-av1-flac.mp4
$(PUBDIR)/$(SOURCE_SHA)/$(SOURCE_NAME)-av1-flac.mp4: $(SOURCE)
	$(FFMPEG) -i $< $(FF_OPTS) $(FF_AUDIO_FLAC) $(FF_VIDEO_AV1) $@

.PHONY: opus
opus: $(PUBDIR)/$(SOURCE_SHA) $(PUBDIR)/$(SOURCE_SHA)/$(SOURCE_NAME)-av1-opus.mp4
$(PUBDIR)/$(SOURCE_SHA)/$(SOURCE_NAME)-av1-opus.mp4: $(SOURCE)
	$(FFMPEG) -i $< $(FF_OPTS) $(FF_AUDIO_OPUS) $(FF_VIDEO_AV1) $@

################
### UPLOADER ###
################

.PHONY: sync
sync:
	$(RCLONE) sync -P $(PUBDIR) $(CF_REMOTE):$(CF_BUCKET)/

.PHONY: links
links:
	@$(FIND) $(PUBDIR) -type f -name '*.mp4' | $(SED) "s#$(PUBDIR)/#$(CF_ENDPOINT)#"
