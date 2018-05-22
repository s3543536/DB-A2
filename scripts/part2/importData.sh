#!/bin/bash

if [ "$1" == '' ]
then
	echo "Usage: bash importData.sh db_name"
	exit
fi

for d in BUS_DATA_*
do
	mongoimport -d $1 -c business --type tsv --file $d --headerline
done
