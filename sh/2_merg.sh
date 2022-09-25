#!/bin/bash

# Get variant calls and annotations

SECONDS=0

echo -e "\n~~~   ***   ~~~"
echo -e "   merg.sh    "
echo -e "~~~         ~~~\n"

# Defaults
connie='22'
winnie=0

# Extract flagged variables
while getopts c:w: flag
do
	case "${flag}" in
		c) connie=${OPTARG};;
		w) winnie=${OPTARG};;
	esac
done


# Note targets
echo -e "\nContig selected: "$connie
echo -e "\nWindow selected: "$winnie


# Run python scripts
echo -e "\nBASH: run py";
cd ../py2;
for a in *.py;
do python3 $a --contig=$connie --window=$winnie;
done;


duration=$SECONDS

echo -e "\n~~~ run complete ~~~\n"
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo -e "\n~~~ *** ~~~\n"

