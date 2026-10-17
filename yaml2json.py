#!/bin/python3
import json, sys, yaml
y=yaml.safe_load(sys.stdin.read())
print(json.dumps(y))
