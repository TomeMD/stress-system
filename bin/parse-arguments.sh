#!/bin/bash

function usage {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -i, --iterations <I>    Run tests I times. [Default: 1]
  -b, --time-btw-iters <T>    Wait T seconds between iterations. [Default: 10s]
  -l, --load <P>          Stress CPU with P percent of CPU load. The load will be assigned to cores incrementally. [Default: 50%]
                                Example: "run.sh -l 130 -c 3,6" will load core 3 at 100% and core 6 at 30%.
  -t, --timeout <T>       Stop tests after T seconds. Time units can be specified by using suffixes. [Default: 10s]
  				s = seconds
  				m = minutes
  				h = hours
  				d = days
  				y = years
  --load-types []        Comma-separated list of types of load to stress the CPU. [Default: all]
                         WARNING: When several load types are used at the same time, CPU load may not reach the expected value.
  -c, --cores-list []    Comma-separated list of cores on which you want to run the tests [Default: all]
  -o, --output <dir>     Directory to store log files. [Default: ./out]      
  -h, --help             Show this help and exit

Example of use:
  $(basename "$0") --load 230 --timeout 10s --load-types double --cores-list 0,2,4
EOF
exit 1
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--iterations)
      ITERATIONS="$2"
      shift 2
      ;;
    -b|--time-btw-iters)
      TIME_BTW_ITERS="$2"
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
    --load-types)
      LOAD_TYPES="$2"
      shift 2
      ;;
    -c|--cores-list)
      CORES_LIST="$2"
      shift 2
      ;;
    -o|--output)
      DEFAULT_DIR=$OUT_DIR
      OUT_DIR="$2/report_$(date '+%d_%m_%Y_%H-%M-%S')"
      mkdir -p $OUT_DIR
      if [ -d $OUT_DIR ];
      then
        LOG_FILE=${OUT_DIR}/log
        CORE_FILE=${OUT_DIR}/core
      else
        m_warn "Directory $OUT_DIR could not be created."
        m_warn "Using default output directory: $DEFAULT_DIR"
        OUT_DIR=$DEFAULT_DIR
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
