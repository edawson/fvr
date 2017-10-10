ref=$1
asm=$2



rm -rf pdfs pngs summary 


mkdir -p pdfs
mkdir -p pngs
mkdir -p summary

## Run MUMmer
./scripts/mummer.sh $ref $asm
## Run assemblytics
./scripts/assemblytics.sh ""
## clean up

mv *.pdf pdfs
mv *.png pngs
mv *.tab summary
mv *.summary summary
mv *.csv summary

rm *.index
rm *.delta
rm *.query.genome
rm *.ref.genome
rm *.gz

for i in `find $ref | grep ".fa$\|.fasta$\|.fas$"`
do
    refFASTA="$i"
    asmFASTA="`basename $i`"
    cat "$ref.$asm.`basename $i `".*.bed > "`basename $ref`.`basename $asm`.`basename $i `".bed
    BED=$ref.$asm.`basename $i `.Assemblytics_structural_variants.bed
    outVCFbase=`basename $BED .bed`
    ## Get Deletions
    ./scripts/make_pvcf_dels.sh $refFASTA $asm/$asmFASTA $BED $outVCFbase.dels.vcf
    ## Get Insertions
    ./scripts/make_pvcf_ins.sh $refFASTA $asm/$asmFASTA $BED $outVCFbase.ins.vcf

done

#mkdir -p beds
#mv *.bed beds
#mv *.txt summary

#mkdir -p vcfs
#mv *.fasta vcfs
#mv *.vcf vcfs
