#created by Krysten Harvey

#!/bin/bash

maf_file=$1
annotation_file=$2
result_file=$3
final=$4

#tumor_ids =$(cut -f 2 $annotation_file)

cut -f 2 $annotation_file >> $result_file
declare -a tumor_ids
while read -r; do   tumor_ids+=( "$REPLY" ); done <$result_file

cut -f 16 $maf_file >> tmp.txt

awk '!seen[$0]++' tmp.txt > tmp2.txt

declare -a original_ids
while read -r; do   original_ids+=( "$REPLY" ); done < tmp2.txt


var_count=$(echo ${#tumor_ids[@]})
count_originals=$(echo ${#original_ids[@]})
echo $count_originals
echo $var_count

echo "${tumor_ids[0]}" >> $final
echo "${tumor_ids[1]}" >> $final
echo "${tumor_ids[2]}" >> $final

for (( i=3; i<=$var_count; i++))
do
  for (( j=1; j<=$count_originals; j++))
  do
    if [[ "${original_ids[j]}" =~ .*"${tumor_ids[i]}"* ]]
    then
      # sed -i -e 's/"${tumor_ids[i]}"/"${original_ids[j]}"/g' $annotation_file
       echo "${original_ids[j]}" >> $final
    else
       echo " ">> $final
    fi
  done
done              

awk '!seen[$0]++' $final > tmp3.txt

awk 'NR==FNR{a[++i]=$0; next}{$2=a[++j]}1' OFS="\t" tmp3.txt $annotation_file > final_annotation2.tsv


#awk 'FNR==NR{a[NR]=$1;next}{$2=a[FNR]}1' $final $annotation_file > finaloutput.txt
#paste $annotation_file $final | awk '{$11=$13;$13=""}1' > output

#sed -i 's/original/new/g' file.txt

