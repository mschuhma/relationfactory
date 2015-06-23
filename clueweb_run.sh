#! /bin/bash

if [ $# -eq 0 ]
  then
    echo "Path to clueweb data files missing (query-???.tsv.xz)."
    echo "If data non-existing, run get_clueweb_data.sh first"
    exit 1;
fi

# Checking variables
if [ ! $TAC_MODELS ]
 then
  echo "JAVA_HOME $JAVA_HOME";
  echo "TAC_ROOT $TAC_ROOT";
  echo "TAC_MODELS $TAC_MODELS";
  echo "Variables missing, exiting now";
  exit 1;
fi;

clwd=clueweb_run;
echo "Getting clueweb data from $1"
echo "Storing results in $clwd";

for f in $(find $1/ -maxdepth 1 -name "*query-201.tsv.xz" -type f | sort); do
#for f in $(find $1/ -maxdepth 1 -name "*query-???.tsv.xz" -type f | sort); do
  cd $clwd;
  qid=${f:(-10):(-7)};
  if [ -f "response_*$qid.gz" ]
  then
   echo "Skipping query $qid (already exists)";
  else
   echo "Processing query $qid";
   xzcat ../$f | cut -f1-9 > candidates;
   #xzcat $f > candidates;
   zcat ../${f:0:-7}_query.xml.gz > query.xml
   #Making default make target
   rm -f "response_*";
   cd ..;
   ./bin/run.sh config/clueweb.config;
   cd $clwd;
   for resf in $(find . -maxdepth 1 -name "response_*" -type f | sort); do
    mv $resf $resf_$qid;
    echo "mv $resf $resf_$qid";
    gzip $resf_$qid;
    echo "gzip $resf_$qid";
   done;
  fi
  cd ..;
done;
