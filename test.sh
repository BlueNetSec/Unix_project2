#!/bin/bash
touch summery
difference=0
max=-1
min=1
summ=0
aveg=0

for i in 1 2 3 4 5 6 7 8 9
do 
	count=0
	while read nob
	do
		#echo "bout$i"
		read datab
		read temp
		while read noh
		do
			#echo "hout$i"			
			read datah
			read temp
			
			if [ $nob == $noh ]; then
				count=$(( count+1 ))
				
				diffrence=$(echo "$datah - $datab" | bc)
				#echo $(bc<<<"$diffrence") >> summery
				#echo "difference is $diffrence" >> summery	 					
				summ=$(echo "$summ + $diffrence" | bc)

				[ $(echo "$diffrence > $max" | bc) -eq 1 ] &&
				max=$(echo "$diffrence" | bc)
				
				[ $(echo "$diffrence < $min" | bc) -eq 1 ] &&
				min=$(echo "$diffrence" | bc)			

				break
			fi
		done < ./data/heu/hout$i
		
	done < ./data/opt/bout$i
	
	aveg=$(echo "scale=10; $summ / $count" | bc)
	echo "the data for scenario$i" >> summery
	echo "The maximum of difference is $max" >> summery
	echo "The minimum difference is $min" >>summery
	echo "The average difference is $aveg" >>summery
done

