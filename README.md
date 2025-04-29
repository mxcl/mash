# [mxcl/mash](https://mash.pkgx.sh/u/mxcl/)

## `mash transcribe`

Transcribe YouTube videos fast with local AI.

### Details

Locally transcribe a remote YouTube video using `yt-dlp`, `ffmpeg`,
`whisper.cpp` downloading the whisper model using `huggingface-cli`.

### Usage

```sh
$ mash transcribe <YOUTUBE-URL>
# ^^ you probs need to quote that URL
```

Additional arguments are passed to `whisper.cpp`, eg. `--no-timestamps` or
`-nt` for no timestamps. Use `pkgx whisper.cpp --help` for more options.

whisper.cpp is very noisy, you can hide all the informational messages by
sending stderr to null:

```sh
mash transcribe youtu.be/xiq5euezOEQ 2>/dev/null
```

Redirecting stdout to a file means that file contains only the transcript:

```sh
mash transcribe youtu.be/xiq5euezOEQ -nt 2> transcription.txt
```

&nbsp;

## `mash stargazer`

Make a stargazer video for any GitHub repo.

### Usage

```sh
$ mash stargazer
# ^^ prompts you for repo and other required inputs
```

### About

Wraps https://github.com/pomber/stargazer for your convenience.

&nbsp;

## `mash cronic`

Cronic is an old-school shell script that helps control the most annoying
feature of cron: unwanted emailed output, or "cram" (cron spam).

### Usage

```sh
$ crontab -l

 0 12 * * * /path/to/mash cronic /path/to/your/script.sh
 ```
