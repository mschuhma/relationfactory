#! /bin/bash

#
# 1)Downloads
#    Clueweb data (laura format) from https://github.com/mschuhma/clueweb_data
#    Cluetator sources from https://github.com/mschuhma/cluetator/tree/relation_factory
#
# 2)Builds Cluetator maven project
#
# 3)Process clueweb data into Relation Factory format (using de.dwslab.cluetator.textgraph.RelationFactoryWriter)
#
# NOTE: You need a local DBpedia Virtuoso Server Running!
# Change configuration (if needed) by creating cluetator/src/main/resources/conf/cluetator.properties file
#


C=cluetator/;
Ctar=cluetator.jar;
echo "Getting/updateing latest cluetator"
if [ ! -d "$C" ]
 then
   git clone git@github.com:mschuhma/cluetator.git;
   cd $C;
 else
  cd $C;
  git pull;
fi
git checkout relation_factory;
mvn -q package -Dmaven.test.skip=true | grep -v "already added, skipping" | grep -v "INFO" | grep -Pv "Generating.*html";
cp target/cluetator-*-jar-with-dependencies.jar $Ctar;
if [ ! -f "src/main/resources/conf/cluetator.properties" ]
 then
  echo "Config file cluetator/src/main/resources/conf/cluetator.properties is missing!";
  exit 1;
fi
cd ..;

echo "Getting/updating clueweb12 data";
D=clueweb_data/;
if [ ! -d "$D" ]
 then
  git clone git@github.com:mschuhma/clueweb_data.git
  cd $D;
 else
  cd $D;
  git pull;
fi
git checkout master;
cd ..;

echo "Processing clueweb12 with Cluetator into Relation Factory format";
cd $C;
java -Xmx32g -cp $Ctar de.dwslab.cluetator.textgraph.RelationFactoryWriter "../$D/clue12/100queries_cluetator";
mv query-*.tsv.xz ../$D/;
mv query-*.tsv.debug.xz ../$D/;
mv query-*.xml.gz ../$D/;
echo "Done";
