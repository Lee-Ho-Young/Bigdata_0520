echo "`uname -n`||`date +'%y%m%d%H%M%S'`||CPU||`sar 1 1 | grep Average | awk '{print $3"||"$4"||"$5"||"$6"||"$7"||"$8}'`||MEM||`free -m | grep Mem | awk '{print $2"||"$3"||"$4}'`||SWAP||`free -m | grep Swap | awk '{print $2"||"$3"||"$4}'`" >> /home/bigdata/syslog/monitor.log
