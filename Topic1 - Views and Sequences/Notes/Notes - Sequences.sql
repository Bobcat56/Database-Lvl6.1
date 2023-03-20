/*				--  Sequences --
https://learn.microsoft.com/en-us/sql/t-sql/statements/create-sequence-transact-sql?view=sql-server-ver16

CREATE SEQUENCE [schema_name . ] sequence_name  
    [ AS [ built_in_integer_type | user-defined_integer_type ] ]  
    [ START WITH <constant> ]  
    [ INCREMENT BY <constant> ]  
    [ { MINVALUE [ <constant> ] } | { NO MINVALUE } ]  
    [ { MAXVALUE [ <constant> ] } | { NO MAXVALUE } ]  
    [ CYCLE | { NO CYCLE } ]  
    [ { CACHE [ <constant> ] } | { NO CACHE } ]  
    [ ; ] 
*/

/*Question 1: Create a sequence Topic1.seq_1000 that starts from 1 and increments by 1 until it reaches 1000, 
			  then it starts again*/
CREATE SEQUENCE Topic1.seq_1000
START WITH 1
INCREMENT BY 1
MINVALUE 1
MAXVALUE 1000
CYCLE;

/*Question 2: Get the first value from the sequence*/
SELECT NEXT VALUE FOR Topic1.seq_1000 AS [Sequence Number];

/*Question 3: Change the previous sequence so that it increments by 5, and caches the first 20 numbers*/
ALTER SEQUENCE Topic1.seq_1000
INCREMENT BY 5
CACHE 20;

/*Question 4: test the sequence again*/
SELECT NEXT VALUE FOR Topic1.seq_1000 AS [Sequence Number];

/*Question 5: Create a sequence that starts from 10, decrements by 2 and stops at 0. The sequence 
		      shouldn't restart after completion*/
CREATE SEQUENCE Topic1.neg_seq
START WITH 10
INCREMENT BY -2
MINVALUE 0
MAXVALUE 10
NO CYCLE;

/*Question 4: test the previous sequence*/
SELECT NEXT VALUE FOR Topic1.neg_seq AS [Sequence Number];


/*Question 5: Get infromation about all the sequences created*/
SELECT *
FROM sys.sequences;

/*Question 6: Drop the sequences created*/
DROP SEQUENCE Topic1.seq_1000;
DROP SEQUENCE Topic1.neg_seq;
