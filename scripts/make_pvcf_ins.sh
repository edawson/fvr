refFASTA=$1
asmFASTA=$2
bedFile=$3

fasthack=

vcfHeader="#CHROM	POS	ID	REF	ALT	FILTER	QUAL	INFO"
outVCF=$4

## Format for BED file
## CHROM    POS_START(REF)  POS_END(REF)    ID  LENGTH(REF) STRAND  TYPE    LEN(ref)    LEN(asm) IRREL  IRREL
cat vcf_header.txt >> ${outVCF}

tmpBed=tmp.${bedFile}.tmp
cat $bedFile | cut -f 2,9 -d "	"  | cut -f 1,2,3,4 -d ":" > $tmpBed
outFA=`basename ${outVCF} .vcf `.insertions.fasta
rm $tmpBed
   
./bedtools2/bin/bedtools getfasta -fi $asmFasta -bed $bedFile -name -fo ${outFA}

#for line in `cat ${bedFile}`
while IFS='' read -r line || [[ -n "$line" ]]; do
   IFS='	' read -r -a array <<< "$line" 
   rseq="A"
   ## We need to use BEDTools to get our variant sequence,
   ## write it to a fasta file with the other sequences,
   ## and record the sequence name in the ALT column
   altseq="<${array[3]}>"
   infoCol="SVTYPE=${array[6]};SVLEN=${array[4]}"
   echo -e "${array[0]}	${array[1]}	${array[3]}	${rseq}\t${altseq}	"PASS"	99	${infoCol}	" >> ${outVCF}
done < "${bedFile}"
