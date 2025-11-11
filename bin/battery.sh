#!/usr/bin/env bash

set -euo pipefail

battery_percent() {
    case $(uname -s) in
    Linux)
        percent=$(linux_acpi percent)
        [ -n "$percent" ] && echo " $percent"
        ;;
    Darwin) echo $(pmset -g batt | grep -Eo '[0-9]?[0-9]?[0-9]%' | sed 's/%//g') ;;
    FreeBSD) echo $(apm | sed '8,11d' | grep life | awk '{print $4}') ;;
    esac
}

battery_status() {
    case $(uname -s) in
    Linux) status=$(linux_acpi status) ;;
    Darwin) status=$(pmset -g batt | sed -n 2p | cut -d ';' -f 2 | tr -d " ") ;;
    FreeBSD) status=$(apm | sed '8,11d' | grep Status | awk '{printf $3}') ;;
    esac
    case $status in
    discharging | Discharging | high) echo false;;
    ACattached | charging | Charging) echo true;;
    esac
}

main() {
    bat_stat=$(battery_status)
    bat_perc="$(battery_percent)"

    local result=""
    while getopts ":dfi" option; do
      case $option in
        d)
          result+="$bat_perc"
          ;;

        f)
          local entries=(
            [100]='1'
            [87]='⅞' [83]='⅚' [80]='⅘' [66]='⅔' [62]='⅝'
            [60]='⅗' [40]='⅖' [37]='⅜' [33]='⅓' [20]='⅕' [16]='⅙' [12]='⅛'
          )
          for threshold in ${!entries[@]}; do
            if (( threshold >= bat_perc ));then
              result+=${entries[$threshold]}
              break;
            fi
          done
          ;;

        i)
          if $bat_stat; then
            local entries=(
              [100]='󰂅' [90]='󰂋' [80]='󰂊' [70]='󰢞' [60]='󰂉' [50]='󰢝' [40]='󰂈'
              [30]='󰂇' [20]='󰂆' [10]='󰢜' [0]='󰢟' # [false]='󱉞'
            )
          else
            local entries=(
              [100]='󰁹' [90]='󰂂' [80]='󰂁' [70]='󰂀' [60]='󰁿' [50]='󰁾' [40]='󰁽'
              [30]='󰁼' [20]='󰁻' [10]='󰁺' [0]='󰂎' # [false]='󱉞'
            )
          fi
          for threshold in ${!entries[@]}; do
            if (( threshold >= bat_perc ));then
              result+=${entries[$threshold]}
              break;
            fi
          done
          ;;

        \?) # Invalid option
          echo "Error: Invalid option"
          exit;;
      esac
    done
    echo $result
  }

main "$@"
