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

