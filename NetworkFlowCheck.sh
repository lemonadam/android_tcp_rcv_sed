#!/bin/bash
#eg:sh NetworkFlowCheck.sh com.taobao.trip ./log.log
apkname=$1
printf "\nBegin record data. yes or no?:"
read start < /dev/tty
printf "\n"
if [[ "$start" == "yes" ]];then


    begintime=$(date +%H:%M:%S)
    #get pid
    pid=`adb shell ps | grep $1 | awk '{s=$2} END {print s}'`
    #get uid
    uid=`adb shell cat /proc/$pid/status | grep Uid | awk '{s+=$2} END {print s}'`
    #get package tcp flow begin
    rcv_begin=`adb shell cat /proc/uid_stat/$uid/tcp_rcv | awk '{s+=$1} END {print s}'`
    snd_begin=`adb shell cat /proc/uid_stat/$uid/tcp_snd | awk '{s+=$1} END {print s}'`
   else
    exit
fi
printf "\nIf complete the action,please input done:"
read complete < /dev/tty
printf "\n"
if [[ "$complete" == "done" ]];then

    rcv_end=`adb shell cat /proc/uid_stat/$uid/tcp_rcv | awk '{s+=$1} END {print s}'`
    snd_end=`adb shell cat /proc/uid_stat/$uid/tcp_snd | awk '{s+=$1} END {print s}'`


else
    exit
fi
endtime=$(date +%H:%M:%S)

#push receive&transmit network flow

rcv=`echo "$rcv_end-$rcv_begin"|bc`
snd=`echo "$snd_end-$snd_begin"|bc`


#kill all adb
adbId=`ps -A |grep adb|grep -v "grep\|server" | awk '{print $1}'`
kill -9 $adbId

echo "************* $1 tcp flow info ****************"
echo "$begintime ~ $endtime $1 receive tcp flow is : $rcv bytes"
echo "$begintime ~ $endtime $1 transmit tcp flow is : $snd bytes"

exit