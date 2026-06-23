#!/usr/bin/env bash

yad-cancel() {
  kill -USR1 $YAD_PID
}

export -f yad-cancel

yad --no-buttons --form --width=200 --borders 10 \
  --center --on-top --undecorated --text-align="center" \
  --field="Logout":fbtn "openbox --exit" \
  --field="Reboot":fbtn "reboot" \
  --field="Shutdown":fbtn "shutdown now" \
  --field="Suspend":fbtn "systemctl suspend" \
  --field="Cancel":fbtn "bash -c yad-cancel"
