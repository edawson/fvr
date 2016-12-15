for i in chrI chrII chrIII chrIV chrV chrVI chrVII chrVIII chrIX chrX chrXI chrXII chrXIII chrXIV chrXV chrXVI 
do
    samtools faidx $1 $i > $i.seq.fa
done
