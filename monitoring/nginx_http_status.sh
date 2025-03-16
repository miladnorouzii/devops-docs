#!/bin/bash

PUSHGATEWAY_URL="192.168.178.14:9091"
JOB_NAME="nginx_status_code"
INSTANCE="nginx_server_instance"
LOG_FILE="/var/log/nginx/access.log"


count=$(grep ' 200 ' "$LOG_FILE" | wc -l)

echo "number of 200 status code is $count"

metrics_date="nginx_http_status_200_total $count"

echo $metrics_date


echo "$metrics_date" | curl --data-binary @- "http://$PUSHGATEWAY_URL/metrics/job/$JOB_NAME/instance/$INSTANCE"

echo "Pushed metrics to pushgateway: $metrics_date"
