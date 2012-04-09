#!/bin/bash
#
# Downloads the Spanish data of the CoNLL 2002 Shared task:
#   http://www.lsi.upc.edu/~nlp/tools/nerc/nerc.html
#


destdir="es-conll"

if [ -d $destdir ]; then
    echo "Destination directory already exists: $destdir."
    exit 1
fi

mkdir $destdir;
cd $destdir;
wget http://www.lsi.upc.edu/~nlp/tools/nerc/esp.train.gz
wget http://www.lsi.upc.edu/~nlp/tools/nerc/esp.testa.gz
wget http://www.lsi.upc.edu/~nlp/tools/nerc/esp.testb.gz
