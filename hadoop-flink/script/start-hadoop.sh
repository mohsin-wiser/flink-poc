#!/bin/bash
sudo /etc/init.d/ssh start
/usr/local/hadoop/sbin/start-all.sh
jps
/usr/local/hadoop/bin/hdfs dfs -mkdir /warehouse
/usr/local/hadoop/bin/hdfs dfs -mkdir /warehouse/catalog
/usr/local/hadoop/bin/hdfs dfs -mkdir /warehouse/lakehouse
# /bin/bash
while true
do
	echo "Press [CTRL+C] to stop.."
	sleep 10
done