#!/bin/bash

export i=0
# Run CPU load using stress-ng I times
for ((i=0; i<$ITERATIONS; i++)); do
  run_test
done
