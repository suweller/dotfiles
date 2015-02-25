#!/bin/bash
TYPE=`pmset -g batt | grep 'drawing' | awk '{print $4}' | awk -F "'" '{ print $2 }'`
LEVEL=`pmset -g batt | grep Internal | awk '{ print $2 }' | awk -F '%' '{ print $1}'`
echo "$LEVEL% - $TYPE"
