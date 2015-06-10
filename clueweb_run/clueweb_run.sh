#! /bin/bash

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1;
fi

echo "Getting clueweb data from $1"

for f in `find $1/ -name doc3-xport-tokenizer-query-20?-entity_pairs.tsv.xz -type f`; do
  qid=${f:(-23):(-20)};
  echo "Processing query $qid";
  make clean;
  xzcat $f > candidates;
  zcat ${f:0:-7}_query.xml.gz > query.xml
  make response_classifier;
  mv response_classifier response_classifier_$qid;
  gzip response_classifier_$qid;
  mv sfeatures sfeatures_$qid;
  gzip sfeatures sfeatures_$qid;
done;
