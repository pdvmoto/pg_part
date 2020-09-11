
/*

delete or drop partitions in PG..
show diff in WAL

*/

\set ECHO none

\i walset.sql 

\i walshow.sql

\! clear

\echo
\echo [ What we will do : delete-from-T, delete from PT, and Drop Partition. ]
\echo
\echo Hit enter to continue...
\echo 

\! read abc

\echo 

\set ECHO all

delete from T where id < 10000 ; 

\set ECHO none

\echo 

\i walshow.sql 

\echo 
\echo Deleted 10K rows, check the size of the generated WAL..
\echo
\echo Hit Enter to continue...

\! read abc

\echo 

\set ECHO all

delete from pt where id < 10000 ; 

\set ECHO none 

\echo 

\i walshow.sql

\echo
\echo Deleted 10K (contents of 1 patition) from PT, check generated WAL...
\echo
\echo Hit enter to continue...

\! read abc


\echo 

drop table pt_2 ; 

\i walshow.sql 

\echo
\echo Dropped 1 partition (with 10K rows in it), check generated WAL...
\echo
\echo Hit Enter to continue...

\! read abc

\! clear 

\echo 
\echo We have seen:
\echo - delete 10K records from Conventional table; ___________  549 K redo.
\echo - delete 10K records from Partitioned table, 1 partition;  549 K redo.
\echo - remove 1 Partition with 10K records; ____________________ 20 K redo..
\echo

\echo Bonus Question (homework!) Will WAL volume increase when dropping Large Partition ?

\! clear 

\echo
\echo
\echo Voila!
\echo
\echo Main Point Made.
\echo
\echo
\echo DROP PARTITION Saves ...
\echo
\echo - Saves Redo-effort (logwriter, archiving, standby...)
\echo
\echo - Saves Time!
\echo
\echo
\echo On Volumes, This Counts.
\echo
\echo
\echo next: back to ppt...
\echo
\echo Hit Enter to Continue...
\echo





