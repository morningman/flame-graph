#!/bin/bash
## @brief  
## @author zhoufei
## @email  gavineaglechou@gmail.com
## @date   2018-04-01-Fri


if [ `whoami` != "root" ]; then
	echo -e "usage:\n    sudo sh $0 [\$pid] [java]"
	exit 1
fi

# ATTN: Uncomment to choose the one suites for you
s3 = xxx.oss-cn-beijing.aliyuncs.com

# for java flame
export JAVA_HOME=/opt/java/jdk1.8.0_131
export AGENT_HOME=$(pwd)/perf-map-agent

cd `dirname $0`
echo `date`" test"

perf_time=10

rm -f perf.data
pid=$1
if [ "x${pid}" == "x" ]; then
	perf record -F 99 -a -g -o perf.data -- sleep ${perf_time}
else
	perf record -F 99 -a -g -p ${pid} -o perf.data -- sleep ${perf_time}
fi
if [ "x$2" == "xjava" ]; then
	./FlameGraph/jmaps
fi

svg_name=`hostname`"-"`date +"%Y%m%d%H%M%S"`".svg"

# perf script | ./FlameGraph/stackcollapse-perf.pl > out.perf-folded
# ./FlameGraph/flamegraph.pl out.perf-folded > ${svg_name}

perf script | ./FlameGraph/stackcollapse-perf.pl | ./FlameGraph/flamegraph.pl > ${svg_name}

#cmd="curl -H'content-type:application/xml' -T ${svg_name} ${s3}/flame-graph/${svg_name}"
#echo "${cmd}"
#eval "${cmd}"
