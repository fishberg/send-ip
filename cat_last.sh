#!/usr/bin/env bash

FILENAME="$(ls -1 logs/* | sort | tail -1)"
UNIXTIME="$(basename $FILENAME)"
DATE="$(date -d @$UNIXTIME)"
echo $UNIXTIME "->" $DATE
echo
cat $FILENAME
