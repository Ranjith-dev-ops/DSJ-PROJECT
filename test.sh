#!/bin/bash
echo "Running tests..."
if python3 app.py | grep -q "successfully"; then
  echo "Test passed."
  exit 0
else
  echo "Test failed."
  exit 1
fi
