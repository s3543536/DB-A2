#!/bin/bash

if [ "$1" != '' ]
then
	chmod 700 split-tables.sh
	chmod 700 run-queries.sh
	echo "reformatting and splitting CSV data"
	time ./split-tables.sh "$1"

	echo "creating tables and loading data into DB without secondary index"
	time ./run-queries.sh derby-script.sql
	echo "creating tables and loading data into DB with secondary index"
	time ./run-queries.sh derby-script-secidx.sql

	echo "reboot DBs"
	#TODO

	echo "test query\n1\twith-reboot"
	time ./run-queries.sh query-tables1.sql
	echo "test query\n2\twith-reboot"
	time ./run-queries.sh query-tables2.sql
	echo "test query with secondary index\n1\twith-reboot"
	time ./run-queries.sh query-tables-secidx1.sql
	echo "test query with secondary index\n2\twith-reboot"
	time ./run-queries.sh query-tables-secidx2.sql

	echo "test query\n1\tno-reboot"
	time ./run-queries.sh query-tables1.sql
	echo "test query\n2\tno-reboot"
	time ./run-queries.sh query-tables2.sql
	echo "test query with secondary index\n1\tno-reboot"
	time ./run-queries.sh query-tables-secidx1.sql
	echo "test query with secondary index\n2\tno-reboot"
	time ./run-queries.sh query-tables-secidx2.sql

else
	echo "Usage: bash part1.sh input_csv_file"
fi
