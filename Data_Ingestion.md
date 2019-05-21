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

[참고]http://hochul.net/blog/datacollector_apache_sqoop_from_rdbms2/
```
####1 특정 테이블 데이터 import 
   mysql.example.com의 MySQL DB내 mydb Database에 접속하여 acclog 라는 테이블 전체를 Import 하여 Hadoop 저장하는 기본적인 방법
   sqoop import \
   --connect jdbc:mysql://mysql.example.com/mydb \
   --username sqoop \
   --password sqoop \
   --table acclog \
   --target-dir /teststore/input/acclog

####2 DB내 전체 테이블 Import 
   mydb Database에 접속하여 2개 테이블(cities, countires)를 제외한 테이블 전체를 Import
   sqoop import-all-tables \
   --connect jdbc:mysql://mysql.example.com/mydb \
   --username sqoop \
   --password sqoop \
   --exclude-tables cities,countries \
   --warehouse-dir /teststore/input/

####3 Mapper 개수 지정 
   mydb Database 의 acclog 테이블 전체의 데이터를 가져올 때 10개의 mapper 수를 지정함으로써 Hadoop 처리 속도를 조절 할 수 있다.
   시스템상황을 고려해서 개수를 설정하면 된다. 
   sqoop import \
   --connect jdbc:mysql://mysql.example.com/mydb \
   --username sqoop \
   --password sqoop \
   --table acclog \
   --target-dir /teststore/input/acclog \
   --num-mappers 10

####4 일부 데이터, 조건에 맞는 데이터 가져오기 
   A) --incremental 옵션 사용 [증분추가]
        [ acclog 테이블의 seq 칼럼값이 8910000 이상인 것만 import ]
      acclog 테이블의 seq 칼럼값이 8910000 이상인 것만 import
        sqoop import \
        --connect jdbc:mysql://mysql.example.com/mydb \
        --username sqoop \
        --password sqoop \
        --table acclog \
        --target-dir /teststore/input/acclog \
        --num-mappers 10 \
        --incremental append \
        --check-column seq \
        --last-value 8910000
		
   B) 특정 Query 조건에 맞는 데이터 가져오기
        sqoop import \
        --connect jdbc:mysql://mysql.example.com/mydb \
        --username sqoop \
        --password sqoop \
        --target-dir /teststore/input/acclog \
        --query 'SELECT seq, inputdate, searchkey \
                   FROM acclog
                   WHERE seq > 10' \
        --num-mappers 10 
		
####5 데이터 전송속도 높이기 --direct 옵션 
   --direct 옵션을 사용하여 DataBase의 Native Tool, 예를 들어 mysqldump를 활용하여 보다 빠르게 데이터를 가져올 수 있다.
   sqoop import \
   --connect jdbc:mysql://mysql.example.com/mydb \
   --username sqoop \
   --password sqoop \
   --table acclog \
   --target-dir /teststore/input/acclog \
   --num-mappers 10 \
   --direct
```

### 1-2. Sqoop : RDB to Hive

<ul>
 <li> 테이블명만 주면 Default Database 테이블 </li>
 <li> Database 설정을 위해선 Hive에서 미리 Database 생성해야 함 [CREATE DATABASE userdb;] </li>
 <li> hive-import 옵션이 붙을경우 target-dir 옵션은 의미가 없어짐 </li>
 <li> Hive로 가져올때도, 여러가지 조건을 주면서 가져올 수 있으니 조합 잘 할 것 </li>
</ul>

```
####1 기본형 [1개의 테이블을 Default database import]
sqoop import \
--connect "jdbc:mysql://localhost/loudacre" \
--username training \
--password training \
--table accountdevice \
--hive-import \
--hive-table accountdevice

####2 기본형 [1개의 테이블을 특정 database import]
sqoop import \
--connect "jdbc:mysql://localhost/loudacre" \
--username training \
--password training \
--table accountdevice \
--hive-import \
--hive-table userDatabase.accountdevice

####3 import-all-tables to hive
sqoop import-all-tables \
--connect jdbc:mysql://<hostname>:3306/<database> \
--username <username>\
--password <password> \
--hive-import \
--hive-database <database_name> \
--autoreset-to-one-mapper \
--hive-overwrite \
--create-hive-table
```



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

#### Import table using an alternate file format(Parquet)**

```
[training@localhost ~]$ sqoop import \
> --connect jdbc:mysql://localhost/loudacre \
> --username training --password training \
> --table basestations \
> --target-dir /loudacre/basestations_import_parquet \
> --as-parquetfile
19/03/10 21:26:20 INFO sqoop.Sqoop: Running Sqoop version: 1.4.6-cdh5.7.0
19/03/10 21:26:20 WARN tool.BaseSqoopTool: Setting your password on the command-line is insecure. Consider using -P instead.
19/03/10 21:26:20 INFO manager.MySQLManager: Preparing to use a MySQL streaming resultset.
19/03/10 21:26:20 INFO tool.CodeGenTool: Beginning code generation
19/03/10 21:26:20 INFO tool.CodeGenTool: Will generate java class as codegen_basestations
19/03/10 21:26:21 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `basestations` AS t LIMIT 1
19/03/10 21:26:21 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `basestations` AS t LIMIT 1
19/03/10 21:26:21 INFO orm.CompilationManager: HADOOP_MAPRED_HOME is /usr/lib/hadoop-mapreduce
Note: /tmp/sqoop-training/compile/041269c8f87f45f59ddfcab7b929c4c2/codegen_basestations.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.
19/03/10 21:26:23 INFO orm.CompilationManager: Writing jar file: /tmp/sqoop-training/compile/041269c8f87f45f59ddfcab7b929c4c2/codegen_basestations.jar
19/03/10 21:26:23 WARN manager.MySQLManager: It looks like you are importing from mysql.
19/03/10 21:26:23 WARN manager.MySQLManager: This transfer can be faster! Use the --direct
19/03/10 21:26:23 WARN manager.MySQLManager: option to exercise a MySQL-specific fast path.
19/03/10 21:26:23 INFO manager.MySQLManager: Setting zero DATETIME behavior to convertToNull (mysql)
19/03/10 21:26:23 INFO mapreduce.ImportJobBase: Beginning import of basestations
19/03/10 21:26:23 INFO Configuration.deprecation: mapred.job.tracker is deprecated. Instead, use mapreduce.jobtracker.address
19/03/10 21:26:24 INFO Configuration.deprecation: mapred.jar is deprecated. Instead, use mapreduce.job.jar
19/03/10 21:26:25 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `basestations` AS t LIMIT 1
19/03/10 21:26:25 INFO manager.SqlManager: Executing SQL statement: SELECT t.* FROM `basestations` AS t LIMIT 1
19/03/10 21:26:26 INFO Configuration.deprecation: mapred.map.tasks is deprecated. Instead, use mapreduce.job.maps
19/03/10 21:26:26 INFO client.RMProxy: Connecting to ResourceManager at /0.0.0.0:8032
19/03/10 21:26:29 INFO db.DBInputFormat: Using read commited transaction isolation
19/03/10 21:26:29 INFO db.DataDrivenDBInputFormat: BoundingValsQuery: SELECT MIN(`station_num`), MAX(`station_num`) FROM `basestations`
19/03/10 21:26:29 INFO db.IntegerSplitter: Split size: 94; Num splits: 4 from: 1 to: 377
19/03/10 21:26:29 INFO mapreduce.JobSubmitter: number of splits:4
19/03/10 21:26:29 INFO mapreduce.JobSubmitter: Submitting tokens for job: job_1552277124392_0002
19/03/10 21:26:29 INFO impl.YarnClientImpl: Submitted application application_1552277124392_0002
19/03/10 21:26:29 INFO mapreduce.Job: The url to track the job: http://localhost:8088/proxy/application_1552277124392_0002/
19/03/10 21:26:29 INFO mapreduce.Job: Running job: job_1552277124392_0002
19/03/10 21:26:39 INFO mapreduce.Job: Job job_1552277124392_0002 running in uber mode : false
19/03/10 21:26:39 INFO mapreduce.Job:  map 0% reduce 0%
19/03/10 21:26:47 INFO mapreduce.Job:  map 25% reduce 0%
19/03/10 21:26:54 INFO mapreduce.Job:  map 50% reduce 0%
19/03/10 21:27:00 INFO mapreduce.Job:  map 75% reduce 0%
19/03/10 21:27:07 INFO mapreduce.Job:  map 100% reduce 0%
19/03/10 21:27:07 INFO mapreduce.Job: Job job_1552277124392_0002 completed successfully
19/03/10 21:27:08 INFO mapreduce.Job: Counters: 30
	File System Counters
		FILE: Number of bytes read=0
		FILE: Number of bytes written=565464
		FILE: Number of read operations=0
		FILE: Number of large read operations=0
		FILE: Number of write operations=0
		HDFS: Number of bytes read=38777
		HDFS: Number of bytes written=24593
		HDFS: Number of read operations=272
		HDFS: Number of large read operations=0
		HDFS: Number of write operations=40
	Job Counters 
		Launched map tasks=4
		Other local map tasks=4
		Total time spent by all maps in occupied slots (ms)=0
		Total time spent by all reduces in occupied slots (ms)=0
		Total time spent by all map tasks (ms)=21496
		Total vcore-seconds taken by all map tasks=21496
		Total megabyte-seconds taken by all map tasks=5502976
	Map-Reduce Framework
		Map input records=377
		Map output records=377
		Input split bytes=477
		Spilled Records=0
		Failed Shuffles=0
		Merged Map outputs=0
		GC time elapsed (ms)=395
		CPU time spent (ms)=5580
		Physical memory (bytes) snapshot=668753920
		Virtual memory (bytes) snapshot=8298037248
		Total committed heap usage (bytes)=251920384
	File Input Format Counters 
		Bytes Read=0
	File Output Format Counters 
		Bytes Written=0
19/03/10 21:27:08 INFO mapreduce.ImportJobBase: Transferred 24.0166 KB in 41.1801 seconds (597.206 bytes/sec)
19/03/10 21:27:08 INFO mapreduce.ImportJobBase: Retrieved 377 records.
```


#### Check the contents of Parquet file using parquet-tools**

```
[training@localhost ~]$ parquet-tools head hdfs://localhost/loudacre/basestations_import_parquet/
station_num = 95
zipcode = 91311
city = Chatsworth
state = CA
latitude = 34.2583
longitude = -118.591

station_num = 96
zipcode = 91330
city = Northridge
state = CA
latitude = 33.7866
longitude = -118.299

station_num = 97
zipcode = 91351
city = Canyon Country
state = CA
latitude = 34.4262
longitude = -118.449

station_num = 98
zipcode = 91352
city = Sun Valley
state = CA
latitude = 34.2209
longitude = -118.37

station_num = 99
zipcode = 91355
city = Valencia
state = CA
latitude = 34.3985
longitude = -118.553\
```

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

