ARG BUILD_FROM=dcmartin/amd64_base-alpine:0.0.2

FROM $BUILD_FROM

ARG BUILD_ARCH=amd64

# Environment variables
ENV \
    HOME="/root" \
    LANG="C.UTF-8" \
    PS1="$(whoami)@$(hostname):$(pwd)$ " \
    TERM="xterm"

# Install base system
RUN \
    set -o pipefail \
    \
    && apk add --no-cache \
	python3 \
	py-pip \
    \
    && rm -fr \
        /tmp/*

RUN pip install --upgrade pip
RUN pip install Flask

# Copy root file-system
COPY rootfs /

CMD [ "/usr/bin/run.sh" ]

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date="${BUILD_DATE}" \
    org.label-schema.build-arch="${BUILD_ARCH}" \
    org.label-schema.name="herald" \
    org.label-schema.description="herald of services" \ 
    org.label-schema.vcs-url="http://github.com/dcmartin/open-horizon/master/herald/" \ 
    org.label-schema.vcs-ref="${BUILD_REF}" \ 
    org.label-schema.version="${BUILD_VERSION}" \
    org.label-schema.vendor="David C Martin <github@dcmartin.com>"
