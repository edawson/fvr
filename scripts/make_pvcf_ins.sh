refFasta=$1
asmFasta=$2
bedFile=$3

fasthack=

vcfHeader="#CHROM	POS	ID	REF	ALT	FILTER	QUAL	INFO"
outVCF=$4

## Format for BED file
## CHROM    POS_START(REF)  POS_END(REF)    ID  LENGTH(REF) STRAND  TYPE    LEN(ref)    LEN(asm) IRREL  IRREL
cat ./essential/vcf_header.txt >> ${outVCF}

tmpBed="tmp.${bedFile}"
grep "Insertion" $bedFile > $tmpBed
./scripts/rearrange_bedfile.sh $tmpBed > re.$bedFile
outFA=`basename ${outVCF} .vcf `.insertions.fasta
   
bedFile=re.${bedFile}
chrBASE=`basename ${outVCF} .vcf `
sed -i "s/Assem/${chrBASE}_Assem/g" $bedFile
./bedtools2/bin/bedtools getfasta -name -fi ${asmFasta} -bed $bedFile -fo /dev/stdout | grep -v "skipping" > ${outFA}
rm $tmpBed
#for line in `cat ${bedFile}`
while IFS='' read -r line || [[ -n "$line" ]]; do
   IFS='	' read -r -a array <<< "$line" 
   rseq="N"
   ## We need to use BEDTools to get our variant sequence,
   ## write it to a fasta file with the other sequences,
   ## and record the sequence name in the ALT column
   altseq="<${array[3]}>"
   infoCol="SVTYPE=INS;SVLEN=`expr ${array[2]} - ${array[1]}`"
   #infoCol="SVTYPE=${array[6]};SVLEN=${array[4]}"
   echo -e "${array[0]}	`expr ${array[1]} + 1`	${array[3]}	${rseq}\t${altseq}	"PASS"	99	${infoCol}	" >> ${outVCF}
done < "${bedFile}"

rm $bedFile
