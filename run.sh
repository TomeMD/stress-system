#!/bin/bash

# Set environment
export STRESS_HOME=`dirname $0`
export BIN_DIR=${STRESS_HOME}/bin
export OUT_DIR=${STRESS_HOME}/out/report_$(date '+%d_%m_%Y_%H-%M-%S')
mkdir -p $OUT_DIR
export LOG_FILE=${OUT_DIR}/log

# Load bash functions
. ${BIN_DIR}/functions.sh

# Parse arguments
. ${BIN_DIR}/parse-arguments.sh

# Run tests
. ${BIN_DIR}/run-tests.sh