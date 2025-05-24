#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$SCRIPT_DIR/lib/colors.sh"
source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/format.sh"
source "$SCRIPT_DIR/lib/help.sh"
source "$SCRIPT_DIR/lib/api.sh"

# @describe Search Dehashed database for leaked credentials and personal information
# @arg command "Command to run (search, help)" [string] @default "search"
# @arg query "Search query (e.g., 'email:user@domain.com', 'username:admin', 'domain:example.com')" [string]
# @option -k --api-key "Dehashed API key (can also use DEHASHED_API_KEY env var)" [string]
# @option -p --page "Page number for pagination" [int] @default "1"
# @option -s --size "Number of results per page (max 10000)" [int] @default "100"
# @option -f --field "Search specific field" [string] @choices "name,email,username,ip_address,password,hashed_password,vin,license_plate,address,phone,social,cryptocurrency_address,domain"
# @flag -r --regex "Enable regex search"
# @flag -w --wildcard "Enable wildcard search (use * for wildcards)"
# @flag --no-dedupe "Disable deduplication of results"
# @flag -j --json "Output raw JSON response"
# @flag -q --quiet "Suppress colored output and progress indicators"
# @flag --no-header "Don't display header information"
# @flag --csv "Output results in CSV format"
# @flag --show-raw "Include raw record data in output"
# @meta require-tools curl,jq

eval "$(argc --argc-eval "$0" "$@")"
set -euo pipefail

setup_colors

case "${argc_command:-search}" in
search)
  do_search
  ;;
help)
  show_help "${argc_query:-}"
  ;;
*)
  printf "$(red "Error"): Unknown command: ${argc_command}\n" >&2
  show_help
  exit 1
  ;;
esac
