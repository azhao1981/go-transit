#!/bin/bash
cd `dirname $0`
dir=`pwd`
exec_name=$dir/bin/go-transit
log_dir=$dir/logs
# cfg for kill
cfg=UT_BIZ_V1

# export REALTIME_SERVER_URL="http://localhost:8082"
# export CACHE_SERVER_PORT=":8182"

case "$1" in
  start)
    echo "Starting $exec_name......" >> $log_dir/stdout.log
    nohup $exec_name -f etc/api_9001.json $cfg >> $log_dir/api_9001.log 2>&1 &
    nohup $exec_name -f etc/file_9002.json $cfg >> $log_dir/file_9002.log 2>&1 &
    nohup $exec_name -f etc/mp_9003.json $cfg >> $log_dir/mp_9003.log 2>&1 &
    echo "Done"
    ;;
  stop)
    echo "Stop $exec_name......"
    pid=`ps aux | grep -v grep | grep "$exec_name" | grep "${cfg}" | awk '{print $2}'`
    (($pid)) && kill -9 $pid
    echo "Done"
    ;;
  stat)
    ps aux | grep -v grep | grep "$exec_name" | grep "${cfg}"
    ;;
  restart)
    echo "Restart $exec_name......" >> $log_dir/stdout.log
    pid=`ps aux | grep -v grep | grep "$exec_name" | grep "${cfg}" | awk '{print $2}'`
    (($pid)) && kill -9 $pid
    sleep 1
    echo "Old server stoped ...... "
    ps aux | grep -v grep | grep "$exec_name" | grep "${cfg}"
    echo "Starting $exec_name ......"
    nohup $exec_name -f etc/api_9001.json $cfg >> $log_dir/api_9001.log 2>&1 &
    nohup $exec_name -f etc/file_9002.json $cfg >> $log_dir/file_9002.log 2>&1 &
    nohup $exec_name -f etc/mp_9003.json $cfg >> $log_dir/mp_9003.log 2>&1 &
    echo "Done"
    ;;
  *)
    echo "Usage: ./server_ctl.sh {start|stop|restart|stat}" >&2
    ;;
esac

