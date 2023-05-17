# stress-system

A tool to load and stress a system using `stress-ng`.

## Running stress-system

You can run this tool in the following three ways:

- [Local](#local)
- [Using Docker containers](#docker)
- [Using Apptainer containers](#apptainer)

<a name="local"></a>

### Local

To run this tool on your physical machine all you need is to have `stress-ng` installed. To install `stress-ng` follow the instructions in its [official repository](https://github.com/ColinIanKing/stress-ng).

Once `stress-ng` is installed run the tool with:

```shell
./run.sh
```

<a name="docker"></a>

### Using Docker containers

First, you need to build the docker image:

```dockerfile
docker build -t stress-system -f container/Dockerfile .
```

Then you can run the tool:

```dockerfile
docker run -ti [-v <host-dir>:<container-dir>] stress-system [-o <container-dir> <other-options>]
```

To store the logs on your physical machine you have to mount a volume from host to container and specify the container directory as the output parameter of the tool (-o option). Here is an example in which the logs are stored in the `/tmp` directory of the container, which we can access through the `./out` directory from our machine:

```dockerfile
docker run -ti -v $(pwd)/out:/tmp stress-system -o /tmp -l 100 -c 0,6,7 
```

To run the container in background:

```dockerfile
docker run -d [-v <host-dir>:<container-dir>] stress-system [-o <container-dir> <other-options>]
```

<a name="apptainer"></a>

### Using Apptainer containers

First you need to build Apptainer image (SIF file):

```shell
cd container && apptainer build stress.sif stress.def && cd ..
```

Logs will be written to the `/tmp/out/report_$(date '+%d_%m_%Y_%H-%M-%M-%S')` directory, as Apptainer shares this directory with the host by default. Therefore, do not modify the tool's output directory. Now run the image in foreground:

```shell
apptainer run container/stress.sif [<options-except-output>]
```

Or in the background:

```shell
sudo apptainer instance start container/stress.sif [<options-except-output>]
```

## Options

You can specify the options from the CLI or by modifying the `./experiment/stress-conf.sh` configuration file. 

```shell
# ./run.sh --help
Usage: run.sh [OPTIONS]

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
  -c, --cores-list []    Comma-separated list of cores on which you want to run the tests [Default: all]
  -o, --output <dir>     Directory to store log files. [Default: ./out]
  -h, --help             Show this help and exit

Example of use:
  run.sh --load 230 --timeout 10s --load-types double,int64 --cores-list 0,2,4
```

This tool assigns the load incrementally to each core, instead of distributing the load among all available cores. To better understand his behavior see the examples below.

### Example 1

```shell
run.sh --load 70 --timeout 10s --load-types double --cores-list 0,2,4
```
| Core | Load |
| :--: | :--: |
|  0   | 70%  |
|  2   |  0%  |
|  4   |  0%  |


It will load core 0 with 70% of load using double tests for 10 seconds. It will ignore cores 2 and 4 as there is not enough load for them.


### Example 2

```shell
run.sh -i 3 --load 140 --timeout 1m --load-types all --cores-list 0,2,4
```
| Core | Load |
| :--: | :--: |
|  0   | 100% |
|  2   | 40%  |
|  4   |  0%  |


It will load core 0 with 100% of load and core 2 with 40% of load using all tests for 1 minute 3 times. It will ignore core 4 as there is not enough load for it.


### Example 3

```shell
run.sh --load 240 --timeout 1m --load-types all --cores-list 0,2,4
```
| Core | Load |
| :--: | :--: |
|  0   | 100% |
|  2   | 100% |
|  4   | 40%  |


It will load core 0 and 2 with 100% of load and core 4 with 40% of load using all tests for 1 minute.


### Example 4

```shell
run.sh --load 340 --timeout 1m --load-types all --cores-list 0,2,4
```
| Core | Load |
| :--: | :--: |
|  0   | 100% |
|  2   | 100% |
|  4   | 100% |


It will load core 0, 2 and 4 with 100% of load using all tests for 1 minute. Although specified load is 340%, the maximum load that can be executed with 3 cores is 300%, so the load value is reassigned to its maximum possible value (300%).
