#! /bin/bash

if [ $# -eq 0 ]
  then
    echo "Path to clueweb data files missing (query-???.tsv.xz)."
    echo "If data non-existing, run clueweb_get_data.sh first"
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
fi

# Setting all up
clwd=clueweb_run;
echo "Getting clueweb data from $1"
mkdir -p $clwd;
echo "Storing results in $clwd";
cd $clwd;
cp ../makefile  .;

# Preparting data to later create human-readable output
echo "Sorting relation keys...";
inputf="all-relkeys-sorted.tsv.gz";
if [ ! -f "$inputf" ]
 then
  xzcat ../$1/query-???.tsv.xz | cut -f4,9,10 | \
  sort -S 90% | uniq | LC_ALL=C sort -S 90% -f -k1,1 | \
  pigz > $inputf;
  echo "Relation key data sorted.";
 else
  echo "Relation keys file already exist $inputf";
fi


# Run relation factory for each query (make response_clueweb_pp13)
for f in $(find "../$1/" -maxdepth 1 -name "*query-???.tsv.xz" -type f | sort); do
  qid=${f:(-10):(-7)};
  if [ -f "response_clueweb_$qid.gz" ]
  then
   echo "Skipping query $qid (already exists)";
  else
   echo "Processing query $qid";
   make clean;
   xzcat $f | cut -f1-9 > candidates;
   zcat ${f:0:-7}_query.xml.gz > query.xml
   #
   #Making default make target
   make response_clueweb_pp13 &&
   mv response_clueweb "response_clueweb_$qid" &&
   gzip "response_clueweb_$qid" &&
   mv response_clueweb_pp13 "response_clueweb_pp13_$qid" &&
   gzip "response_clueweb_pp13_$qid" &&
   #
   # Post processing human readable version
   LC_ALL=C join -1 4 -2 1 -a 1 -i -t $'\t' \
    <(zcat "response_clueweb_$qid.gz" | grep -v NIL | LC_ALL=C sort -f -k4,4) \
    <(zcat $inputf) | \
    cut -f2,3,5,10- | sort -k1,1 -k3,3 -k2,2 | gzip > "response_clueweb_readable_$qid.gz";
  fi
done

# Cleanup
make clean;
