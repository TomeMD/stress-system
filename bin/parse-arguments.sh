#!/bin/bash

function usage {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Options:
  -i, --iterations <I>    Run tests I times. [Default: 1]
  -b, --time-btw-iters <T>    Wait T seconds between iterations. [Default: 10s]
  -t, --timeout <T>       Stop tests after T seconds. Time units can be specified by using suffixes. [Default: 10s]
  				s = seconds
  				m = minutes
  				h = hours
  				d = days
  				y = years
  -s, --stressors []      Comma-separated list of stressors to run on system. [Default: cpu]
  -l, --cpu-load <P>      Stress CPU with P percent of CPU load. The load will be assigned to cores incrementally. Used together with CPU stressor. [Default: 50%]
                          Example: "run.sh -l 130 -c 3,6" will load core 3 at 100% and core 6 at 30%.
  --cpu-load-types []     Comma-separated list of types of load to stress the CPU. Used together with CPU stressor. [Default: all]
  --other                 Comma-separated list of other stress-ng options specified in key=value format. Example: --other temp-path=<path>
                          Use key=None when stress-ng option doesn't need an input value. WARNING: DON'T USE THIS OPTION
                          IF YOU DON'T UNDERSTAND IT AT ALL BECAUSE IT COULD RESULT ON UNEXPECTED RESULTS.
  -c, --cores-list []     Comma-separated list of cores on which you want to run the tests [Default: all]
  -o, --output <dir>      Directory to store log files. [Default: ./out]      
  -h, --help              Show this help and exit

Example of use:
  $(basename "$0") --load 230 --timeout 10s --load-types double,int64 --cores-list 0,2,4
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
    -l|--cpu-load)
      LOAD="$2"
      shift 2
      ;;
    -s|--stressors)
      STRESSORS="$2"
      shift 2
      ;;
    -t|--timeout)
      TIMEOUT="$2"
      shift 2
      ;;
    --cpu-load-types)
      LOAD_TYPES="$2"
      shift 2
      ;;
    --other)
      OTHER_OPTIONS="$2"
      shift 2
      ;;
    -c|--cores-list)
      CORES_LIST="$2"
      shift 2
      ;;
    -o|--output)
      OUT_DIR="${2}/report_$(date '+%d_%m_%Y_%H-%M-%S')"
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
