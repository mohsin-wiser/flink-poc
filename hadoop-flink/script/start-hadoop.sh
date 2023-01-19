#!/bin/bash
sudo /etc/init.d/ssh start
/usr/local/hadoop/sbin/start-all.sh
jps
# while true
# do
# 	echo "Press [CTRL+C] to stop.."
# 	sleep 1000
# done
/bin/bash