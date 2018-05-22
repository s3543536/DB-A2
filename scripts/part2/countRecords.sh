#!/bin/bash

if [ "$1" != '' ]
then
	QUERY1="db.business.find( {BN_NAME: 'THE PRODUCER WORKS'} ).count()"
	QUERY2='db.business.find( {BN_NAME: { $lt: "R", $gt: "P" } } ).count()'

	#time mongo assignment2 -eval $QUERY1
	#time mongo assignment2 -eval $QUERY2
	#time mongo assignment2secidx -eval $QUERY1
	#time mongo assignment2secidx -eval $QUERY2
	echo "test query\n2\twith-reboot"
	exec 3>&1 4>&2
	q2r=$( { time mongo assignment2 -eval "$QUERY2" 1>&3 2>&4; } 2>&1 )  # Captures time only.
	exec 3>&- 4>&-	
	echo $q2r
