setup_colors() {
  if [ -z "$TERM" ] || [ "$TERM" = "dumb" ]; then
    bold="" reset="" blue="" green="" yellow="" cyan="" magenta="" red="" 
  else
    bold=$(tput bold) reset=$(tput sgr0) blue=$(tput setaf 4) green=$(tput setaf 2)
    yellow=$(tput setaf 3) cyan=$(tput setaf 6) magenta=$(tput setaf 5) red=$(tput setaf 1)
  fi
}

bold_text() {
  printf "${bold}%s${reset}" "$1"
}

red() {
  printf "${red}%s${reset}" "$1"
}

green() {
  printf "${green}%s${reset}" "$1"
}

yellow() {
  printf "${yellow}%s${reset}" "$1"
}

blue() {
  printf "${blue}%s${reset}" "$1"
}

cyan() {
  printf "${cyan}%s${reset}" "$1"
}

magenta() {
  printf "${magenta}%s${reset}" "$1"
}

print_kv() {
  printf "$(bold_text "$1"): %s\n" "$2"
}

print_section() {
  printf "\n$(bold_text "$1"):\n"
}

format_case() {
  echo "$(tr '[:lower:]' '[:upper:]' <<<${1:0:1})${1:1}"
}
