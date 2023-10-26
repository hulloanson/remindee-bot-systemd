#!/usr/bin/env bash

set -e

source remindee_envs.sh

if [[ -z "${REMINDEE_PATH}" || ! -x "${REMINDEE_PATH}" ]]; then
  echo "Please supply the path to the remindee-bot executable as the REMINDEE_PATH env var" >&2
  exit 1
fi

if [[ -z "${REMINDEE_DATA_DIR}" ]]; then
  echo "Please supply a directory to hold remindee-bot's data as the REMINDEE_DATA_DIR env var" >&2
  exit 1
fi

if [[ -z "${REMINDEE_BOT_TOKEN}" ]]; then
  echo "Please supply remindee-bot's telegram bot token as the REMINDEE_BOT_TOKEN env var" >&2
  exit 1
fi

mkdir -p "$REMINDEE_DATA_DIR"

echo "BOT_TOKEN=${REMINDEE_BOT_TOKEN}" > "${REMINDEE_DATA_DIR}/token.env"
chmod 400 "${REMINDEE_DATA_DIR}/token.env"

if [[ -z "$( cat /etc/passwd | grep -E '^remindee:' )" ]]; then
  adduser --gecos "" --no-create-home --disabled-login remindee
fi

chown -R remindee "$REMINDEE_DATA_DIR"

SERVICE="remindee.service"

echo "Generating and installing $SERVICE"

cp "$SERVICE.in" "$SERVICE"

replace() {
  set -x
  sed -i -e "s#@${1}@#${!1}#g" $SERVICE
  set +x
}

replace REMINDEE_PATH
replace REMINDEE_DATA_DIR

install -m 444 $SERVICE /lib/systemd/system

echo "Generated and installed $SERVICE"

echo "Loading and restart $SERVICE"

systemctl daemon-reload

systemctl enable $SERVICE

systemctl restart $SERVICE

echo "Loaded and restarted $SERVICE"
