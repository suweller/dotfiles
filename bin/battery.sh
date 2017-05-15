#!/bin/bash
if [ `uname` = 'Darwin' ] ; then
  percent=`ioreg -l \
    | grep -i capacity \
    | tr '\n' ' | ' \
    | awk '{printf("%d", $10/$5 * 100)}'`
fi

direction='#[nobright fg=red]-'
if [[ `pmset -g batt | grep 'Now drawing from'` == *"AC Power"* ]]; then
  direction='#[nobright fg=green]+'
fi

if (( percent > 74)); then color='#[fg=green]'
elif (( percent > 49 )); then color='#[fg=yellow]'
elif (( percent > 24 )); then color='#[fg=orange]'
else color='#[bright fg=red]'
fi
echo "$color$percent%$direction"
