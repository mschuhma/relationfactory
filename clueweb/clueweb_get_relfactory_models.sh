#! /bin/bash

reldir=relationfactory_models;
link="http://web.informatik.uni-mannheim.de/mschuhma/relfactory/relationfactory_models.tar.gz";

cd ..;
if [ ! -d $reldir ]
 then
  echo "Downloading relationfactory models";
  wget $link;
  tar xfa relationfactory_models.tar*;
  rm relationfactory_models.tar*;
fi
