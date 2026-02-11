# SKILLS (tools / allow-list)

`rpi-edge-agent` can execute **local tools** ("skills") to retrieve system signals and run safe checks.

---

## Goals
- Tools are **explicit and typed** (no arbitrary shell by default)
- Inputs are **allow-listed** (especially file paths)
- Output is **bounded** (max lines/bytes, timeouts)
- Prefer **read-only** operations (metrics/status/logs)

---

## Current skills

### cpu_temp (Raspberry Pi)
Reads CPU temperature from:

- `/sys/class/thermal/thermal_zone0/temp`

Returns:
- Celsius (°C)

Notes:
- On macOS this file does not exist → error is expected.
- Intended to be used on Raspberry Pi OS / Linux.

Example:
```bash
curl -s http://localhost:8080/agent/ask \
  -H 'Content-Type: application/json' \
  -d '{"session_id":"demo","message":"Check CPU temperature"}'
```

## Planned / recommended skills (portable)
## http_check (recommended next)

Purpose:
- Check an HTTP endpoint (status + latency)

Why it’s useful:
- Works on macOS/Linux/Raspberry Pi
- Great for edge health monitoring and automation

Example prompt:
- "Check https://example.com and report status/latency"

## tail_log (needs allow-list)

Purpose:
- Read last N lines from a log file

Risks:
- Could read sensitive files if paths are unrestricted

Allow-list strategy (recommended):
- Only allow specific files, e.g.:
  - /var/log/syslog
  - /var/log/messages
- Or restrict to /var/log/* and block anything else

Bounded output (recommended):
- max lines: 200
- max bytes: 64KB

Example prompt:
- "Tail the last 50 lines of syslog"
