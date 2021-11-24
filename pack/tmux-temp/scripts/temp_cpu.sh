#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NC='\033[0m';RED='\033[0;31m'

# shellcheck source=helpers.sh
source "$CURRENT_DIR/helpers.sh"

print_cpu_temp() {
  if command_exists "sensors"; then
    local units=$1
    local temp
    local temp_pkg
    local temp_string
    temp=($(sensors | egrep '^Tdie:' | sed '/^\s*$/d' | awk '{printf("%f ", $2)}'))
    temp_string="$temp_string $(printf "+%.0fºC" "$temp")"
    if [ $(echo "$temp > 75.0" | bc) -eq 1 ]; then
    	echo "#[fg=#ff0040] $temp_string" | awk 'BEGIN{OFS=" "}$1=$1{print $0}'
    elif [ $(echo "$temp > 60.0" | bc) -eq 1 ]; then
    	echo "#[fg=#00ffc6] $temp_string" | awk 'BEGIN{OFS=" "}$1=$1{print $0}'
    else
	echo "#[fg=#00747b] $temp_string" | awk 'BEGIN{OFS=" "}$1=$1{print $0}'
    fi
  else
    echo "no sensors found"
  fi
}

main() {
  local units
  units=$(get_tmux_option "@temp_units" "C")
  print_cpu_temp "$units"
}
main
