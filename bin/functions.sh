#!/bin/bash

function get_date {
    DATE=$(date '+%d/%m/%Y %H:%M:%S')
}

export -f get_date

function m_echo() {
    get_date
    echo -e "\e[48;5;2m[${DATE} INFO]\e[0m $@"
    echo "${DATE} > ${@}" >> ${LOG_FILE}
}

export -f m_echo

function m_err() {
    get_date
    echo -e "\e[48;5;1m[${DATE} ERR ]\e[0m $@" >&2
    echo "${DATE} > ${@}" >> ${LOG_FILE}
}

export -f m_err

function m_warn() {
    get_date
    echo -e "\e[48;5;208m[${DATE} WARN]\e[0m $@"
    echo "${DATE} > ${@}" >> ${LOG_FILE}
}

export -f m_warn

function print_conf() {
    m_echo "Writing output to ${LOG_FILE}"
    m_echo "Timeout = ${TIMEOUT}"
    m_echo "Stressors = [${STRESSORS}]"
    m_echo "CPU Load = ${LOAD}%"
    m_echo "CPU Load Types = [${LOAD_TYPES}]"
    m_echo "Cores list = [${CORES_LIST}]"
    m_echo "Other stress-ng options = [${OTHER_OPTIONS}]"
    m_echo "Iterations = ${ITERATIONS}"
    m_echo "Time between iterations = ${TIME_BTW_ITERS}s"
}

export -f print_conf

function run_test() {
    local OUT_FILE="${OUT_DIR}/core_${1}"
    touch "${OUT_FILE}" && chmod 777 "${OUT_FILE}"
    m_echo "Iteration ${3}: Stressing CPU core ${1} with ${2}% of load"
    m_echo "stress-ng --metrics --taskset ${1}${OTHER_OPTIONS} --cpu-load ${2} ${STRESSORS} --timeout ${TIMEOUT} >> ${OUT_FILE} 2>&1"
    taskset -c ${1} stress-ng --metrics${OTHER_OPTIONS} --cpu-load ${2} ${STRESSORS} --timeout ${TIMEOUT} >> "${OUT_FILE}" 2>&1
}

export -f run_test