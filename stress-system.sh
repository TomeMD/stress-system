#!/bin/bash

CORES_LIST=$(seq -s ',' 0 $(($(nproc) - 1)))
LOAD_TYPE=all

. ./functions.sh

if [ $# -ge 4 ]
then
    LOAD=$1
    TIMEOUT=$2
    LOAD_TYPE=$3
    CORES_LIST=$4
elif [ $# -eq 3 ]
then
    LOAD=$1
    TIMEOUT=$2
    LOAD_TYPE=$3
elif [ $# -eq 2 ]
then
    LOAD=$1
    TIMEOUT=$2
else
    m_err "Usage: $0 <LOAD> <TIMEOUT> [<LOAD_TYPE> <CORES_LIST>]"
    m_err "Example: $0 50 10s double 0,2"
    exit 1
fi

# Get number of cores in cores list
CORES=$(echo ${CORES_LIST} | awk -F ',' '{print NF}')

# Set output file
get_date
OUTPUT_FILE="stress-ng_${CORES}_${LOAD_TYPE}.log"

# Run CPU load using stress-ng and write results to output file
m_echo "Stressing CPU cores $CORES_LIST with $LOAD% of load using $LOAD_TYPE stress tests during $TIMEOUT"
taskset -c ${CORES_LIST} stress-ng --metrics --cpu ${CORES} --cpu-load ${LOAD} --cpu-method ${LOAD_TYPE} --timeout ${TIMEOUT} >> $OUTPUT_FILE 2>&1
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
m_echo "Stress tests finished successfully"