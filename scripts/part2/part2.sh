#!/bin/bash

if [ "$1" != '' ]
then
	chmod 700 add_header_and_split.sh
	chmod 700 importData.sh
	echo "adding header to data file and splitting records for faster load"
	time ./add_header_and_split.sh "$1"
	echo "created data files (BUS_DATA_?.csv)"

	echo "dropping databases"
	echo "no secondary index"
	mongo assignment2 -eval "db.dropDatabase()"
	echo "secondary index"
	mongo assignment2secidx -eval "db.dropDatabase()"

	echo "adding secondary index to DB"
	mongo assignment2secidx -eval "db.business.createIndex( {BN_NAME: 1})"


	echo "importing files into mongodb"
	echo "no secondary index"
	time ./importData.sh assignment2 
	echo "secondary index"
	time ./importData.sh assignment2secidx 
	echo "DONE!"


	QUERY1="db.business.find( {BN_NAME: 'THE PRODUCER WORKS'} ).pretty()"
	QUERY2='db.business.find( {BN_NAME: { $lte: "R", $gte: "P" } } ).pretty()'

	#time mongo assignment2 -eval $QUERY1
	#time mongo assignment2 -eval $QUERY2
	#time mongo assignment2secidx -eval $QUERY1
	#time mongo assignment2secidx -eval $QUERY2

	echo "test query\n1\twith-reboot"
	exec 3>&1 4>&2
	q1r=$( { time mongo assignment2 -eval "$QUERY1" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1r
	echo "test query\n2\twith-reboot"
	exec 3>&1 4>&2
	q2r=$( { time mongo assignment2 -eval "$QUERY2" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2r
	echo "test query with secondary index\n1\twith-reboot"
	exec 3>&1 4>&2
	q1rs=$( { time mongo assignment2secidx -eval "$QUERY1" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1rs
	echo "test query with secondary index\n2\twith-reboot"
	exec 3>&1 4>&2
	q2rs=$( { time mongo assignment2secidx -eval "$QUERY2" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2rs

	echo "test query\n1\tno-reboot"
	exec 3>&1 4>&2
	q1=$( { time mongo assignment2 -eval "$QUERY1" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1
	echo "test query\n2\twith-reboot"
	exec 3>&1 4>&2
	q2=$( { time mongo assignment2 -eval "$QUERY2" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2
	echo "test query with secondary index\n1\twith-reboot"
	exec 3>&1 4>&2
	q1s=$( { time mongo assignment2secidx -eval "$QUERY1" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q1s
	echo "test query with secondary index\n2\twith-reboot"
	exec 3>&1 4>&2
	q2s=$( { time mongo assignment2secidx -eval "$QUERY2" 1>&3 2>&4; } 2>&1 )  # Captures time only.
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
	echo "Usage: bash part2.sh input_csv_file"
fi



