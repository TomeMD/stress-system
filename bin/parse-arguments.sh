#!/bin/bash

function usage {
  cat << EOF
Usage: $(basename "$0") [-i|--iterations <I>] [-l|--load <P>] [-t|--timeout <T>] [--load-type <type>] [-c|--cores-list [...]]

Options:
  -i, --iterations <I>    Run tests I times. [Default: 1]
  -l, --load <P>          Stress CPU with P percent of CPU load. The load will be assigned to cores incrementally. [Default: 50%]
                                Example: "run.sh -l 130 -c 3,6" will load core 3 at 100% and core 6 at 30%.
  -t, --timeout <T>       Stop tests after T seconds. Time units can be specified by using suffixes. [Default: 10s]
  				s = seconds
  				m = minutes
  				h = hours
  				d = days
  				y = years
  --load-type <type>     Type of load to stress the CPU (double, float, bitops, ...) [Default: all]
  -c, --cores-list []    Comma-separated list of cores on which you want to run the tests [Default: all]
  -o, --output <dir>     Directory to store log files. It must be an existing directory.      
  -h, --help             Show this help and exit

Example of use:
  $(basename "$0") --load 70 --timeout 10s --load-type double --cores-list 0,2,4
EOF
exit 1
}

# Procesamiento de los argumentos utilizando getopts
while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--iterations)
      ITERATIONS="$2"
      shift 2
      ;;
    -l|--load)
      LOAD="$2"
      shift 2
      ;;
    -t|--timeout)
      TIMEOUT="$2"
      shift 2
      ;;
    --load-type)
      LOAD_TYPE="$2"
      shift 2
      ;;
    -c|--cores-list)
      CORES_LIST="$2"
      shift 2
      ;;
    -o|--output)
      if [ -d "$2" ];
      then
        OUT_DIR="$2"
        LOG_FILE=${OUT_DIR}/log
        CORE_FILE=${OUT_DIR}/core
      else
        m_warn "Ignoring non-existent directory: $2"
        m_warn "Using default output directory: $OUT_DIR"
      fi
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
	  echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Print values
print_conf
