# Third-party software and data notices

This repository's own Dockerfile, CI scripts and documentation are licensed
under MIT (see [LICENSE](LICENSE)). **This does not relicense the container's
dependencies**. The published image redistributes third-party executables,
libraries, fonts, and audio samples subject to their respective licenses.

## Included upstream components

| Component | Version/source | License and obligations |
| --- | --- | --- |
| GNU LilyPond | 2.26.0, official Linux x86_64 release from [lilypond/lilypond](https://gitlab.com/lilypond/lilypond/-/releases/v2.26.0) | GNU GPL, plus additional license notices for bundled resources. Preserve notices and ensure recipients can access the [corresponding 2.26.0 source](https://gitlab.com/lilypond/lilypond/-/tree/v2.26.0). |
| MS Basic SoundFont | `share/sound/MS Basic.sf3` from [MuseScore commit `0e44d8e`](https://github.com/musescore/MuseScore/tree/0e44d8e1dd7e0cad1fac85915330c5225bd7882e/share/sound) | MIT, with mandatory copyright and contributor acknowledgements. The exact [upstream license file](licenses/MS_Basic_License.md) from the same commit is kept unchanged. It refers to an earlier MuseScore_General name; don't discard the acknowledgements. |
| FluidSynth / libfluidsynth | Ubuntu 24.04 packages | LGPL-2.1-or-later (review each binary package's exact installed copyright). |
| FFmpeg and codecs | Ubuntu 24.04 packages | LGPL/GPL status depends on actual build configuration, codecs and linked libraries. Check `ffmpeg -buildconf` and the corresponding installed copyright notices; preserve LGPL/GPL rights and source availability. |
| TeX Gyre fonts | Ubuntu 24.04 `fonts-texgyre` | GUST Font License (and other package notices where applicable). |
| pypdf | Ubuntu 24.04 `python3-pypdf` | BSD-3-Clause, retain copyright notices. |
| Ubuntu base and supporting packages | Ubuntu 24.04 OCI base plus APT packages | Multiple free-software licenses including GPL/LGPL/BSD/MIT. Installed `/usr/share/doc/*/copyright` files and a `/usr/share/doc/lilypond-ci-image/installed-packages.tsv` inventory are retained. |

**Source correspondence:** The Dockerfile describes the installation of all
Ubuntu binary packages, the official LilyPond binary release, and the exact
MuseScore revision. Preserve all applicable copyright/license files in image
distributions. For GPL/LGPL components, make the applicable corresponding
source code available alongside the binary distribution on terms required by
each license. Merely linking to upstream is not a substitute if those terms
are not met; check source availability before changing or republishing the
image. For Ubuntu packages, corresponding source packages can be obtained
through Ubuntu's source archives using the package source name and version
recorded in the installed package inventory.

The software bill of materials and notices should be checked again when
changing the base image, release versions or the upstream SoundFont commit.
This is a reproducible engineering inventory, not a legal opinion.

## Required checks for a release

- Keep `licenses/MS_Basic_License.md` and the original upstream credits.
- Include the installed package copyright notices and package version list.
- Verify LilyPond version and SoundFont signature.
- Inspect `ffmpeg -buildconf` for GPL/nonfree flags when upgrading.
- Check corresponding source availability for GPL/LGPL binaries.
- Never embed music-score source files or ScoreKit source in this image.
