## 1. Hive를 사용한 데이터 조작

### 1-1. HDFS Directory -> Hive table



## 2. Impala를 사용한 데이터 조작

### 2-1. Impala에서 사용가능한 쿼리 기능 및 해당 쿼리를 사용하는 예제 
[참고]https://www.cloudera.com/documentation/enterprise/5-9-x/topics/impala_select.html#select

#### 알고 있는 모든 SQL구문은 사용가능



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
