#!/bin/bash

result=`pmset -g batt`
percent=`echo $result | rg --only-matching --pcre2 "\d+(?=%)"`
direction='#[nobright]'
if [[ `$echo $result | grep 'Now drawing from'` == *"AC Power"* ]]; then
  direction='#[bright]'
fi

if((percent > 100)); then icon='1' color='#[fg=green]' # 1.0
elif((percent > 87)); then icon='⅞' color='#[fg=green]' # 0.875
elif((percent > 83)); then icon='⅚' color='#[fg=green]' # 0.833333
elif((percent > 80)); then icon='⅘' color='#[fg=yellow]' # 0.8
elif((percent > 66)); then icon='⅔' color='#[fg=yellow]' # 0.666667
elif((percent > 62)); then icon='⅝' color='#[fg=yellow]' # 0.625
elif((percent > 60)); then icon='⅗' color='#[fg=yellow]' # 0.6
elif((percent > 40)); then icon='⅖' color='#[fg=orange]' # 0.4
elif((percent > 37)); then icon='⅜' color='#[fg=orange]' # 0.375
elif((percent > 33)); then icon='⅓' color='#[fg=orange]' # 0.333333
elif((percent > 20)); then icon='⅕' color='#[fg=red]' # 0.2
elif((percent > 16)); then icon='⅙' color='#[fg=red]' # 0.166667
elif((percent > 12)); then icon='⅛' color='#[fg=red]' # 0.125
else icon='0' color='#[fg=red]' # 0.0
fi

echo "$color$direction$icon#[nobright]"
