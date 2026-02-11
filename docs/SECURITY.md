# SECURITY

This document describes security principles and operational hardening for `rpi-edge-agent`.

---

## Secrets management

✅ Do:
- Store API keys in **environment variables**
- On Raspberry Pi, store secrets in `/etc/rpi-edge-agent/env` (root-readable)
- For GitHub Actions, use **GitHub Secrets** (never commit secrets)

❌ Don’t:
- Commit `OPENAI_API_KEY` to the repository
- Put secrets in issues, PR comments, or logs
- Embed keys in config files that may be committed

---

## Tool execution safety

Local tools (skills) are powerful. Keep them safe:

### Recommended rules
- Tools must be **explicit** (no arbitrary shell execution by default)
- Inputs must be **validated and allow-listed**
  - File paths: allow-list exact files or restrict to safe directories
- Outputs must be **bounded**
  - max bytes / max lines
- Apply **timeouts** to all tool operations

### Safe-by-default philosophy
- Prefer read-only tools (metrics, status checks, log tail)
- Avoid destructive tools (delete files, restart services) unless strictly controlled

---

## Network exposure

### Default recommendation
- Bind HTTP server to `localhost` for single-device usage
- If exposing on LAN, protect access:
  - firewall rules
  - reverse proxy auth (basic auth / OAuth)
  - mTLS if appropriate

### Logging
- Avoid logging request bodies that may contain secrets
- Avoid logging tool outputs that may include sensitive data

---

## Data (SQLite memory)

The SQLite database may contain:
- user messages
- assistant responses
- tool results

Recommendations:
- Store DB under a restricted directory (Pi):
  - `/var/lib/rpi-edge-agent/agent.db`
- Restrict file permissions:
  - readable/writable only by the service user
- Provide a clear deletion/reset path (operational runbook)

---

## systemd hardening (Pi)

Recommended options for the systemd unit (adjust as needed):
- `NoNewPrivileges=true`
- `PrivateTmp=true`
- `ProtectSystem=full`
- `ProtectHome=true`

Recommended operational model:
- Run as a dedicated user (not root) when possible
- Restrict writable paths to:
  - `/var/lib/rpi-edge-agent`
  - `/run` (temporary files) if needed

---

## Threat model (high level)

### Potential risks
- Exposed HTTP API without auth
- Tools reading sensitive files (path injection)
- Tool output leaking secrets into logs
- Secrets accidentally committed or printed

### Mitigations
- Keep API private (localhost by default) or add auth
- Allow-list and validate tool inputs
- Cap tool output size and log carefully
- Store secrets only in env/secrets managers

---

## Security checklist (quick)
- [ ] API keys are not committed
- [ ] HTTP API is not publicly exposed without auth
- [ ] Tools are allow-listed + bounded + timed out
- [ ] SQLite DB location has restricted permissions
- [ ] systemd unit uses hardening flags (Pi)
