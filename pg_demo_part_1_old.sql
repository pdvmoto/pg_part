/*

  pg_demo_part_1:  local indexes also can cause extra work.
  
  and hey: PG doesnt have global indexes (yet)

  ppt needed:
    - show finding 1 or few records via index.
    - show how each local index takes 2-4 reads + 1 read to access table.
    - main message: always limit nr of partitions to search.

*/

\set ECHO none

drop index pt_li_a ;
drop index pt_gi_a ;


\! clear

\echo
\echo
\echo [ What : how an index (Local index) can pinpoint a (small) range ]
\echo
\echo

\set ECHO all

create index pt_gi_a on pt ( active ) ;

analyze pt ;

\set ECHO none


\echo
\echo We have an index on field Active, let us select some...
\echo

\! read abc

\set ECHO all

select id, active 
from PT 
where active = 'Y' 
;

\set ECHO none

\echo
\echo we selected 4 records, we know they are from 4 different partitions...
\echo

\! read abc

explain 
select id, active 
from PT 
where active = 'Y' 
;


\echo
\echo notice that we have to scan 4 indexes,
\echo e.g. we loop over the partitions.
\echo

\! read abc

\! clear

\echo
\echo
\echo Main Point Made:
\echo
\echo
\echo (Local) Indexes _Can_ lead to a lot of looping
\echo
\echo Global Index _might be_  more efficient.
\echo But PostgreSQL doesnt have Global Indexes (yet), luckily (?)
\echo
\echo
\echo Consequences... ?
\echo
\echo IF       you want to avoid "looping" over many partitions...
\echo
\echo THEN     All SQL must limit itself to 1 or few Partitions.
\echo
\echo Hence,   All SQL must have some "Partition Key Limit"
\echo
\echo This Means: Design of Application with Partitioning in mind.
\echo
\echo
\echo ... return to ppt...
\echo



