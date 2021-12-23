FROM python:3.9-slim

ENV REVIEWDOG_VERSION="v0.13.0"
ENV SQLFLUFF_VERSION="0.9.0"

WORKDIR "/workdir"

SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

# hadolint ignore=DL3006
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        wget \
        git \
        jq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install reviewdog
RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}

# Install sqlfluff
COPY requirements.txt .
RUN pip install -r requirements.txt

# Set the entrypoint
COPY entrypoint.sh .
COPY to-rdjson.jq .
ENTRYPOINT ["entrypoint.sh"]
