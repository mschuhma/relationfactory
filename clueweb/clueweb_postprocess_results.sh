#! /bin/bash

#cdir=clueweb_run;
cdir=$1;
keyfile=all-relkeys-sorted.tsv.gz;

if [ ! -d $cdir ]
 then
  echo "Cluweb run directory $clwd does not exist. Run clueweb_run.sh first";
  exit 1;
fi
echo "Post-processing all response_clueweb_???.gz files in $cdir";
cd $cdir;

# Post processing human readable version
for f in $(find . -maxdepth 1 -type f -name "response_clueweb_???.gz") ; do
  qid=${f:(-6):(-3)};
  fout=response_clueweb_web_$qid.gz;
  if [ -f $fout ]
  then
   echo "$fout skipped (already exists)";
  else
   qid=${f:(-6):(-3)};
   LC_ALL=C join -1 4 -2 1 -a 1 -i -t $'\t' \
     <(zcat $f | grep -v NIL | LC_ALL=C sort -f -k4,4) \
     <(zcat $keyfile) | \
     cut -f1,3,10- | sort -k1,1 -k2,2 -k3,3nr | \
     gzip > $fout;
   echo "$fout finished";
  fi
done;
echo "Done";
