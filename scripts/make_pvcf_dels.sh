refFASTA=$1
asmFASTA=$2
bedFile=$3

fasthack=

outVCF=$4

## Format for BED file
## CHROM    POS_START(REF)  POS_END(REF)    ID  LENGTH(REF) STRAND  TYPE    LEN(ref)    LEN(asm) IRREL  IRREL
cat ./essential/vcf_header.txt >> ${outVCF}

tmpBED=tmp.x.tmp.${bedFile}.bed
grep "Deletion" ${bedFile} > $tmpBED

#for line in `cat ${bedFile}`
while IFS='' read -r line || [[ -n "$line" ]]; do
   IFS='	' read -r -a array <<< "$line" 
   rseq="A"
   altseq="<DEL>"
   infoCol="SVTYPE=DEL;SVLEN=${array[4]}"
   echo -e "${array[0]}	`expr ${array[1]} + 1`	${array[3]}	${rseq}\t${altseq}	"PASS"	99	${infoCol}	" >> ${outVCF}
done < "${tmpBED}"

rm $tmpBED
