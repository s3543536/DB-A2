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


	echo "test query\n1\twith-reboot"
	exec 3>&1 4>&2
	q1r=$( { time ./run-queries.sh query-tables1.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1r
	echo "test query\n2\twith-reboot"
	exec 3>&1 4>&2
	q2r=$( { time ./run-queries.sh query-tables2.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2r
	echo "test query with secondary index\n1\twith-reboot"
	exec 3>&1 4>&2
	q1rs=$( { time ./run-queries.sh query-tables-secidx1.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1rs
	echo "test query with secondary index\n2\twith-reboot"
	exec 3>&1 4>&2
	q2rs=$( { time ./run-queries.sh query-tables-secidx2.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2rs

	echo "test query\n1\tno-reboot"
	exec 3>&1 4>&2
	q1=$( { time ./run-queries.sh query-tables1.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1
	echo "test query\n2\tno-reboot"
	exec 3>&1 4>&2
	q2=$( { time ./run-queries.sh query-tables2.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2
	echo "test query with secondary index\n1\tno-reboot"
	exec 3>&1 4>&2
	q1s=$( { time ./run-queries.sh query-tables-secidx1.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1s
	echo "test query with secondary index\n2\tno-reboot"
	exec 3>&1 4>&2
	q2s=$( { time ./run-queries.sh query-tables-secidx2.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2s

	printf "\n\n\nDirectly after reboot:"
	printf "\n\nQuery 1, no-secondary idx$q1r"
	printf "\n\nQuery 2, no-secondary idx$q2r"
	printf "\n\nQuery 1, secondary idx$q1rs"
	printf "\n\nQuery 2, secondary idx$q2rs"

	printf "\n\n\nNot after reboot:"
	printf "\n\nQuery 1, no-secondary idx$q1r"
	printf "\n\nQuery 2, no-secondary idx$q2r"
	printf "\n\nQuery 1, secondary idx$q1rs"
	printf "\n\nQuery 2, secondary idx$q2rs\n\n"

else
	echo "Usage: bash part1.sh input_csv_file"
fi
