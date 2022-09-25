#!/bin/bash

# Get contig lengths and calculate windows

SECONDS=0

echo -e "\n~~~   ***   ~~~"
echo -e "    1_wsplit.sh    "
echo -e "~~~         ~~~\n"


# Run python scripts
echo -e "\nBASH: run py";
cd ../py1;
for a in *.py;
do python3 $a;
done;


duration=$SECONDS

echo -e "\n~~~ run complete ~~~\n"
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo -e "\n~~~ *** ~~~\n"

