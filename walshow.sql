

-- show the wal bytes since last call
-- also needed: walset.sql (set lsn_start without echo)

--select pg_wal_lsn_diff (
--  pg_current_wal_lsn () ,  :'lsn_start' )  as wal_bytes ; 

--select pg_size_pretty ( 
--    pg_wal_lsn_diff (
--        pg_current_wal_lsn () ,  :'lsn_start' ) ) as wal_bytes  ;


with wb as 
( select pg_wal_lsn_diff (
        pg_current_wal_lsn () ,  :'lsn_start' 
            )  as wal_bytes
) 
select 
  wb.wal_bytes 
, pg_size_pretty ( wb.wal_bytes )   wb_pretty
from wb 
;

-- set for next call
-- select pg_current_wal_lsn () as lsn_start \gset   

\i walset.sql
