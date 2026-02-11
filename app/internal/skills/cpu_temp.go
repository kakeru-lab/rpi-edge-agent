package skills

import (
	"os"
	"strconv"
	"strings"
)

func CPUTempCelsius() (float64, error) {
	// Pi typically: /sys/class/thermal/thermal_zone0/temp (millidegree Celsius)
	b, err := os.ReadFile("/sys/class/thermal/thermal_zone0/temp")
	if err != nil {
		return 0, err
	}
	s := strings.TrimSpace(string(b))
	v, err := strconv.ParseFloat(s, 64)
	if err != nil {
		return 0, err
	}
	return v / 1000.0, nil
}
