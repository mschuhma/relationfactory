#! /bin/bash
#
# Combines output from relfactory response_classifier with input text into human-readable format
#

echo "Running make_relfac_output_humanreadable.sh";
if [ $# -eq 0 ]
  then
    echo "Path to clueweb data files missing (query-???.tsv.xz)"
    exit 1;
fi

echo "Getting clueweb data from $1"
inputf="query-ALLE.tmp";
xzcat $1/doc3-xport-tokenizer-query-???-entity_pairs.tsv.xz | cut -f4,9,10 | \
sort -S 90% | uniq | LC_ALL=C sort -S 90% -f -k1,1 > $inputf;
echo "Input data sorted";

for f in `find . -maxdepth 1 -type f -name "response_classifier_???.gz"`; do
  LC_ALL=C join -1 4 -2 1 -a 1 -i -t $'\t' \
  <(zcat $f | grep -v NIL | LC_ALL=C sort -f -k4,4) $inputf \
  | cut -f2,3,5,10- | sort -k1,1 -k3,3 -k2,2 | gzip > ${f:0:-3}_readable.gz;
done;
echo "Done";
rm $inputf;
