#!/bin/bash

if [ "$1" != '' ]
then
	echo "test query\n2\twith-reboot"
	exec 3>&1 4>&2
	q2r=$( { time ./run-queries.sh query-tables2.sql 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2r

else
	echo "Usage: bash part1.sh input_csv_file"
fi
