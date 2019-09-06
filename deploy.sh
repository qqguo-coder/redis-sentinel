# redis master ip
REDIS_MASTER_IP=192.168.70.1
# redis master port
REDIS_MASTER_PORT=6379

rm -rf ./conf/*.conf


cat > ./conf/master.conf <<EOF
port $REDIS_MASTER_PORT
dir "/data"
logfile "master-$REDIS_MASTER_PORT.log"
dbfilename "master-dump-$REDIS_MASTER_PORT.rdb"
# master和slave都需要配置 requirepass 域masterauth，主要防止发生主从切换后，从节点连接不上主节点
requirepass "123456" 
masterauth "123456" 
EOF


SLAVE_PORT_LIST="6380 6381"

echo "Generate slave configuration file"
j=1
for SLAVE_PORT in $SLAVE_PORT_LIST
do
cat > ./conf/slave-$j.conf <<EOF
port $SLAVE_PORT
dir "/data"
logfile "slave-$SLAVE_PORT.log"
dbfilename "slave-dump-$SLAVE_PORT.rdb"
slaveof ${REDIS_MASTER_IP} ${REDIS_MASTER_PORT}
# master和slave都需要配置 requirepass 域masterauth，主要防止发生主从切换后，从节点连接不上主节点。
requirepass "123456"  
masterauth "123456" 
EOF
j=$(($j+1))
done


SENTINEL_PORT_LIST="26379 26380 26381"

echo "Generate sentinel configuration file"
i=1
for SENTINEL_PORT in $SENTINEL_PORT_LIST
do
cat > ./conf/sentinel-$i.conf <<EOF
port $SENTINEL_PORT
dir "/data"
logfile "sentinel-$SENTINEL_PORT.log"
sentinel monitor mymaster ${REDIS_MASTER_IP} ${REDIS_MASTER_PORT} 2
sentinel down-after-milliseconds mymaster 5000
sentinel failover-timeout mymaster 5000
sentinel parallel-syncs mymaster 1
sentinel auth-pass mymaster "123456"  
EOF
i=$(($i+1))
done


docker-compose up -d
