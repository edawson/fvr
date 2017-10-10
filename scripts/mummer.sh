nucmer=/lustre/scratch115/teams/durbin/users/ed3/yeastPACB/MUMmer3.23/nucmer
nucmerArgs="-maxmatch -c 500"
ref=$1
query=$2

for i in `ls ${ref} | grep ".fa$" | sort`
do
    ${nucmer} ${nucmerArgs} ${ref}/${i} ${query}/${i} -prefix `basename $ref`.`basename $query`.${i}
done
