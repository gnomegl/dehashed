make_request() {
  local api_key="$1"
  local json_payload="$2"
  local response=$(curl -s -X POST 'https://api.dehashed.com/v2/search' \
    --header "Dehashed-Api-Key: $api_key" \
    --header 'Content-Type: application/json' \
    --data-raw "$json_payload")
  echo "$response"
}

do_search() {
  local api_key=$(get_api_key)

  local json_payload=$(jq -n \
    --arg query "$query" \
    --arg page "${argc_page:-1}" \
    --arg size "${argc_size:-100}" \
    --argjson regex "$([ "${argc_regex:-0}" = "1" ] && echo true || echo false)" \
    --argjson wildcard "$([ "${argc_wildcard:-0}" = "1" ] && echo true || echo false)" \
    --argjson dedupe "$([ "${argc_no_dedupe:-0}" = "1" ] && echo false || echo true)" \
    '{
      query: $query,
      page: ($page | tonumber),
      size: ($size | tonumber),
      regex: $regex,
      wildcard: $wildcard,
      de_dupe: $dedupe
    }')

  if [ "${argc_quiet:-0}" != "1" ]; then
    printf "$(bold_text "$(cyan "Searching Dehashed database...")")\n"
    printf "$(yellow "Query"): %s\n" "$query"
    printf "$(yellow "Page"): %s, $(yellow "Size"): %s\n" "${argc_page:-1}" "${argc_size:-10000}"
    if [ "${argc_regex:-0}" = "1" ]; then printf "$(yellow "Regex"): enabled\n"; fi
    if [ "${argc_wildcard:-0}" = "1" ]; then printf "$(yellow "Wildcard"): enabled\n"; fi
    printf "\n"
  fi

  local response=$(make_request "$api_key" "$json_payload")

  if [ "${argc_json:-0}" = "1" ]; then
    echo "$response" | jq
    exit 0
  fi

  if [ "${argc_csv:-0}" = "1" ]; then
    generate_csv "$response"
    exit 0
  fi

  format_search_results "$response"

  local total=$(echo "$response" | jq -r '.total // 0')
  local entries_count=$(echo "$response" | jq '.entries | length')

  if [ -z "$total" ] || [ "$total" = "null" ] || [ "$total" = "N/A" ]; then
    total=0
  fi

  if [ -z "$entries_count" ] || [ "$entries_count" = "null" ]; then
    entries_count=0
  fi
}
