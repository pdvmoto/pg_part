

/* 
pg_demo_part.sql:  attempt to demo partitioning in PG
note: script should be near-identical to demo_part.sql for oracle


additional todo-items
 - a data-browser needed!
 - 

*/

\set ECHO none

drop table t ; 
drop table pt ;

\! clear 

\set echo none

\echo 
\echo ' ____ original demo starts here... ____'
\echo 

\set ECHO all

create table pt 
( id                bigint     
, active            char ( 1 )        -- Y/N, show small set of Active.
, amount            numeric ( 10,2 )  -- supposedly some amount of money.
, dt                timestamp         -- some date, case we want history stuff
, payload           varchar ( 200 )   -- some text 
, filler            varchar ( 750 )   -- some data to create 1K recordsize
)
partition by range ( id ) ;

alter table pt add constraint pt_pk primary key ( id ) ;

\set ECHO none

\echo 
\echo 'Check the partitioned table. '
\echo 
\echo 'In this PG, (year 2020, version 12.x), we need to add the partitions...'
\echo 

\! read abc

\set ECHO all

create table pt_1 partition of pt for values from (     0 ) to ( 10000 ) ;

create table pt_2 partition of pt for values from ( 10000 ) to ( 20000 ) ;

create table pt_3 partition of pt for values from ( 20000 ) to ( 30000 ) ;

create table pt_4 partition of pt for values from ( 30000 ) to ( 40000 ) ;

\set ECHO none

\echo 
\echo 'Partitioned table PT now ready...'
\echo 

\! read abc 

\! clear 

\echo 
\echo 'Create similar table T, conventional'
\echo 

\set ECHO all

create table t
( id                bigint     
, active            char ( 1 )        -- Y/N, show small set of Active.
, amount            numeric ( 10,2 )  -- supposedly some amount of money.
, dt                timestamp         -- some date, case we want history stuff
, payload           varchar ( 200 )   -- some text 
, filler            varchar ( 750 )   -- some data to create 1K recordsize
);

alter table t add constraint t_pk primary key ( id ) ;

\set ECHO none

\echo .
\echo 'Check, we also created a similar, conventional table...'
\echo .

\! read abc

\! clear 

\echo  
\echo 'Inserting 40K rows in each...'
\echo  

\set ECHO all

\echo

insert into t
select  
  rownum                                                      as id
, case mod ( rownum+1, 10000 )  when 0 then 'Y' else 'N' end  as active
, mod ( rownum, 10000 ) / 100                                 as amount
, ( current_date - rownum )                                   as dt
-- ,  rpad ( fnNumberToWords ( rownum ), 198)                    as payload
,  rpad ( 'abc' , 198)                                        as payload
,  rpad ( '[ ', 740 ) || ']'                                  as  filler 
from ( select generate_series ( 0, 39999 ) as rownum ) as src ; 

\echo 

insert into pt select * from t ;

\echo 

-- to compare, add same indexes as on oracle tables..
create index pt_li_pay on pt ( payload, filler, amount) ;
create index  t_i_pay  on  t ( payload, filler, amount) ;


analyze t;
analyze pt;

\set ECHO none

\echo 
\echo 'We now have a PT and T, each with 40K rows and 4 records active=Y...' ;
\echo 

\! read abc

\set ECHO all

\! clear 

--
-- show the partitions...
--

\set ECHO all

SELECT
    nmsp_parent.nspname AS parent_schema,
    parent.relname      AS parent,
    parent.relkind      as p_relkind,
    nmsp_child.nspname  AS child_schema,
    child.relname       AS child,
    child.relkind       as ch_relkind
FROM pg_inherits
    JOIN pg_class parent            ON pg_inherits.inhparent = parent.oid
    JOIN pg_class child             ON pg_inherits.inhrelid   = child.oid
    JOIN pg_namespace nmsp_parent   ON nmsp_parent.oid  = parent.relnamespace
    JOIN pg_namespace nmsp_child    ON nmsp_child.oid   = child.relnamespace
WHERE parent.relname='pt'
;

\set ECHO none

\echo  
\echo 'Check the partitions, relkind=p ... hm..??'
\echo  

\! read abc

\echo
\echo 'Demo Ready... :'
\echo ' '
\echo 'We have two tables'
\echo ' T   conventional, 40K records in 1 table'
\echo ' PT  partitioned, 10K records in each partition.  '
\echo ' '

