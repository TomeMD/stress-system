# stress-system

A tool to load and stress a system using `stress-ng`.



## Running stress-system

To run this tool all you need is to have `stress-ng` installed. To install `stress-ng` follow the instructions in its [official repository](https://github.com/ColinIanKing/stress-ng).

Once `stress-ng` is installed run the tool with:

```shell
./run.sh
```



## Options

You can specify the options from the CLI or by modifying the `./experiment/stress-conf.sh` configuration file. 

```shell
# ./run.sh --help
Usage: run.sh [-i|--iterations <I>] [-l|--load <P>] [-t|--timeout <T>] [--load-type <type>] [-c|--cores-list [...]]

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
  -h, --help             Show this help and exit

Example of use:
  run.sh --load 70 --timeout 10s --load-type double --cores-list 0,2,4
```

To better understand the behavior of this command see the examples below.



### Example 1

```shell
run.sh --load 70 --timeout 10s --load-type double --cores-list 0,2,4
```

It will load core 0 with 70% of load using double tests for 10 seconds. It will ignore cores 2 and 4 as there is not enough load for them.



### Example 2

```shell
run.sh -I 3 --load 140 --timeout 1m --load-type all --cores-list 0,2,4
```

It will load core 0 with 100% of load and core 2 with 40% of load using all tests for 1 minute 3 times. It will ignore core 4 as there is not enough load for it.



### Example 3

```shell
run.sh --load 240 --timeout 1m --load-type all --cores-list 0,2,4
```

It will load core 0 and 2 with 100% of load and core 4 with 40% of load using all tests for 1 minute.



### Example 4

```shell
run.sh --load 340 --timeout 1m --load-type all --cores-list 0,2,4
```

It will load core 0, 2 and 4 with 100% of load using all tests for 1 minute. Although specified load is 340%, the maximum load that can be executed with 3 cores is 300%, so the load value is reassigned to its maximum possible value (300%).
