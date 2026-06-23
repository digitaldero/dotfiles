#!/bin/bash
for bgc in {0..255}; do

  #echo -en "\e[0mBG ${bgc}\e[48;5;${bgc}m"

  for fgc in {0..255}; do

    _PS1="\e[48;5;${bgc}m\e[38;5;${fgc}m $bgc/$fgc \e[48;5;235m\e[38;5;${bgc}m\e[0m ";
    echo -en "${_PS1} "
  done
done
exit 0
