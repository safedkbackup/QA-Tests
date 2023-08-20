#!/bin/bash

me=$(basename "$0")

if [[ ! -f "$QA_SCRIPT_SETTINGS" ]]; then
	echo "Unable to process script: error processing script properly ($me:$LINENO)"
	echo -e "Caused by:\n\tSettings file was not found -- aborting script ($me:$LINENO)"
	echo -e "\t'QA_SCRIPT_SETTING' undefined ($me:$LINENO)"
	exit -1
fi

if [ -z $(grep "global=" "$QA_SCRIPT_SETTINGS") ] ||
	[ -z $(grep "mode=" "$QA_SCRIPT_SETTINGS") ] ||
	[ -z $(grep "lang=" "$QA_SCRIPT_SETTINGS") ]; then
	echo "Invalid settings file -- abort";
	exit -1
fi

function read_option {
	while IFS= read -r line; do echo $line; done < $1
	if [ ! -z "$line" ]; then
		echo $line
	fi
}

function append_option {

	if [ -z "$1" ] || [ -z "$2" ]; then
		echo "missing parameter"
		exit -1
	fi

	local output_file=$3

	if [ -z "$3" ]; then
		output_file="appended.txt"
	fi

	if [[ -f "$2" ]]; then
		(echo $1) > $output_file
	elif [[ -f "$1" ]]; then
		cp $1 $output_file
		echo $2 >> $output_file
	else
		echo "no input file supplied."
	fi
}

function options {
	echo "Unrecognized command."
	echo -e "\nUsage:"
	echo -e " append <line> <file>"
	echo -e "   Appends the given line to the end of the file."
	echo -e " read <file>"
	echo -e "   Prints the content of the given file."
}

case $1 in

	read)
		read_option $2
	;;

	append)
		append_option "$2" "$3" "$4"
	;;

	*)
		options $1
		;;

esac

