#!/usr/bin/env python3

import urllib.request
import urllib.error
import datetime
import json
import os

SERVICES = {
    "Jellyfin":    "http://192.168.56.12:30096",
    "Grafana":     "http://192.168.56.12:30300",
    "Prometheus":  "http://192.168.56.12:30090",
    "Pihole":      "http://192.168.56.12:30080",
    "Gitea":       "http://192.168.56.12:30400",
    "Uptime-Kuma": "http://192.168.56.12:30301",
}

LOG_FILE = "/home/jgreene/homelab-repo/scripts/monitor.log"

def check_service(name, url):
    try:
        req = urllib.request.urlopen(url, timeout=5)
        return {"service": name, "status": "UP", "code": req.getcode()}
    except urllib.error.HTTPError as e:
        return {"service": name, "status": "UP", "code": e.code}
    except Exception as e:
        return {"service": name, "status": "DOWN", "error": str(e)}

def main():
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    results = []

    print(f"=============================== ")
    print(f" Service Monitor - {timestamp}")
    print(f"=============================== ")

    for name, url in SERVICES.items():
        result = check_service(name, url)
        results.append(result)
        status = result["status"]
        code = result.get("code", result.get("error", "N/A"))
        print(f"[{status:4}] {name} ({code})")

    # Log results to file
    with open(LOG_FILE, "a") as f:
        f.write(json.dumps({"timestamp": timestamp, "results": results}) + "\n")

    print(f"=============================== ")
    print(f" Results logged to {LOG_FILE}")

if __name__ == "__main__":
    main()
