

-- initiate lsn_start to measure wal volume 
-- call this before wal_show to prevent error on first call

select pg_current_wal_lsn () as lsn_start \gset   
