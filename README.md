# HA Redis Cluster with Sentinel by Docker Compose(1master+2slave+3sentinel)

There are following services in the cluster

* master: 1 Master Redis Server
* slave: 2 Slave Redis Server
* sentinel: 3 Sentinel Server

## Try it

### Create configuration files and start services

```
$ sh deploy.sh
```

### Check the status

```
$ docker-compose ps
```

```
              Name                            Command               State                 Ports
--------------------------------------------------------------------------------------------------------------
redis-sentinel_demo_master_1       docker-entrypoint.sh redis ...   Up      0.0.0.0:6379->6379/tcp
redis-sentinel_demo_sentinel-1_1   docker-entrypoint.sh redis ...   Up      0.0.0.0:26379->26379/tcp, 6379/tcp
redis-sentinel_demo_sentinel-2_1   docker-entrypoint.sh redis ...   Up      0.0.0.0:26380->26380/tcp, 6379/tcp
redis-sentinel_demo_sentinel-3_1   docker-entrypoint.sh redis ...   Up      0.0.0.0:26381->26381/tcp, 6379/tcp
redis-sentinel_demo_slave-1_1      docker-entrypoint.sh redis ...   Up      6379/tcp, 0.0.0.0:6380->6380/tcp
redis-sentinel_demo_slave-2_1      docker-entrypoint.sh redis ...   Up      6379/tcp, 0.0.0.0:6381->6381/tcp
```

### Connect it

```
$ ./redis-cli  -h 127.0.0.1 -p 26379
127.0.0.1:26379> SENTINEL get-master-addr-by-name mymaster
1) "127.0.0.1"
2) "6379"
```

```
./redis-cli -h 127.0.0.1 -p 6379 -a 123456
Warning: Using a password with '-a' or '-u' option on the command line interface may not be safe.
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379>
```

