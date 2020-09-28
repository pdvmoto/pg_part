/*

demo_sum: summation over table or partition.

*/

\set ECHO none

/* tweaks to avoid index-scan  */
alter table t drop constraint  t_pk ;  
analyze t;
analyzt pt; 

\! clear 

\echo
\echo [ What we will do : Aggregate some data on T and PT ]
\echo
\echo Data that would normally be in 1 or few partitions.
\echo
\echo Hit enter to continue...
\echo

\! read abc

\echo 

\set ECHO all

select trunc ( id / 10000 ) as range
     , count (*) as nr_items, sum (amount)    as sumtotal
from T
where id between 10000 and 19999
group by trunc(id / 10000)
order by 1
;

\set ECHO none

\echo
\echo We counted and summed 10k records from a table of 40K.
\echo
\echo Hit enter to see the explain...
\echo

\! read abc

explain select trunc ( id / 10000 ) as range
     , count (*) as nr_items, sum (amount)    as sumtotal
from T
where id between 10000 and 19999
group by trunc(id / 10000)
order by 1
;

\set ECHO none

\echo
\echo
\echo Optimizer decided to "scan" the table, note the cost...
\echo
\echo Hit enter to continue..
\echo

\! read abc


select 'now for the partitions' as next_test ; 

\echo
\set ECHO all


select trunc ( id / 10000 ) as range
     , count (*) as nr_items, sum (amount)    as sumtotal
from PT
where id between 10000 and 19999
group by trunc(id / 10000)
order by 1
;

\set ECHO none

\echo
\echo We now counted 10k records from a Partitioned table of 40K.
\echo
\echo Hit enter to see the explain for this one...
\echo

\! read abc

explain select trunc ( id / 10000 ) as range
     , count (*) as nr_items, sum (amount)    as sumtotal
from PT
where id between 10000 and 19999
group by trunc(id / 10000)
order by 1
;


\echo
\echo Optimizer knows it only needs to scan 1 partitions, check the cost now...
\echo
\echo Notice: no index was touched in the making of these aggregate
\echo
\echo Hit enter to continue...

\! read abc

\! clear

\echo
\echo
\echo Voila!
\echo
\echo Main point made.
\echo
\echo
\echo Partition Elimination.
\echo
\echo Reduce the amount of data to Search..
\echo
\echo
\echo On Large Volumes, with many partitions, This Counts
\echo
\echo
\echo Back to ppt..
\echo

