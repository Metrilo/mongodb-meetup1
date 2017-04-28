### Initialize docker compose cluster ###
```
$ DATA_DIR=./data
$ docker-compose up
$ ./initiate
```

### Reset data directory ###
```
$ docker-compose rm
$ ./reset
$ DATA_DIR=./data
$ docker-compose up
$ ./initiate
```
