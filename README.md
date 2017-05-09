### Initialize mongodb cluster cluster ###
```
$ ./scripts/initiate.sh
```

### Pick type of indexing & sharding of customers collection ###
```
$ ./scripts/indexing/shop_id.sh
# OR
$ ./scripts/indexing/shop_id_hashed.sh
# OR
$ ./scripts/indexing/shop_id_and_first_order_at.sh
```

### Pick data set to restore ###
```
$ mongorestore --port 27020 dumps/even_distributed
# OR
$ mongorestore --port 27020 dumps/one_big_project_distributed
```

### Clear data and shut down the cluster
```
$ ./scripts/clear_mongodb.sh
```
