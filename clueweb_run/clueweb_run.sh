#! /bin/bash

if [ $# -eq 0 ]
  then
    echo "Path to clueweb data files missing (doc3-xport-tokenizer-query-???-entity_pairs.tsv.xz)"
    exit 1;
fi

echo "Getting clueweb data from $1"

for f in `find $1/ -maxdepth 1 -name doc3-xport-tokenizer-query-???-entity_pairs.tsv.xz -type f | sort`; do
  qid=${f:(-23):(-20)};
  if [ -f "predictions_classifier_$qid.gz" ]
  then
   echo "Skipping query $qid (already exists)";
  else
   echo "Processing query $qid";
   make clean;
   #xzcat $f | cut -f1-9 > candidates;
   xzcat $f > candidates;
   zcat ${f:0:-7}_query.xml.gz > query.xml
   echo "make response_classifier"; 
   make response_classifier;
   mv response_classifier response_classifier_$qid;
   gzip response_classifier_$qid;
   mv sfeatures sfeatures_$qid;
   gzip sfeatures_$qid;
   mv predictions_classifier predictions_classifier_$qid;
   gzip predictions_classifier_$qid;
   mv candidates candidates_$qid;
   gzip candidates_$qid;
  fi
done;
