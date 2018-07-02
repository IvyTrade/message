#创建topic
createTopics(){
    echo "Create topics start"
    
	#Read from topics.data to create
	while myline=$(line)  
	do   
		echo "topic: "$myline 
    	nohup $KAFKA_HOME/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic $myline &
	done < topics.dat

    echo "Create topics end"
}

#判断是否有进程启动，如果有则kill
killProc(){
	pid=`jps -lm | grep org.apache.zookeeper.server.quorum.QuorumPeerMain | awk '{print $1}'`
	kill -9 $pid

	pid=`jps -lm | grep kafka.Kafka | awk '{print $1}'`
	kill -9 $pid
}

#判断zookeeper是否启动成功
checkZookeeper(){
	pid=`jps -lm | grep org.apache.zookeeper.server.quorum.QuorumPeerMain | awk '{print $1}'`
}


#启动
nohup $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties>zookeeper-server-start.log 2>&1&
echo "******************log folder: "${kafka.logs.dir}
if [ $? -eq 0 ]; then
	sleep 20s
	nohup $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties>kafka-server-start.log 2>&1&
    if [ $? -eq 0 ]; then
		sleep 20s
    	createTopics
		echo "*****************************************"
		$KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper localhost:2181
		echo "*****************************************"
    else
    	echo "Fail to start kafka server"
    fi 
else
    echo "Fail to start zookeeper"
fi

