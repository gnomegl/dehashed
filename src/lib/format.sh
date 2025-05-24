format_search_results() {
  local response="$1"
  local balance=$(echo "$response" | jq -r '.balance // "N/A"')
  local total=$(echo "$response" | jq -r '.total // 0')
  local took=$(echo "$response" | jq -r '.took // "N/A"')

  if [ "${argc_no_header:-0}" != "1" ] && [ "${argc_quiet:-0}" != "1" ]; then
    printf "$(bold_text "$(green "=== Dehashed Search Results ===")")\n"
    printf "$(yellow "Balance"): %s credits\n" "$balance"
    printf "$(yellow "Total Results"): %s\n" "$total"
    printf "$(yellow "Query Time"): %s\n" "$took"
    printf "\n"
  fi

  if [ -z "$total" ] || [ "$total" = "null" ] || [ "$total" = "N/A" ]; then
    total=0
  fi
  
  if [ "$total" -eq 0 ]; then
    printf "$(yellow "No results found for query: ${argc_query:-}")\n"
    return 0
  fi

  local tmp_file=$(mktemp)
  echo "$response" | jq -c '.entries[]' > "$tmp_file"
  
  while read -r entry; do

    id=$(echo "$entry" | jq -r '.id // "N/A"')
    database_name=$(echo "$entry" | jq -r '.database_name // "N/A"')

    printf "$(yellow "ID"): %s\n" "$id"
    printf "$(yellow "Database"): %s\n" "$database_name"

    fields=("email" "username" "name" "password" "hashed_password" "ip_address" "phone" "address" "social" "cryptocurrency_address" "license_plate" "vin" "dob" "company" "url")

    for field in "${fields[@]}"; do
      values=$(echo "$entry" | jq -r --arg field "$field" '
        if has($field) then
          if .[$field] | type == "array" then 
            .[$field] | if length > 0 then join(", ") else empty end
          elif .[$field] | type == "string" then
            if .[$field] == "" then empty else .[$field] end
          elif .[$field] | type == "number" then
            .[$field] | tostring
          else
            .[$field] | tostring
          end
        else
          empty
        end')

      if [ -n "$values" ]; then
        formatted_field=$(echo "$field" | tr '_' ' ' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')
        case "$field" in
        "password" | "hashed_password")
          printf "$(yellow "$formatted_field"): $(red "$values")\n"
          ;;
        "email" | "username")
          printf "$(yellow "$formatted_field"): $(blue "$values")\n"
          ;;
        "ip_address" | "cryptocurrency_address")
          printf "$(yellow "$formatted_field"): $(magenta "$values")\n"
          ;;
        *)
          printf "$(yellow "$formatted_field"): %s\n" "$values"
          ;;
        esac
      fi
    done

    if [ "${argc_show_raw:-0}" = "1" ]; then
      if echo "$entry" | jq 'has("raw_record")' | grep -q "true"; then
        printf "$(yellow "Raw Record"):\n"
        echo "$entry" | jq '.raw_record' | sed 's/^/  /'
      fi
    fi

    printf "\n"
  done < "$tmp_file"
  
  rm -f "$tmp_file"

  if [ -z "$total" ] || [ "$total" = "null" ] || [ "$total" = "N/A" ]; then
    total=0
  fi
  
  size="${argc_size:-100}"
  if [ -z "$size" ] || [ "$size" = "null" ]; then
    size=100
  fi
  
  if [ "${argc_quiet:-0}" != "1" ] && [ "$total" -gt "$size" ]; then
    page="${argc_page:-1}"
    if [ -z "$page" ] || [ "$page" = "null" ]; then
      page=1
    fi
    
    current_end=$((page * size))
    if [ "$current_end" -gt "$total" ]; then
      current_end="$total"
    fi
    current_start=$(((page - 1) * size + 1))

    printf "$(bold_text "$(yellow "Showing results $current_start-$current_end of $total")")\n"

    if [ "$current_end" -lt "$total" ]; then
      next_page=$((page + 1))
      printf "$(cyan "To see more results, use: --page $next_page")\n"
    fi
  fi
}

generate_csv() {
  local response="$1"
  printf "id,database_name,email,username,name,password,hashed_password,ip_address,phone,address,social,cryptocurrency_address,license_plate,vin,dob,company,url\n"
  echo "$response" | jq -r '.entries[] |
    [
      .id,
      .database_name,
      (.email // [] | join(";")),
      (.username // [] | join(";")),
      (.name // [] | join(";")),
      (.password // [] | join(";")),
      (.hashed_password // [] | join(";")),
      (.ip_address // [] | join(";")),
      (.phone // [] | join(";")),
      (.address // [] | join(";")),
      (.social // [] | join(";")),
      (.cryptocurrency_address // [] | join(";")),
      (.license_plate // [] | join(";")),
      (.vin // [] | join(";")),
      (.dob // [] | join(";")),
      (.company // [] | join(";")),
      (.url // [] | join(";"))
    ] | @csv'
}
