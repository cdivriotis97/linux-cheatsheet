#!/bin/python3
import json, sys, yaml
print(yaml.safe_dump(json.load(sys.stdin),default_flow_style=False,explicit_start=False))
