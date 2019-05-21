## 1. Hive를 사용한 데이터 조작

### 1-1. HDFS Directory -> Hive table



## 2. Impala를 사용한 데이터 조작

### 2-1. Impala에서 사용가능한 쿼리 기능 및 해당 쿼리를 사용하는 예제 
[참고]https://www.cloudera.com/documentation/enterprise/5-9-x/topics/impala_select.html#select

#### 알고 있는 모든 SQL구문은 사용가능

<ul>
 <li> DISTINCT </li>
 <li> JOIN </li>
 <li> UNION </li>
 <li> GROUP BY / ORDER  BY </li>
 <li> LIMIT </li>  
 <li> SUB_QUERY </li>  
 <li> WITH </li>  
 <li> IN / NOT IN </li>  
 <li> Most of Built in function like sum/count </li> 
</ul>

```
[WITH name AS (select_expression) [, ...] ]
SELECT
  [ALL | DISTINCT]
  [STRAIGHT_JOIN]
  expression [, expression ...]
FROM table_reference [, table_reference ...]
[[FULL | [LEFT | RIGHT] INNER | [LEFT | RIGHT] OUTER | [LEFT | RIGHT] SEMI | [LEFT | RIGHT] ANTI | CROSS]
  JOIN table_reference
  [ON join_equality_clauses | USING (col1[, col2 ...]] ...
WHERE conditions
GROUP BY { column | expression [, ...] }
HAVING conditions
ORDER BY { column | expression [ASC | DESC] [NULLS FIRST | NULLS LAST] [, ...] }
LIMIT expression [OFFSET expression]
[UNION [ALL] select_statement] ...]
```

#### 예제1
[참고]https://impala.apache.org/docs/build/html/topics/impala_tutorial.html

```
$ impala-shell -i localhost --quiet
$ select version();
$ show databases;
$ use default;
$ select current_database();
$ show tables;
$ describe customer_address

$select count(distinct c_birth_month) from customer;

$select count(*) from customer where c_email_address is null;

$select distinct c_salutation from customer limit 10;

$select min(x), max(x), sum(x), avg(x) from t1;
```

>>CSV files to table
```
DROP TABLE IF EXISTS tab1;
-- The EXTERNAL clause means the data is located outside the central location
-- for Impala data files and is preserved when the associated Impala table is dropped.
-- We expect the data to already exist in the directory specified by the LOCATION clause.
CREATE EXTERNAL TABLE tab1
(
   id INT,
   col_1 BOOLEAN,
   col_2 DOUBLE,
   col_3 TIMESTAMP
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/username/sample_data/tab1';

DROP TABLE IF EXISTS tab2;
-- TAB2 is an external table, similar to TAB1.
CREATE EXTERNAL TABLE tab2
(
   id INT,
   col_1 BOOLEAN,
   col_2 DOUBLE
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
LOCATION '/user/username/sample_data/tab2';
```


#### 예제1


```
-- Calculating the Top N Products
 
SELECT 
      p.prod_id
    , count(*) AS CNT
FROM products p     
    JOIN order_details od
        ON p.prod_id = od.prod_id
    JOIN orders o
        ON od.order_id = o.order_id
GROUP BY prod_id
ORDER BY CNT DESC
LIMIT 3
;
 
 
-- Calculating the Order Total
 
SELECT 
      o.order_id
    , SUM(p.price)  AS ord_price
FROM products p     
    JOIN order_details od
        ON p.prod_id = od.prod_id
    JOIN orders o
        ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY ord_price DESC
LIMIT 10
;
 
 
-- Calculating Revenue and Profit
 
SELECT
      order_date
    , sum(price)                as revenue               
    , sum(price) - sum(cost)    as profit 
FROM
(
SELECT 
      o.order_id
    , p.prod_id
    , p.price               
    , p.cost                
    , to_date(o.order_date) AS order_date
FROM products p     
    JOIN order_details od
        ON p.prod_id = od.prod_id
    JOIN orders o
        ON od.order_id = o.order_id
        
) AS T1
GROUP BY order_date
ORDER BY order_date
;
 
 
-- Bonus Exercise 1: Ranking Daily Profits by Month (미완성)
 
SELECT
	order_date
	RANK() OVER (PARTITION BY year ORDER BY profit DESC) AS year_rank
	--RANK() OVER(PARTITION BY year, month ORDER BY profit) AS month_rank
FROM
(
SELECT
      order_date
    , year
    , month           
    , sum(price) - sum(cost)    as profit 
FROM
(
SELECT 
      o.order_id
    , p.prod_id
    , p.price               
    , p.cost                
    , to_date(o.order_date) AS order_date
    , year(to_date(o.order_date)) AS year
    , month(to_date(o.order_date)) AS month
FROM products p     
    JOIN order_details od
        ON p.prod_id = od.prod_id
    JOIN orders o
        ON od.order_id = o.order_id
        
) AS T1
GROUP BY order_date, year, month
ORDER BY order_date
) AS T2
;
```
