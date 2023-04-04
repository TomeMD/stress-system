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
  -o, --output <dir>     Directory to store log files. It must be an existing directory.
  -h, --help             Show this help and exit

Example of use:
  run.sh --load 70 --timeout 10s --load-type double --cores-list 0,2,4
```

This tool assigns the load incrementally to each core, instead of distributing the load among all available cores. To better understand his behavior see the examples below.

<style>
  .progress-container {
    width: 100%;
    margin-bottom: 10px;
  }

  .progress-bar {
    width: 0%;
    height: 30px;
    background-color: #4caf50;
    display: inline-block;
  }
  th, td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid #ddd;
  }

  td:nth-child(2) {
    width: 200px;
  }
</style>

### Example 1

```shell
run.sh --load 70 --timeout 10s --load-type double --cores-list 0,2,4
```
<table>
  <tr>
    <th>Core</th>
    <th><div align = "center">Load</div></th>
  </tr>
  <tr>
    <td>0</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 70%;">
          <div align = "center">70%</div>
        </div>
      </div>
    </td>
  </tr>
  <tr>
    <td>2</td>
    <td>
      <div class="progress-container">
        <div>
          0%
        </div>
      </div>
    </td>
  </tr>
  <tr>
    <td>4</td>
    <td>
      <div class="progress-container">
        <div>
          0%
        </div>
      </div>
    </td>
  </tr>
</table>

It will load core 0 with 70% of load using double tests for 10 seconds. It will ignore cores 2 and 4 as there is not enough load for them.


### Example 2

```shell
run.sh -i 3 --load 140 --timeout 1m --load-type all --cores-list 0,2,4
```
<table>
  <tr>
    <th>Core</th>
    <th><div align = "center">Load</div></th>
  </tr>
  <tr>
    <td>0</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 100%;">
          <div align = "center">100%</div>
        </div>
      </div>
    </td>
  </tr>
  <tr>
    <td>2</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 40%;">
          <div align = "center">40%</div>
      </div>
    </td>
  </tr>
  <tr>
    <td>4</td>
    <td>
      <div class="progress-container">
        <div>
          0%
        </div>
      </div>
    </td>
  </tr>
</table>

It will load core 0 with 100% of load and core 2 with 40% of load using all tests for 1 minute 3 times. It will ignore core 4 as there is not enough load for it.


### Example 3

```shell
run.sh --load 240 --timeout 1m --load-type all --cores-list 0,2,4
```
<table>
  <tr>
    <th>Core</th>
    <th><div align = "center">Load</div></th>
  </tr>
  <tr>
    <td>0</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 100%;">
          <div align = "center">100%</div>
        </div>
      </div>
    </td>
  </tr>
  <tr>
    <td>2</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 100%;">
          <div align = "center">100%</div>
        </div>
      </div>
    </td>
  </tr>
  <tr>
    <td>4</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 40%;">
          <div align = "center">40%</div>
        </div>
      </div>
    </td>
  </tr>
</table>

It will load core 0 and 2 with 100% of load and core 4 with 40% of load using all tests for 1 minute.


### Example 4

```shell
run.sh --load 340 --timeout 1m --load-type all --cores-list 0,2,4
```
<table>
  <tr>
    <th>Core</th>
    <th><div align = "center">Load</div></th>
  </tr>
  <tr>
    <td>0</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 100%;">
          <div align = "center">100%</div>
        </div>
      </div>
    </td>
  </tr>
  <tr>
    <td>2</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 100%;">
          <div align = "center">100%</div>
        </div>
      </div>
    </td>
  </tr>
  <tr>
    <td>4</td>
    <td>
      <div class="progress-container">
        <div class="progress-bar" style="width: 100%;">
          <div align = "center">100%</div>
        </div>
      </div>
    </td>
  </tr>
</table>

It will load core 0, 2 and 4 with 100% of load using all tests for 1 minute. Although specified load is 340%, the maximum load that can be executed with 3 cores is 300%, so the load value is reassigned to its maximum possible value (300%).
