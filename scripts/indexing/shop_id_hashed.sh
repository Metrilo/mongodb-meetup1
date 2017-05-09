#!/bin/bash

ensure_sharding_command="
  use mongodb_meetup1;
  db.customers.createIndex({ shop_id: \"hashed\" });

  sleep(1000);

  sh.shardCollection(\"mongodb_meetup1.customers\", { shop_id: \"hashed\" });
"

docker exec -it mongos1 bash -c "echo '$ensure_sharding_command' | mongo"
