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
}

export -f m_err

function print_conf() {
    m_echo "Writing output to $LOG_FILE"
    m_echo "CPU load = $LOAD%"
    m_echo "Timeout = $TIMEOUT"
    m_echo "Load Type = $LOAD_TYPE"
    m_echo "Cores list = [$CORES_LIST]"
    m_echo "Iterations = $ITERATIONS"
}

export -f print_conf

function run_test() {
    m_echo "Iteration $(($i + 1)): Stressing CPU core $1 with $2% of load"
    stress-ng --metrics --taskset $1 --cpu 1 --cpu-load $2 --cpu-method $LOAD_TYPE --timeout $TIMEOUT >> ${CORE_FILE}_$1 2>&1
}

export -f run_test