#!/bin/bash
for bgc in {0..255}; do
  echo -en "\e[0mBG ${bgc}\e[48;5;${bgc}m"
  for fgc in {0..255}; do
    printf "\e[38;5;%sm%3s " $fgc $fgc
  done
  echo
done
exit 0
