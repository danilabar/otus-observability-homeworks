#!/usr/bin/env bash

cat << EOF
{ "data" : [
  { "{#ITEMNAME}" : "metric1" },
  { "{#ITEMNAME}" : "metric2" },
  { "{#ITEMNAME}" : "metric3" }
]}
EOF

agenthost="`hostname -f`"
zserver="zabbixvm-1.home.local"
zport="10051"

cat /dev/null > /usr/local/zdata.txt
for item in "metric1" "metric2" "metric3"; do
  randnum="$(( RANDOM % (100 - 0 + 1) + 0 ))"
  echo $agenthost otus_important_metrics[$item] $randnum >> /usr/local/zdata.txt
done

zabbix_sender -vv -z $zserver -p $zport -i /usr/local/zdata.txt >> /usr/local/zabbix_sender.log 2>&1
