#!/bin/bash

set -euo pipefail

cat >/etc/yum.repos.d/tresuredata.repo <<'EOF'
[treasuredata]
name=TreasureData
baseurl=http://packages.treasure-data.com/2/redhat/7/$basearch
gpgcheck=1
gpgkey=http://packages.treasuredata.com/GPG-KEY-td-agent
EOF

yum update -y
yum install td-agent -y

cat >/etc/sysconfig/td-agent<<EOF
DAEMON_ARGS="--user root"
TD_AGENT_ARGS="/usr/sbin/td-agent --user root --group td-agent --log /var/log/td-agent/td-agent.log"
EOF

case "$(hostname)" in
  webserver-1)
cat >/etc/td-agent/td-agent.conf<<EOF
<source>
  @type tail
  path /var/log/httpd/access_log
  pos_file /var/log/td-agent/buffer/access_log.pos
  format none
  tag apache.access
</source>
<match **>
  @type forward
  send_timeout 5s
  <server>
    host 10.240.0.10
    port 24224
  </server>
</match>
EOF
    ;;
  webserver-2)
cat >/etc/td-agent/td-agent.conf<<EOF
<source>
  @type tail
  path /var/log/httpd/access_log
  pos_file /var/log/td-agent/buffer/access_log.pos
  format none
  tag apache.access
</source>
<match **>
  @type forward
  send_timeout 5s
  <server>
    host 10.240.0.10
    port 24224
  </server>
</match>
EOF
    ;;
  fluentd-server)
cat >/etc/td-agent/td-agent.conf<<EOF
<source>
  @type forward
  port 24224
</source>
<match **>
  @type file
  path /var/log/td-agent/apache/access_log
  append true
  time_slice_format %Y%m%d
</match>
EOF
    ;;
  *)
    ;;
esac

case "$(hostname)" in
  webserver-1)
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    ;;
  webserver-2)
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    ;;
  *)
    ;;
esac 

systemctl start td-agent
systemctl enable td-agent

