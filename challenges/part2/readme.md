
## 2. Create an employee table in the metastore that contains the employee records stored in HDFS.

```
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
```

![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/part2_2_result.PNG)


## 3. Generate a table that contains all customers who have negative account balances.

```
create table solution AS
select
      c.id      as id
    , c.fname   as fname
    , c.lname   as lname
    , c.hphone  as hphone
from customer c, account a
where c.id = a.custid
and a.amount < 0
;
```

![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/part2_3_result.PNG)


## 4. LoudAcre Mobile has merged with another company located in California. Each company has a list of customers in different formats. Combine the two customer lists into a single dataset using an identical schema.

```
CREATE EXTERNAL TABLE problem4.employee1 (
    customer_id int,
    first_name string,
    last_name string,
    address string,
    city string,
    state string,
    zip_code string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS textfile
LOCATION 'hdfs:///user/training/problem4/data/employee1';

CREATE EXTERNAL TABLE problem4.employee2 (
    customer_id int,
    last_name string,
    first_name string,
    address string,
    city string,
    state string,
    zip_code string
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY "," ESCAPED BY '\\'
STORED AS textfile
LOCATION 'hdfs:///user/training/problem4/data/employee2';


SELECT distinct length(CAST(customer_id as string)) FROM EMPLOYEE1; -- 8
SELECT distinct length(CAST(customer_id as string)) FROM EMPLOYEE1; -- 8


CREATE TABLE problem4.employee2 (
    customer_id int,
    last_name string,
    first_name string,
    address string,
    city string,
    state string,
    zip_code string
) AS
SELECT 
    CUSTOMER_ID
    , first_name
    , last_name
    , address
    , city
    , state
    , zip_code
FROM EMPLOYEE1
WHERE

UNION

SELECT 
    CUSTOMER_ID
    , first_name
    , last_name
    , address
    , city
    , state
    , zip_code
FROM EMPLOYEE1
WHERE
```
