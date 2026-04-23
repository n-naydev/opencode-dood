# Gemini Image

A Docker-based environment for running the Gemini CLI securely.

## Overview

This project provides a Dockerized setup for the Gemini CLI, ensuring a consistent environment and safe execution by mounting local directories and managing permissions.

## Prerequisites

- Docker
- Gemini API Key

## Usage

1. Build the image:
   ```bash
   ./build.sh
   ```

2. Install the `gemini` command alias (adds to `.bashrc`):
   ```bash
   ./install.sh
   source ~/.bashrc
   ```

3. Run the Gemini CLI:
   ```bash
   gemini --help
   ```

## Files

- `build.sh`: Build script for creating the Docker image.
- `Dockerfile`: Defines the Node.js environment with Docker CLI and Gemini CLI.
- `entrypoint.sh`: Handles user/group mapping and Docker socket permissions within the container.
- `gemini.sh`: A helper script/function to launch the Gemini CLI container.
- `install.sh`: Setup script to add `gemini` to your shell environment.
