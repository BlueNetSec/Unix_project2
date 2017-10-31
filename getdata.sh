#!/bin/bash
touch summery
touch plo.dat
echo "# scenarios, max, min, aveg" >> plo.dat
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
	echo "$i, $max, $min, $aveg" >> plo.dat
done

gnuplot << EOF
set grid
set title 'Difference of Data'
set yrange [-1:1]
set xrange [0:10]
set xlabel 'scenarios'
set term png
set output "./graph.png"
plot 'plo.dat' u 1:2 w lp t 'maximum', 'plo.dat' u 1:3 w lp t 'minimum', 'plo.dat' u 1:4 w lp t 'average'
EOF
