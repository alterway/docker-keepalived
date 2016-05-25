#!/bin/bash

#
# set localtime
ln -sf /usr/share/zoneinfo/$LOCALTIME /etc/localtime

function replace_vars() {
  eval "cat <<EOF
  $(<$1)
EOF
  " > $1
}

replace_vars '/etc/keepalived/keepalived.conf'

# Run
/usr/sbin/keepalived -f /etc/keepalived/keepalived.conf --dont-fork --log-console