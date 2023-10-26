# Remindee Bot Systemd

Installs [remindee-bot](https://github.com/magnickolas/remindee-bot) as a systemd service.

## Usage

`remindee-bot` must be installed beforehand. 

Absolute path to the executable and the Telegram bot token must be provided in `remindee_envs.sh` beforehand. To do so, copy `remindee_env.sh.repo` to `remindee_env.sh` and edit it.

```bash
git clone https://github.com/hulloanson/remindee-bot-systemd.git
cd remindee-bot
sudo ./install.sh
```


