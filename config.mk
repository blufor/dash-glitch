# Cloudflare configuration
#
# Used for syncing and link generation
CF_REMOTE := dashglitch
CF_BUCKET := masterclass2
CF_ENDPOINT := https://masterclass.dashglitch.com/

# FLAC audio encoding - lossless
#
# Docs: https://ffmpeg.org/ffmpeg-codecs.html#flac-2
FF_AUDIO_FLAC = -c:a flac
FF_AUDIO_FLAC += -af aformat=s32:48000
FF_AUDIO_FLAC += -compression_level 12

# OPUS audio encoding - lossy
#
# Docs: https://ffmpeg.org/ffmpeg-codecs.html#libopus-1
FF_AUDIO_OPUS = -c:a libopus
FF_AUDIO_OPUS += -b:a 128k
FF_AUDIO_OPUS += -cutoff 20000

# AV1 video encoding
#
# Docs: https://ffmpeg.org/ffmpeg-codecs.html#libsvtav1
FF_VIDEO_AV1 = -c:v libsvtav1
FF_VIDEO_AV1 += -preset 8
FF_VIDEO_AV1 += -crf 50
FF_VIDEO_AV1 += -svtav1-params tune=0

# Raw transcoding
#
# This might be useful for aligning uncompressed videos
# to a common shared container - ISO MP4 - without
# changing the codecs.
FF_AUDIO_COPY = -c:a copy
FF_VIDEO_COPY = -c:v copy

