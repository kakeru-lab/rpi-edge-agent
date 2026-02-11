# SETUP (from zero)

This guide helps you build and run `rpi-edge-agent` from scratch on macOS/Linux.

## Prerequisites
- Go **1.22+**
- `git`
- (Optional) OpenAI-compatible API key for LLM mode

## Clone
```bash
git clone https://github.com/kakeru-lab/rpi-edge-agent.git
cd rpi-edge-agent
```

## Build & test

```bash
cd app
go mod tidy
go test ./...
```

## Run(local dev)

If you don't set OPENAI_API_KEY, the agent runs in MVP mode and returns a deterministic response.

```bash
# Optional: enable LLM
export OPENAI_API_KEY="sk-..."
export OPENAI_MODEL="gpt-4o-mini"
export OPENAI_BASE_URL="https://api.openai.com/v1"

go run ./cmd/agent --config ./configs/config.example.yaml
```

## Verify

In another terminal:
```bash
curl -s http://localhost:8080/healthz
```

## Ask the agent

```bash
curl -s http://localhost:8080/agent/ask \
  -H 'Content-Type: application/json' \
  -d '{"session_id":"demo","message":"hello"}'
```

## Notes

・cpu_temp reads /sys/class/thermal/thermal_zone0/temp and is intended for Raspberry Pi (Linux).
On macOS you may see an error (expected).

・SQLite path in config should be writable for your environment (e.g. ./agent.db for local dev).


