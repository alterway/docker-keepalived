#!/bin/bash

#
# set localtime
ln -sf /usr/share/zoneinfo/$LOCALTIME /etc/localtime

function replace_vars() {
  eval "cat <<EOF
  $(<$2)
EOF
  " > $1
}

replace_vars '/etc/keepalived/keepalived.conf' '/etc/keepalived/10_keepalived.conf'
replace_vars '/etc/keepalived/notify.sh' '/etc/keepalived/10_notify.sh'
replace_vars '/etc/keepalived/health.sh' '/etc/keepalived/10_health.sh'
chmod +x /etc/keepalived/notify.sh /etc/keepalived/health.sh

if [ "$ENABLE_LB" = "true" ]; then
{
for i in $REAL_PORTS
do
cat << EOF >> /etc/keepalived/keepalived.conf
  virtual_server $VIRTUAL_IP_LB $i {
  delay_loop 15
  lb_algo $LB_ALGO
  lb_kind $LB_KIND
  persistence_timeout 50
  protocol TCP
  ha_suspend  
EOF

for j in $REAL_IP
do
cat << EOF >> /etc/keepalived/keepalived.conf
  real_server $j $i {
    TCP_CHECK {
      connect_timeout 3
    }
  }
EOF
done
echo "}" >> /etc/keepalived/keepalived.conf
done
}
fi

# Run
/usr/sbin/keepalived -P -C -d -D -S 7 -f /etc/keepalived/keepalived.conf --dont-fork --log-console
