#!/bin/bash

set -euo pipefail

cat <<EOF | sudo tee -a /etc/hosts
10.240.0.10 fluentd-server
10.240.0.11 webserver-1
10.240.0.12 webserver-2
EOF
