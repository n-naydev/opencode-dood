function gemini() {
  # --- CONFIGURATION ---
  local KEY_FILE="$HOME/.gemini_key"
  # ---------------------

  # 1. Logic: Determine the API Key
  # Priority: 1. Environment Var -> 2. Key File -> 3. Fallback/Error
  local API_KEY=""

  if [ -n "$GEMINI_API_KEY" ]; then
      API_KEY="$GEMINI_API_KEY"
  elif [ -f "$KEY_FILE" ]; then
      # Read file and trim whitespace/newlines
      API_KEY=$(cat "$KEY_FILE" | tr -d '[:space:]')
  else
      echo "❌ Error: No API Key found."
      echo "Please set GEMINI_API_KEY or create $KEY_FILE"
      return 1
  fi

  # 2. Logic: Is the first argument a directory?
  local WORKSPACE="$PWD"
  if [ -d "$1" ]; then
    echo "📂 Switching workspace to: $1"
    WORKSPACE="$1"
    shift 
  fi

  # 3. Ensure the 'gemini' docker network exists
  if ! docker network inspect gemini >/dev/null 2>&1; then
    docker network create gemini >/dev/null
  fi

  # 4. Run Secure Container
  # We pass the key from the variable we just read into the container

  docker run -it --rm \
    --name "gemini-safe-$(echo "$PWD" | tr '/' '-')" \
    --network gemini \
    -e HOST_UID=$(id -u) \
    -e HOST_GID=$(id -g) \
    -e GEMINI_API_KEY="$API_KEY" \
    -e GEMINI_SYSTEM_MD="/home/geminiuser/.gemini/instructions/GEMINI.md" \
    -e NPM_CONFIG_UPDATE_NOTIFIER=false \
    -e COLORTERM=truecolor \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v "$PWD":"$PWD" \
    -w "$PWD" \
    -v "$HOME/.gemini":/home/geminiuser/.gemini \
    -v "$HOME/.gitconfig":/home/geminiuser/.gitconfig \
    -v "$HOME/.ssh":/home/geminiuser/.ssh:ro \
    gemini-image "$@"
}
