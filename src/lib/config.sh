get_api_key() {
  local key=""

  if [ -n "${argc_api_key:-}" ]; then
    key="$argc_api_key"
  elif [ -n "${DEHASHED_API_KEY:-}" ]; then
    key="$DEHASHED_API_KEY"
  elif [ -f "$HOME/.config/dehashed/api_key" ]; then
    key=$(cat "$HOME/.config/dehashed/api_key")
  fi

  if [ -n "$key" ]; then
    echo "$key"
  else
    printf "$(red "Error"): No Dehashed API key found.\n" >&2
    printf "Please provide your API key using one of these methods:\n" >&2
    printf "  1. Pass it with $(yellow "--api-key")\n" >&2
    printf "  2. Set $(yellow "DEHASHED_API_KEY") environment variable\n" >&2
    printf "  3. Save it to $(yellow "~/.config/dehashed/api_key")\n" >&2
    exit 1
  fi
}

