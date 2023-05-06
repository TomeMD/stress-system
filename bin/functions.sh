#!/bin/bash

function get_date {
    DATE=`date '+%d/%m/%Y %H:%M:%S'`
}

export -f get_date

function m_echo() {
    get_date
    echo -e "\e[48;5;2m[$DATE INFO]\e[0m $@" 
    echo "$DATE > $@" >> $LOG_FILE
}

export -f m_echo

function m_err() {
    get_date
    echo -e "\e[48;5;1m[$DATE ERR ]\e[0m $@" >&2
    echo "$DATE > $@" >> $LOG_FILE
}

export -f m_err

function m_warn() {
    get_date
    echo -e "\e[48;5;208m[$DATE WARN]\e[0m $@"
    echo "$DATE > $@" >> $LOG_FILE
}

export -f m_warn

function print_conf() {
    m_echo "Writing output to $LOG_FILE"
    m_echo "CPU load = $LOAD%"
    m_echo "Timeout = $TIMEOUT"
    m_echo "Load Types = [$LOAD_TYPES]"
    m_echo "Cores list = [$CORES_LIST]"
    m_echo "Iterations = $ITERATIONS"
    m_echo "Time between iterations = ${TIME_BTW_ITERS}s"
}

export -f print_conf

function run_test() {
    local LOAD_PER_STRESSOR=$(($2 / $NUM_STRESSORS))
    m_echo "Iteration $3: Stressing CPU core $1 using $NUM_STRESSORS stressor(s) with $LOAD_PER_STRESSOR% of load each"
    echo "stress-ng --metrics --taskset $1 --cpu-load $LOAD_PER_STRESSOR $STRESSORS --timeout $TIMEOUT"
    stress-ng --metrics --taskset $1 --cpu-load $LOAD_PER_STRESSOR $STRESSORS --timeout $TIMEOUT >> ${CORE_FILE}_$1 2>&1
}

export -f run_test