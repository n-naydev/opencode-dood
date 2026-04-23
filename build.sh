#!/bin/bash

BUILD_ARGS=""

for arg in "$@"; do
  if [[ "$arg" == "--rebuild" ]]; then
    BUILD_ARGS="--no-cache"
  fi
done

# Build the Gemini CLI image
docker build $BUILD_ARGS -t gemini-image .
