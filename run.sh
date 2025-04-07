#!/bin/bash

# Set environment
export STRESS_HOME=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
export BIN_DIR=${STRESS_HOME}/bin
export CONF_DIR=${STRESS_HOME}/etc
export EXP_DIR=${STRESS_HOME}/experiment

# Load default values
. ${CONF_DIR}/stress-default.sh

# Load configuration file
. ${EXP_DIR}/stress-conf.sh

# Parse arguments
. ${BIN_DIR}/parse-arguments.sh

# Load bash functions
. ${BIN_DIR}/functions.sh

# Run tests
. ${BIN_DIR}/run-tests.sh