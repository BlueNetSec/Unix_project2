#!/bin/bash
touch summery
#touch plo.dat
#echo "# scenarios, max, min, aveg" >> plo.dat


#for loop for scaning 9 files 
for ((i=1;i<=9;i+=1))  
do

#count and sum are used to find average for each file,reset them to zero when opeoing new files 
	count=0
        sum=0
        currentmax=0
        currentmin=0
#read first line of boutfile, use to compare
	while read boutfile
	do
#read optimal data
		read optimal
#read emptyline
		read emptyline

#same reading methond for houtfile
		while read houtfile
		do			
			read heuristic
			read emptyline

#if the first line of both files matched, then find different,sum, currentmax,currentmin,
			if [ $boutfile == $houtfile ]
                        then
				count=$(( count+1 ))
				
				diffrence=$(echo "$heuristic - $optimal" | bc)
				#echo $(bc<<<"$diffrence") >> summery
				#echo "difference is $diffrence" >> summery	 					
				sum=$(echo "$sum + $diffrence" | bc)

				[ $(echo "$diffrence > $max" | bc) -eq 1 ] &&
				max=$(echo "$diffrence" | bc)
				
				[ $(echo "$diffrence < $min" | bc) -eq 1 ] &&
				min=$(echo "$diffrence" | bc)			

				break
			fi
		done < ./data/heu/hout$i
		
	done < ./data/opt/bout$i
	
	aveg=$(echo "scale=7; $sum / $count" | bc)
	echo "the data for scenario$i" >> summery
	echo "The maximum of difference is $max" >> summery
	echo "The minimum difference is $min" >>summery
	echo "The average difference is $aveg" >>summery
	#echo "$i, $max, $min, $aveg" >> plo.dat
done

#gnuplot << EOF
#set grid
#set title 'Difference of Data'
#set yrange [-1:1]
#set xrange [0:10]
#set xlabel 'scenarios'
#set term png
#set output "./graph.png"
#plot 'plo.dat' u 1:2 w lp t 'maximum', 'plo.dat' u 1:3 w lp t 'minimum', 'plo.dat' u 1:4 w lp t 'average'
#EOF
