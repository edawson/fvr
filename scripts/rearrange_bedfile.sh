cat $1 | cut -f 4,10 | sed "s/:\|-/ /g" | cut -f 1,2,3,4 | awk '{print $2, $3, $4, $1}' | sed 's/ /	/g'
