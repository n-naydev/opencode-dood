function opencode() {
  # 1. Logic: Is the first argument a directory?
  local WORKSPACE="$PWD"
  if [ -d "$1" ]; then
    echo "📂 Switching workspace to: $1"
    WORKSPACE="$1"
    shift
  fi

  # 2. Ensure the 'opencode' docker network exists
  if ! docker network inspect opencode >/dev/null 2>&1; then
    docker network create opencode >/dev/null
  fi

  # 3. Run Secure Container

  docker run -it --rm \
    --name "opencode-safe-$(echo "$PWD" | tr '/' '-')" \
    --network opencode \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    -e NPM_CONFIG_UPDATE_NOTIFIER=false \
    -e COLORTERM=truecolor \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD":"$PWD" \
    -w "$PWD" \
    -v "$HOME/.opencode":/home/opencodeuser/.opencode \
    -v "$HOME/.local/share/opencode/":/home/opencodeuser/.local/share/opencode \
    -v "$HOME/.gitconfig":/home/opencodeuser/.gitconfig \
    -v "$HOME/.ssh":/home/opencodeuser/.ssh:ro \
    opencode-image "$@"
}
