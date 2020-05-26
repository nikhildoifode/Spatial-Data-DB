Assumptions:
1. For Task 1 query, distance is in 'STATUTE MILE' unit
2. For zips of format XXXXX-XXXX, we only consider first 5 digits as actual zip.
3. For Task 3 we only consider NY zips with shape info availble in uszip
4. Shape files must be in the same folder


Execution Time for Task 2 and Task 3:
Task 2 - nearester.sql
Without Indexes Duration: 	0.090 s (2. without index.jpg)
With Indexes Duration:		0.036 s (2. with index.jpg)

Task 3 - noerzips.sql
Without Indexes Duration: 	8.581 s (3. without index.jpg)
With Indexes Duration: 		3.457 s (3. with index)

How to run Task 5: (5. answer.jpg and 5. num records.jpg)
db2 -tf temp.sql
db2 -td@ -f mergezip.sql

If results has 0 records then probably there is error from memory limit. In that case run following command and then both the commands again.
db2 "update dbm cfg using instance_memory 4194304 immediate"

If still same then increase for other instances too.


Answer 3:
1) Create a temporary table with a column  where you denote if a ZIP has been analyzed or not and a column with whom it has been merged (itself or some other ZIP) 
2) Calculate average population per ZIP. 
3) Go through the ZIPs in increasing order of population and do the following - 
   a) Get the neighbors of the ZIP.
   b) Ignore ZIPs that have been analyzed
   c) The remaining neighboring ZIPs - update saying they've been analyzed and they've been merged with the ZIP that was being iterated in order of increasing population. Also, add the population of this ZIP with the population of the ZIP that was being iterated in order of increasing population. 
  d) Mark the ZIP that was being iterated in order of increasing population as analyzed and merged with itself. 
4) Repeat till all ZIPs have been analyzed
5) Drop the ZIPs that haven't been merged with themselves.