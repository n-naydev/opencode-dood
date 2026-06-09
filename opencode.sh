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

  # 3. Setup SSH Agent Forwarding arguments if active on host
  local SSH_AUTH_ARGS=()
  if [ -n "$SSH_AUTH_SOCK" ]; then
    SSH_AUTH_ARGS=(-e SSH_AUTH_SOCK=/run/ssh-agent -v "$SSH_AUTH_SOCK":/run/ssh-agent)
  else
    echo "⚠️ Warning: SSH_AUTH_SOCK is not set. SSH agent forwarding will not be available."
  fi

  # 4. Run Secure Container

  docker run -it --rm \
    --name "opencode-safe-$(echo "$PWD" | tr '/' '-')" \
    --network opencode \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    -e NPM_CONFIG_UPDATE_NOTIFIER=false \
    -e COLORTERM=truecolor \
    "${SSH_AUTH_ARGS[@]}" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD":"$PWD" \
    -w "$PWD" \
    -v "$HOME/.opencode":/home/opencodeuser/.opencode \
    -v "$HOME/.local/share/opencode/":/home/opencodeuser/.local/share/opencode \
    -v "$HOME/.gitconfig":/home/opencodeuser/.gitconfig \
    opencode-image "$@"
}
