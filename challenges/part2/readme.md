# Bigdata_0522

*Company Name : SK C&C*

*Company ID : 09340*

*Name : 이호영*


![Alt text](https://github.com/Lee-Ho-Young/Bigdata_0416/blob/master/picture.png)



## 1. Write a query to compare each active account’s balance to the average balance of all active accounts of the same type.

<ul>
 <li> Run a sql file with hive CMD </li>
 <li> Round func. </li>
</ul>


```
SELECT 
      A.ID                   AS ID
    , A.TYPE                 AS TYPE
    , A.STATUS               AS TYPE
    , A.AMOUNT               AS AMOUNT
    , ROUND((A.AMOUNT - B.AVERAGE),2) AS DIFFERENCE
FROM 
(
    SELECT
          ID
        , TYPE
        , STATUS
        , AMOUNT
    FROM ACCOUNT
    WHERE STATUS = 'Active'
) A,
(
    SELECT 
          TYPE
        , AVG(AMOUNT) AVERAGE
    FROM ACCOUNT
    WHERE STATUS = 'Active'
    GROUP BY TYPE
) B
WHERE A.TYPE = B.TYPE
;
```

![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/1-1.PNG)
![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/1-2.PNG)
![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/1-3.PNG)




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

<ul>
 <li> Create table </li>
 <li> Dynamic schema control </li>
 <li> Hive to HDFS </li>      
</ul>


```
create database problem4;

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

select distinct(length(customer_id)) from employee1; --result : 8
select distinct(length(customer_id)) from employee2; --result : 8
select * from employee2 where state = 'CA' -- 0 result

CREATE TABLE problem4.employee3 
AS 
SELECT * FROM
(
SELECT
    CUSTOMER_ID
    , initcap(first_name) as first_name
    , initcap(last_name) as last_name
    , address
    , city
    , state
    , cast(substr(zip_code,1,5) as int) as zip_code 
FROM EMPLOYEE1
WHERE state = 'CA'

UNION ALL

SELECT 
    CUSTOMER_ID
    , initcap(first_name) as first_name
    , initcap(last_name) as last_name
    , address
    , city
    , state
    , cast(substr(zip_code,1,5) as int) as zip_code 
FROM EMPLOYEE2
WHERE state = 'CA'
) unioned
```

![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/4-1.PNG)
![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/4-2.PNG)
![Alt text](https://github.com/Lee-Ho-Young/bigdata_0520/blob/master/contents/4-3.PNG)




## 5. The bank is making a Facebook group for the Palo Alto, CA branch. Generate a script that outputs the customers and employees who live in Palo Alto, CA.


## 6. There are privacy concerns about the employee data that is stored on the cluster. Your task is to remove any age information from the employee data by creating a new table for the data analysts to query against.


## 7. Generate a report that contains all of the Seattle employee names in sorted order.


## 8. Use Sqoop to export customer data from HDFS into a MySQL database table. Place the data in the solution table in MySQL, which has been created and is currently empty.


## 9. Your company is being acquired by another company. To prepare for this acquisition, update the customer records to guarantee there will be no duplicate IDs with their existing customer IDs.


## 10. Your boss needs specialized reports using the billing data and is constantly asking for help to write SQL queries. Create a database view in the metastore so that your boss has customer and billing data joined.


## 11. Several analysis questions are described below and you will need to write the SQL code to answer them. You can use whichever tool you prefer – Impala or Hive – using whichever method you like best, including shell, script, or the Hue Query Editor, to run your queries.

