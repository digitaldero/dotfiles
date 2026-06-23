#!/usr/bin/env bash
#
# Requires position_mode=ipc in ~/.config/jgmenu/jgmenurc
#

tmp=$(mktemp)
trap "rm -f ${tmp}" EXIT

xdotool getmouselocation --shell >${tmp}
xdotool getdisplaygeometry --shell >>${tmp}
cat ${tmp}

. ${tmp}

export TINT2_BUTTON_PANEL_X1=0
export TINT2_BUTTON_PANEL_X2=$WIDTH
export TINT2_BUTTON_PANEL_Y1=$Y
export TINT2_BUTTON_PANEL_Y2=$Y
export TINT2_BUTTON_ALIGNED_X1=$X
export TINT2_BUTTON_ALIGNED_X2=$X
export TINT2_BUTTON_ALIGNED_Y1=$Y
export TINT2_BUTTON_ALIGNED_Y2=$Y

jgmenu_run
