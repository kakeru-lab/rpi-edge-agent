[![ci](https://github.com/kakeru-lab/rpi-edge-agent/actions/workflows/ci.yml/badge.svg)](https://github.com/kakeru-lab/rpi-edge-agent/actions/workflows/ci.yml)

✅ CI guarantees: gofmt check + go vet + go test + Docker build on every push/PR.


# rpi-edge-agent
Reproducible **AI Agent on Raspberry Pi (Go)** — **systemd service** + **HTTP API** + **SQLite memory** + **local tools**.

## Why it matters
Edge/on-prem environments need automation that survives reboots and works offline-first.
This project provides a minimal, reproducible “AI operator” that can run on a Raspberry Pi.

## Features
- **One-command install** (Pi) + auto-start via **systemd**
- OpenAI-compatible LLM backend (OpenAI / Azure / OpenRouter)
- Built-in tools (skills): CPU temp, HTTP check, log tail (allow-listed)
- Persistent memory in SQLite
- CI: gofmt/vet/test + docker build

## Quick Start (Raspberry Pi)
```bash
git clone https://github.com/kakeru-lab/rpi-edge-agent.git
cd rpi-edge-agent
cd app
go mod tidy
go test ./...
```
# (Optional) enable LLM
export OPENAI_API_KEY="sk-..."
export OPENAI_MODEL="gpt-4o-mini"
export OPENAI_BASE_URL="https://api.openai.com/v1"

## Demo (ask the agent)

```bash
curl -s http://localhost:8080/agent/ask \
  -H 'Content-Type: application/json' \
  -d '{"session_id":"demo","message":"Check CPU temperature and summarize recent logs."}'
```

## Project structure

```text
app/      # Go service (agent + api + skills + sqlite)
deploy/   # systemd unit + installer + env template
docs/     # detailed guides (setup/security/troubleshooting)
.github/  # CI workflow
```

## Docs
- `docs/SETUP.md` (from zero)
- `docs/DEPLOY_PI.md` (systemd + installer)
- `docs/SKILLS.md` (tools / allow-list)
- `docs/SECURITY.md`
```0
