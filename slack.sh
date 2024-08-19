#!/bin/bash
set -e

if [ -f .env ]; then
  source .env
else
  exit 1
fi

LOG="./nginx/log/access.log"
SLACK_WEBHOOK=$SLACK_WEBHOOK
echo $SLACK_WEBHOOK
tail -n0 -F "$LOG" | while read LINE; do
  (echo "$LINE") && curl -X POST -H 'Content-type: application/json' --data "{\"text\": \"$(echo $LINE | sed "s/\"/'/g")\"}" $SLACK_WEBHOOK
done
