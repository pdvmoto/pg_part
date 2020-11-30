# pg_part

dd: 31 Aug 2020

Partitioning demo for postgreSQL

Aim is to have a demo that is simolar to the "part" repository for oracle..

on demos, the aim is to demo side by side, Oracle and PostgreSQL, and in future others, possibly yugabyte.


notes to run - lsumilar to oracle demo:
pg_demp_part.sql : re-creates the tables T and PT.

pg_demo_part_0.sql : demo the delete + drop and show less redo.

pg_demo_1.sql: local index, how local index loops over partitions.

pg_demo_sum.sql : sum data in 1 partition, and show less IO ?? 
    ( didnt work at pg, need more or bigger partitions.. ? )

pg_demo_part_pk.sql : show how a PK can be both date + sequence? 
    Show size of integer... 


needs more workcheckmore4
