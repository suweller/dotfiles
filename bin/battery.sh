#!/bin/bash
if [ `uname` = 'Darwin' ] ; then
  percent=`pmset -g batt | grep -Eo "\d+%" | cut -d% -f1`
fi

direction='#[nobright]'
if [[ `pmset -g batt | grep 'Now drawing from'` == *"AC Power"* ]]; then
  direction='#[bright]'
fi

if (( percent > 74)); then color='#[fg=green]'
elif (( percent > 49 )); then color='#[fg=yellow]'
elif (( percent > 24 )); then color='#[fg=orange]'
else color='#[bright fg=red]'
fi

if ((percent > 97)); then icon='⅟'
elif ((percent > 87)); then icon='⅞'
elif ((percent > 75)); then icon='¾'
elif ((percent > 62)); then icon='⅝'
elif ((percent > 50)); then icon='½'
elif ((percent > 37)); then icon='⅜'
elif ((percent > 25)); then icon='¼'
elif ((percent > 12)); then icon='⅛'
else icon='0'
fi

echo "$color$direction$icon#[nobright]"
