source ./config.sh

ref=$1
asm=$2






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

for i in `find $ref | grep ".fa$\|.fasta$\|.fas$"`
do
    refFASTA="$i"
    asmFASTA="$asm/`basename $i`"
    cat "$ref.$asm.`basename $i `".*.bed > "$ref.$asm.`basename $i `".bed
    BED="$ref.$asm.`basename $i `".bed
    outVCFbase=`basename $BED .bed`
    ## Get Deletions
    ./scripts/make_pvcf_dels.sh $refFASTA $asmFASTA $BED $outVCFbase.dels.vcf
    ## Get Insertions
    ./scripts/make_pvcf_ins.sh $refFASTA $asmFASTA $BED $outVCFbase.ins.vcf

done

