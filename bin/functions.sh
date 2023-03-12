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
}

export -f print_conf

function run_test() {
    m_echo "Stressing $CORES_NUM CPU cores"
    taskset -c $CORES_LIST stress-ng --metrics --cpu $CORES_NUM --cpu-load $LOAD --cpu-method $LOAD_TYPE --timeout $TIMEOUT >> $LOG_FILE 2>&1
    m_echo "Stress tests finished successfully"
}

export -f run_test