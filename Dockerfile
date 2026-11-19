# A single, independent CI environment for both PDF and audio generation.
# Linux/amd64 only: upstream LilyPond provides an x86_64 binary.
FROM ubuntu:24.04

ARG LILYPOND_VERSION=2.26.0
ARG MS_BASIC_REVISION=0e44d8e1dd7e0cad1fac85915330c5225bd7882e
ARG SOURCE_REPOSITORY_URL
LABEL org.opencontainers.image.title="LilyPond CI environment" \
      org.opencontainers.image.description="Pinned LilyPond, PDF and audio tools for independent CI projects" \
      org.opencontainers.image.licenses="MIT (image source); bundled dependencies retain upstream licenses" \
      org.opencontainers.image.source="${SOURCE_REPOSITORY_URL}"

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    LILYPOND_VERSION=${LILYPOND_VERSION} \
    PATH="/opt/lilypond-${LILYPOND_VERSION}/bin:${PATH}" \
    SOUNDFONT="/opt/soundfonts/MS_Basic.sf3"

# Run APT only when rebuilding this image, NEVER when building score sources.
# Retain /usr/share/doc/*/copyright for license compliance.
RUN set -eux; \
    apt-get update -o Acquire::Retries=3; \
    apt-get install -y --no-install-recommends \
      bash ca-certificates curl ffmpeg fluidsynth fontconfig fonts-texgyre \
      gh git gzip jq libicu74 openssh-client python3 python3-pypdf \
      sudo tar unzip xz-utils zip; \
    rm -rf /var/lib/apt/lists/*; \
    install -d /usr/share/doc/lilypond-ci-image /opt/soundfonts; \
    dpkg-query -W -f='${binary:Package}\t${Version}\n' \
      > /usr/share/doc/lilypond-ci-image/installed-packages.tsv

# Download the exact LilyPond release already used by the score project.
RUN set -eux; \
    curl --retry 5 --retry-all-errors --connect-timeout 30 -fLsS \
      "https://gitlab.com/lilypond/lilypond/-/releases/v${LILYPOND_VERSION}/downloads/lilypond-${LILYPOND_VERSION}-linux-x86_64.tar.gz" \
      -o /tmp/lilypond.tar.gz; \
    tar -xzf /tmp/lilypond.tar.gz -C /opt; \
    test -x "/opt/lilypond-${LILYPOND_VERSION}/bin/lilypond"; \
    "/opt/lilypond-${LILYPOND_VERSION}/bin/lilypond" --version | grep -F "GNU LilyPond ${LILYPOND_VERSION}"; \
    rm /tmp/lilypond.tar.gz

# Binary SoundFont from a fixed MuseScore revision, with its original license.
RUN set -eux; \
    curl --retry 5 --retry-all-errors --connect-timeout 30 -fLsS \
      "https://raw.githubusercontent.com/musescore/MuseScore/${MS_BASIC_REVISION}/share/sound/MS%20Basic.sf3" \
      -o "${SOUNDFONT}"; \
    test "$(stat -c %s "${SOUNDFONT}")" -gt 50000000; \
    test "$(head -c 4 "${SOUNDFONT}")" = "RIFF"; \
    sha256sum "${SOUNDFONT}" > /usr/share/doc/lilypond-ci-image/MS_Basic.sha256; \
    ffmpeg -buildconf > /usr/share/doc/lilypond-ci-image/ffmpeg-buildconf.txt; \
    fc-cache -f

COPY LICENSE THIRD_PARTY_NOTICES.md /usr/share/doc/lilypond-ci-image/
COPY licenses/ /usr/share/doc/lilypond-ci-image/licenses/
COPY scripts/ci-image-smoke-test /usr/local/bin/ci-image-smoke-test

RUN chmod 0755 /usr/local/bin/ci-image-smoke-test; \
    python3 -c "import pypdf; print('pypdf', pypdf.__version__)"; \
    command -v lilypond; command -v fluidsynth; command -v ffmpeg; \
    command -v git; command -v gh

WORKDIR /work
