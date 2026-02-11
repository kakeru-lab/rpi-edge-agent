package agent

import (
	"fmt"
	"strings"

	"github.com/kakeru-lab/rpi-edge-agent/internal/memory"
	"github.com/kakeru-lab/rpi-edge-agent/internal/skills"
)

type Agent struct {
	store *memory.Store
}

func New(store *memory.Store) *Agent {
	return &Agent{store: store}
}

func (a *Agent) Ask(sessionID, message string) (string, error) {
	// Save user message
	if err := a.store.AddMessage(sessionID, "user", message); err != nil {
		return "", err
	}

	// MVP routing: if user asks about temperature, read CPU temp
	lower := strings.ToLower(message)
	var reply string
	if strings.Contains(lower, "cpu") || strings.Contains(lower, "temp") || strings.Contains(message, "温度") {
		t, err := skills.CPUTempCelsius()
		if err != nil {
			reply = fmt.Sprintf("Could not read CPU temperature: %v", err)
		} else {
			reply = fmt.Sprintf("CPU temperature: %.1f°C", t)
		}
	} else {
		reply = "MVP: I can read CPU temperature. Try: 'Check CPU temperature'."
	}

	// Save assistant reply
	if err := a.store.AddMessage(sessionID, "assistant", reply); err != nil {
		return "", err
	}
	return reply, nil
}
