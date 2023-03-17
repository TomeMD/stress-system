#!/bin/bash

# DEFAULT VALUES
# DON'T MODIFY THIS FILE

# The number of test executions
export ITERATIONS=1

# Percentage of CPU load
export LOAD=50

# Run time of the tests
export TIMEOUT=10s

# Type of load to stress the CPU (double, float, bitops, ...)
export LOAD_TYPE=all

#Comma-separated list of cores on which you want to run the tests 
export CORES_LIST=$(seq -s ',' 0 $(($(nproc) - 1)))