#!/bin/bash

# Check SGA total
echo "Total SGA"
ipcs -m | awk '/oracle/ { s+=$5 }; END { print "SGA ",s/1024/1024/1024,"GB" }'

# Check pages size
pgrep ora_lgwr | while read PID ; do
#echo $PID
#echo grep VmSwap /proc/$PID/status
ps -f -p $PID | tail -1
cat /proc/$PID/smaps | perl -ane 'if ($F[0] =~  /^Size:$/) { $SIZE=$F[1];@NEXT=split(/\s+/,<>); $PAGE=$NEXT[1]; $SIZEPERPAGE{$PAGE}+= $SIZE ;};' \
-e  'END { map { printf("%20s kB = %d GB\n",$_,($SIZEPERPAGE{$_})/1024/1024) if ($SIZEPERPAGE{$_})/1024/1024 > 0 } (keys %SIZEPERPAGE) ; };' \
-e  'if ($F[0] =~  /^Swap:$/) { $SIZEPERPAGE{"SWAPPED $PAGE"}+= $F[1]  }; '
done

echo "Should be oracle gid"
cat /proc/sys/vm/hugetlb_shm_group

echo "Check HP"
grep ^HugePages /proc/meminfo
