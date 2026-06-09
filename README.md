# OpenCode Image

A Docker-based environment for running the OpenCode CLI securely.

## Overview

This project provides a Dockerized setup for the OpenCode CLI, ensuring a consistent environment and safe execution by mounting local directories and managing permissions.

## Prerequisites

- Docker

## Usage

1. Build the image:
   ```bash
   ./build.sh
   ```

2. Install the `opencode` command alias (adds to `.bashrc`):
   ```bash
   ./install.sh
   source ~/.bashrc
   ```

3. Run the OpenCode CLI:
   ```bash
   opencode --help
   ```

## Files

- `build.sh`: Build script for creating the Docker image.
- `Dockerfile`: Defines the Node.js environment with Docker CLI and OpenCode CLI.
- `entrypoint.sh`: Handles user/group mapping and Docker socket permissions within the container.
- `opencode.sh`: A helper script/function to launch the OpenCode CLI container.
- `install.sh`: Setup script to add `opencode` to your shell environment.
