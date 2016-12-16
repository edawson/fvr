base_dir=/lustre/scratch110/sanger/ed3/yeastPACB
assemblytics=${base_dir}/Assemblytics/Assemblytics
delta_file=
outpre=
anchorLen=500

for i in `ls | grep "$1" | grep ".delta"`
do
    delta_file=$i
    ${assemblytics} $delta_file `basename ${delta_file} .delta` ${anchorLen} ${base_dir}/Assemblytics
done
