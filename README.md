# [mxcl/mash](https://mash.pkgx.sh/u/mxcl/)

## `mash info`

Open the pkgpage for a program.

### Usage

```sh
$ mash info <program>

# for funsies, open a random package
$ mash info --random
```

Note, fully qualified package names will not work, eg `mash info git-scm.org`.

## `mash outdated`

List all installed `pkgx` packages that are outdated.

### Usage

```sh
mash outdated
```

## `mash ensure`

Ensure a command is available. If a system command is found it is used,
otherwise the command is run via `pkgx`. Optionally can output `env`-style.

> [!NOTE]
> We are macOS Xcode Command Line Tools aware, so if the CLI tools are
> installed and you ask for eg. `git` or `python`, we will use the Xcode CLT
> version, but if they are not we know not to execute `/usr/bin/git` since it
> isn’t going to work.

### Usage

```sh
$ mash ensure git status
# runs system-installed git with arg `status` unless there is none, in which
# case uses pkgx to invoke `git status`.

$ eval "$(mash ensure +git +cargo +npm)"
# imports the above commands into your shell environment

# same as the above
$ eval "$(mash ensure --env git cargo npm)"
```

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
mash transcribe youtu.be/xiq5euezOEQ -nt > transcription.txt
```

&nbsp;

## `mash cronic`

Cronic is an old-school shell script that helps control the most annoying
feature of cron: unwanted emailed output, or "cram" (cron spam).

### Usage

```sh
$ crontab -l

 0 12 * * * /path/to/mash cronic /path/to/your/script.sh
 ```

## `mash upgrade`

Ensures the latest version of all installed `pkgx` packages are installed.
Older versions are not removed (see `mash prune`).

### Usage

```sh
$ mash upgrade

$ mash upgrade git
# ^^ only upgrade git
```

## `mash magic`

Miss the old `pkgx^1` magic? Here you go.

```
eval "$(mash magic)"
```
