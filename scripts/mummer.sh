nucmer=/lustre/scratch110/sanger/ed3/yeastPACB/MUMmer3.23/nucmer
nucmerArgs="-maxmatch -l 100 -c 100"
ref=$1
query=$2

for i in `ls ${ref} | grep ".fa$" | sort`
do
    ${nucmer} ${nucmerArgs} ${ref}/${i} ${query}/${i} -prefix `basename $ref`.`basename $query`.${i}
done
