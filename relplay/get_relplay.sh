#! /bin/bash

if [ ! -f relplay ]
 then git clone git@github.com:mschuhma/relplay.git;
fi
cd relplay;
git pull;

./run_relplay.sh
