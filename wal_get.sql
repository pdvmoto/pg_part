

/*

wal_get.sql: report was since last "set", and re-set.

notes: 

0. initiate by creating table and inserting first records : wal_set.sql
1. this will delete + initiate with current wal,
2. the overhead of inserting 2 lines seems to be 112 bytes

*/

insert into keep_wal_stats
select 2, pg_current_wal_lsn()  ;

select w1.lsn, w2.lsn,   
pg_wal_lsn_diff( w2.lsn, w1.lsn ) as diff_wal_bytes
from keep_wal_stats as w1
, keep_wal_stats as w2
where w1.id = 1
and w2.id = 2 
;

delete from keep_wal_stats ;

insert into keep_wal_stats
select 1, pg_current_wal_lsn()  ;

select 'LSN re-stored for measurement.' ; 

