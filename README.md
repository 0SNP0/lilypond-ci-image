# LilyPond CI image

A standalone, reusable Linux/amd64 container for compiling LilyPond PDFs and
rendering MIDI/audio in CI. It is **not tied to a score or to ScoreKit**.

The single image contains:
- GNU LilyPond 2.26.0 (upstream pinned binary)
- Ubuntu 24.04, Python 3 with pypdf, TeX Gyre fonts
- FluidSynth, FFmpeg, Git, GitHub CLI and CI utilities
- MuseScore MS Basic SoundFont from a pinned upstream commit

See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for copyright and source
information. The image is meant for GitHub Actions `jobs.<job_id>.container`
on Ubuntu amd64 runners.

## Build locally

```bash
docker build -t lilypond-ci-image:local .
docker run --rm lilypond-ci-image:local ci-image-smoke-test
```

## Publishing

The [publish workflow](.github/workflows/publish.yml) builds the container,
tests it, then publishes to GHCR only if the smoke tests pass. It uses the
built-in GitHub Actions token; no personal access token is needed.

The published image is intended to be consumed by its **immutable image
digest**, not by `:latest`. Changing a dependency requires an explicit
image rebuild and then updating the digest in downstream CI.

Public access to a newly created GHCR package may need to be enabled
separately under the package's settings.

## Licensing

The repository's own Dockerfile and scripts are MIT licensed; software and
SoundFont inside the image retain their own licenses. See
[LICENSE](LICENSE) and [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
For GPL/LGPL binaries, ensure the corresponding source is available with
the distributed image (details in the notices).
