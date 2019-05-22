
## 2. Create an employee table in the metastore that contains the employee records stored in HDFS.

CREATE EXTERNAL TABLE problem2.employee (
    id int,
    fname string,
    lname string,
    address string,
    city string,
    state string,
    zip string,
    birthday string,
    hireday string
)
STORED AS PARQUET
LOCATION 'hdfs:///user/training/problem2/data/employee';



