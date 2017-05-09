#!/bin/bash

echo "Starting MongoDB sharded cluster"
docker-compose up -d

sleep 5

# Data replica sets initialization
for (( rs_index = 1; rs_index <= 3; rs_index++ )); do
  echo "Intializing replica mongors${rs_index} set"

  replicate_data_node="
    rs.initiate({
      _id: \"mongors${rs_index}\",
      version: 1,
      members: [
        { _id: ${rs_index}, host: \"mongors${rs_index}:27018\" }
      ]
    });
  "

  docker exec -it mongors${rs_index} bash -c "echo '${replicate_data_node}' | mongo --port 27018"

  sleep 2
done

sleep 3

# ConfigDB replication initialization
echo "Intializing replica set for the config db"

replicate_config_node="
  rs.initiate({
    _id: \"mongocfgrs\",
    version: 1,
    members: [
      { _id: 0, host: \"mongocfg1:27017\" }
    ]
  });
"

docker exec -t mongocfg1 bash -c "echo '${replicate_config_node}' | mongo"

sleep 5

# Routing initialization
echo "Initialize router with sharding"

prepare_router_node="
  sh.addShard(\"mongors1/mongors1:27018\");
  sleep(1000);
  sh.addShard(\"mongors2/mongors2:27018\");
  sleep(1000);
  sh.addShard(\"mongors3/mongors3:27018\");
  sleep(1000);
"
docker exec -it mongos1 bash -c "echo '${prepare_router_node}' | mongo"

change_chunk_size="
  use config;
  db.settings.save({ _id: \"chunksize\", value: 1 });
  sleep(1000);
  sh.status();
"
docker exec -it mongos1 bash -c "echo '${change_chunk_size}' | mongo"

enable_sharding_command="sh.enableSharding(\"mongodb_meetup1\");"
docker exec -it mongos1 bash -c "echo '${enable_sharding_command}' | mongo"
