FROM python:3.13.0rc2-slim

ENV REVIEWDOG_VERSION="v0.17.4"

ENV WORKING_DIRECTORY="/workdir"
WORKDIR "$WORKING_DIRECTORY"

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        wget \
        git \
        jq \
        build-essential \
        libsasl2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install reviewdog
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

# Install pip
RUN pip install --no-cache-dir --upgrade pip==23.1.2

# Set the entrypoint
COPY . "$WORKING_DIRECTORY"
ENTRYPOINT ["/bin/bash", "-c", "/${WORKING_DIRECTORY}/entrypoint.sh"]
