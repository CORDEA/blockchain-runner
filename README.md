# blockchain-runner

Scripts to check the behavior of [blockchain](https://github.com/CORDEA/blockchain).

## Usage

```sh
$ docker build -t blockchain:latest container/
$ ./start-all.sh # start 10 containers
$ nim c -r connector.nim # connect randomly between containers
$ xpanes -c 'docker logs -f blockchain{}' {0..9} # check logs of all containers
$ ./mine.sh 5
$ ./check-block-all.sh
$ ./mine.sh 7
$ ./check-block-all.sh
$ ./rm-all.sh # remove all blockchain containers
```
