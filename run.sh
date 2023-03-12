#!/bin/bash

# Set environment
export STRESS_HOME=`dirname $0`
export START_DATE=`date '+%d_%m_%Y_%H-%M-%S'`
export OUT_DIR=${STRESS_HOME}/out/report_${START_DATE}
export LOG_FILE=${OUT_DIR}/log

mkdir -p $OUT_DIR

# Load bash functions
. ${STRESS_HOME}/functions.sh

# Parse arguments
. ${STRESS_HOME}/parse-arguments.sh

# Run tests
. ${STRESS_HOME}/run-tests.sh