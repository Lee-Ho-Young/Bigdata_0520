## 1. Sqoop을 사용한 데이터 RDB 데이터 추출

### 1-1. Sqoop : RDB to HDFS

1. 에러가 발생할 경우 localhost를 지정해둔 hostname으로 변경해볼것
2. 에러가 발생할 경우 아래의 Driver옵션문구도 추가해 볼것
   [ --driver com.mysql.jdbc.Driver ]
```
sqoop import \
--connect "jdbc:mysql://localhost/loudacre" \
--username training \
--password training \
--table accountdevice \
--delete-target-dir \
--target-dir /loudacre/mysql/accountdevice
```

### 1-2. Sqoop : RDB to Hive

### 1-3. Hive : HDFS directory to Hive table

<ul>
 <li> Create table with schema </li>
 <li> Import table with metadata file </li>
</ul>

[참고]https://blogs.msdn.microsoft.com/data_otaku/2016/12/20/exploring-the-hive-import-and-export-commands/
```
## Create table with schema
CREATE TABLE ManagedUnpartitioned (
column1 STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
LOCATION '/demo/managedunpartitioned/';

## Import table with metadata file
IMPORT TABLE tablename FROM 'targeted import location';
```

### 1-4. Sqoop : Data format


## 2. Flume을 log 데이터 수집

### 2-1. Flume : spoolDir source - hdfs sink

```
# Define sources, sinks, and channel for agent named 'agent1'
agent1.sources = src1
agent1.sinks = sink1
agent1.channels = ch1

# Configure the source
agent1.sources.src1.type = spooldir
agent1.sources.src1.spoolDir = /var/flume/incoming

# Configure the channel
agent1.channels.ch1.type = memory
agent1.channels.ch1.capacity = 1000
agent1.channels.ch1.transactionCapacity = 100

# Configure the sink
agent1.sinks.sink1.type = hdfs
agent1.sinks.sink1.hdfs.path = /loudacre/logdata/
agent1.sinks.sink1.hdfs.fileType = DataStream
agent1.sinks.sink1.hdfs.fileSuffix = .txt

#Bind the source and sink to the channel
agent1.sinks.sink1.channel = ch1
agent1.sources.src1.channels = ch1
```

### 2-2. Flume : exec source - hdfs sink

```
# Define sources, sinks, and channel for agent named 'agent1'
agent1.sources = src1
agent1.sinks = sink1
agent1.channels = ch1

# Configure the source
agent1.sources.src1.type = exec
agent1.sources.src1.command = tail -F /var/flume/incoming/weblogs.log

# Configure the channel
agent1.channels.ch1.type = memory
agent1.channels.ch1.capacity = 1000
agent1.channels.ch1.transactionCapacity = 100

# Configure the sink
agent1.sinks.sink1.type = hdfs
agent1.sinks.sink1.hdfs.path = /loudacre/logdata
agent1.sinks.sink1.hdfs.fileType = DataStream
agent1.sinks.sink1.hdfs.fileSuffix = .txt

#Bind the source and sink to the channel
agent1.sinks.sink1.channel = ch1
agent1.sources.src1.channels = ch1
```

