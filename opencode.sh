function opencode() {
  # --- CONFIGURATION ---
  local KEY_FILE="$HOME/.opencode_key"
  # ---------------------

  # 1. Logic: Determine the API Key
  # Priority: 1. Environment Var -> 2. Key File -> 3. Fallback/Error
  local API_KEY=""

  if [ -n "$OPENCODE_API_KEY" ]; then
      API_KEY="$OPENCODE_API_KEY"
  elif [ -f "$KEY_FILE" ]; then
      # Read file and trim whitespace/newlines
      API_KEY=$(cat "$KEY_FILE" | tr -d '[:space:]')
  else
      echo "❌ Error: No API Key found."
      echo "Please set OPENCODE_API_KEY or create $KEY_FILE"
      return 1
  fi

  # 2. Logic: Is the first argument a directory?
  local WORKSPACE="$PWD"
  if [ -d "$1" ]; then
    echo "📂 Switching workspace to: $1"
    WORKSPACE="$1"
    shift 
  fi

  # 3. Ensure the 'opencode' docker network exists
  if ! docker network inspect opencode >/dev/null 2>&1; then
    docker network create opencode >/dev/null
  fi

  # 4. Run Secure Container
  # We pass the key from the variable we just read into the container

  docker run -it --rm \
    --name "opencode-safe-$(echo "$PWD" | tr '/' '-')" \
    --network opencode \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    -e OPENCODE_API_KEY="$API_KEY" \
    -e NPM_CONFIG_UPDATE_NOTIFIER=false \
    -e COLORTERM=truecolor \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD":"$PWD" \
    -w "$PWD" \
    -v "$HOME/.opencode":/home/opencodeuser/.opencode \
    -v "$HOME/.gitconfig":/home/opencodeuser/.gitconfig \
    -v "$HOME/.ssh":/home/opencodeuser/.ssh:ro \
    opencode-image "$@"
}
