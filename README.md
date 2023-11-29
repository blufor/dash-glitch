# Dash Glitch - video tooling

This repository contains `Makefile` with the following capabilities:

- Transcoding videos into web-friendly formats with sane sizes
- Uploading the videos to Object Store (Cloudflare R2)
- Generating links for the uploaded videos

## Prerequisites

There are some required tools for the `Makefile` to work correctly:

- `make` - to execute the `Makefile` operations
- `ffmpeg` - for transcoding
- `rclone` - for syncing data to object store

## Configuration

All configuration is contained in the file `config.mk`. It also contains all the comments for the variables.

## Usage

### Transcode a video

To transcode a video file to our format, run:

```bash
make SOURCE=path/to/the/video.mov
```

This will execute the `ffmpeg` utility. Please note the transcoding might take longer than the video length (1.4x time measured).

You can also choose other audio formats by specifying make target:

```bash
make SOURCE=path/to/the/video.mov flac
make SOURCE=path/to/the/video.mov opus
make SOURCE=path/to/the/video.mov pcm
```

> Note that if you don't specify the `make` target, `flac` is assumed

### Sync the videos to object store

Doing this is very simple:

```bash
make sync
```

It reports the progress of sync.

### List links of uploaded files

The file paths in the `pub/` directory are equivalent to the URI paths in the Object Store. This target simplifies the process of getting the customer-facing links.

```bash
make links
```

> Please note that it will output links for all the files in the `pub/` directory. If you don't run `make sync` before, some of the links might not be active yet.
