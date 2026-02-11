#!/usr/bin/env bash
set -euo pipefail

BIN="/usr/local/bin/rpi-edge-agent"
ETC_DIR="/etc/rpi-edge-agent"
DATA_DIR="/var/lib/rpi-edge-agent"
SERVICE_DST="/etc/systemd/system/rpi-edge-agent.service"

echo "[1/7] Install packages..."
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl git

echo "[2/7] Ensure directories..."
sudo mkdir -p "$ETC_DIR" "$DATA_DIR"

# Make DATA_DIR writable for 'pi' user (recommended)
if id -u pi >/dev/null 2>&1; then
  sudo chown -R pi:pi "$DATA_DIR"
fi

echo "[3/7] Copy env + config templates (only if missing)..."
if [ ! -f "$ETC_DIR/env" ]; then
  sudo cp deploy/env.example "$ETC_DIR/env"
  echo "Created $ETC_DIR/env (edit it!)"
fi

if [ ! -f "$ETC_DIR/config.yaml" ]; then
  # app/configs/config.example.yaml must exist
  sudo cp app/configs/config.example.yaml "$ETC_DIR/config.yaml"
  echo "Created $ETC_DIR/config.yaml"
fi

echo "[4/7] Build binary..."
# Build on Pi (Go required). If you want pure reproducibility, pin Go install separately.
if ! command -v go >/dev/null 2>&1; then
  echo "Go not found. Installing golang from apt (OK for demo)."
  sudo apt-get install -y golang
fi

cd app
go mod tidy
go build -o /tmp/rpi-edge-agent ./cmd/agent
cd ..

echo "[5/7] Install binary..."
sudo install -m 0755 /tmp/rpi-edge-agent "$BIN"

echo "[6/7] Install systemd unit..."
sudo cp deploy/rpi-edge-agent.service "$SERVICE_DST"
sudo systemctl daemon-reload

echo "[7/7] Enable + start service..."
sudo systemctl enable --now rpi-edge-agent

echo ""
echo "Done. Verify:"
echo "  sudo systemctl status rpi-edge-agent --no-pager"
echo "  curl -s http://localhost:8080/healthz"
echo ""
echo "Logs:"
echo "  sudo journalctl -u rpi-edge-agent -f"
echo ""
echo "Edit env:"
echo "  sudo nano $ETC_DIR/env"
