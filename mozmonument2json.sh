#!/bin/bash

## mozmonuent2json.sh
##
## This script will read an export from illustrator file used to created the Mozilla Monument.
## The output is a json that can be used to create an application for finding your name on the monument.
##
## Input File format
## ==side+[n]+(upper|lower)==
##FirstName1+LastName1,FirstName2+LastName2...
##FirstName1+LastName1,FirstName2+LastName2...

inputfile="SFMonumentNamesPerPanelPlainText.txt"
outputfile="mozmonument.json"
spaces="   "

input=`cat $inputfile`

lineno=1
filelineno=0

filelength=`cat $inputfile | wc -l | sed 's/ //g'`

echo $filelength

echo "[" > $outputfile

for line in $input; do

	if echo "$line" | grep -i '^=='; then
	
		side=`echo $line | sed 's/^==side\+//g' | sed 's/\+lower==//g' | sed 's/\+upper==//g'`
		panel=`echo $line | sed 's/^==side\+[1-4]\+//g' | sed 's/==//g'`
		
		lineno=1
		
	else

		echo "side=$side,panel=$panel,line=$lineno,$line"
		
		nameno=1
		
		IFS=,
		ary=($line)
		for key in "${!ary[@]}"; do
		
			name=`echo ${ary[$key]} | sed 's/+/ /g'`
			
			echo "$spaces{" >> $outputfile
  			echo "$spaces$spaces\"side\": \"$side\"," >> $outputfile
  			echo "$spaces$spaces\"panel\": \"$panel\"," >> $outputfile
  			echo "$spaces$spaces\"line\": \"$lineno\"," >> $outputfile
  			echo "$spaces$spaces\"number\": \"$nameno\"," >> $outputfile
  			echo "$spaces$spaces\"name\": \"$name\"" >> $outputfile
			echo "$spaces}" >> $outputfile 
			
			keyplus=$key
			(( keyplus++ ))
			
			if [ "$filelineno" != "$filelength" ] || [ "$keyplus" != "${#ary[*]}" ]; then
            	echo "$spaces," >> $outputfile
        	fi
			
			(( nameno++ ))
			
		done
		  
		(( lineno++ ))
			
    fi
    
    (( filelineno++ ))
    
done

echo "]" >> $outputfile