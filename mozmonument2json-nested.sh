
#!/bin/bash

## mozmonuent2json-nested.sh (nested by side)
##
## This script will read an export from illustrator file used to created the Mozilla Monument.
## The output is a json that can be used to create an application for finding your name on the monument.
##
## Input File format
## ==side+[n]+(upper|lower)==
##FirstName1+LastName1,FirstName2+LastName2...
##FirstName1+LastName1,FirstName2+LastName2...

inputfile="SFMonumentNamesPerPanelPlainText.txt"
outputfile="mozmonument-nested.json"
spaces="   "

input=`cat $inputfile`

row=1
filerow=0
previousside=0

filelength=`cat $inputfile | wc -l | sed 's/ //g'`

echo $filelength

echo "{\"monument\":{" > $outputfile

for line in $input; do

	if echo "$line" | grep -i '^=='; then
		
		side=`echo $line | sed 's/^==side\+//g' | sed 's/\+lower==//g' | sed 's/\+upper==//g'`
		panel=`echo $line | sed 's/^==side\+[1-4]\+//g' | sed 's/==//g'`
		
		row=1
		
		if [ "$previousside" != "$side" ] || [ "$previousside" == "0" ]; then
		
			if [ "$filerow" != "0" ]; then
				echo "$spaces]," >> $outputfile
			fi

			echo "$spaces\"side$side\": [" >> $outputfile
		else
			echo "$spaces$spaces," >> $outputfile
		fi
		
	else

		echo "side=$side,panel=$panel,row=$row,$line"
		
		nameno=1
		
		# Only print comma if it is not the start of the file, not the first row, and the same side
		if [ "$previousside" == "$side" ] && [ "$filerow" != "1" ] && [ "$row" != "1" ]; then
            echo "$spaces$spaces," >> $outputfile	
        fi
		
		IFS=,
		ary=($line)
		for key in "${!ary[@]}"; do
		
			name=`echo ${ary[$key]} | sed 's/\+/ /g'`
			
			echo "$spaces$spaces{" >> $outputfile
			echo "$spaces$spaces$spaces\"panel\": \"$panel\"," >> $outputfile
			echo "$spaces$spaces$spaces\"row\": \"$row\"," >> $outputfile
			echo "$spaces$spaces$spaces\"number\": \"$nameno\"," >> $outputfile
			echo "$spaces$spaces$spaces\"name\": \"$name\"" >> $outputfile
			echo "$spaces$spaces}" >> $outputfile 
			
			keyplus=$key
			(( keyplus++ ))
			
			if [ "$keyplus" != "${#ary[*]}" ]; then
            	echo "$spaces$spaces," >> $outputfile
        	fi
			
			(( nameno++ ))
			
		done
		  
		(( row++ ))
			
    fi
    
    previousside=$side
    
    (( filerow++ ))
    
done

echo "$spaces]" >> $outputfile
echo "}}" >> $outputfile