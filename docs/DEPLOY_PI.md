# DEPLOY_PI (systemd + installer)

This guide explains the intended Raspberry Pi deployment using `systemd`.

> **Important**
> The repository must include these files for the one-command installer:
> - `deploy/env.example`
> - `deploy/install.sh`
> - `deploy/rpi-edge-agent.service`
>
> If `deploy/` does not exist yet, add it first (recommended next step).

---

## Target environment
- Raspberry Pi OS (Debian-based) recommended
- `systemd` available (default)
- Network access for initial setup (git clone / package install)
- (Optional) OpenAI-compatible API key for LLM mode

---

## Install (when `deploy/` exists)

```bash
git clone https://github.com/kakeru-lab/rpi-edge-agent.git
cd rpi-edge-agent

cp deploy/env.example deploy/env
nano deploy/env

sudo bash deploy/install.sh
```

## Service operations

```bash
sudo systemctl status rpi-edge-agent --no-pager
sudo systemctl enable --now rpi-edge-agent
sudo systemctl restart rpi-edge-agent
sudo journalctl -u rpi-edge-agent -f
```

## Verify on PI

```bash
curl -s http://localhost:8080/healthz

curl -s http://localhost:8080/agent/ask \
  -H 'Content-Type: application/json' \
  -d '{"session_id":"demo","message":"Check CPU temperature"}'
```


