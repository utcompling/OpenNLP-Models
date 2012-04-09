#!/bin/bash
# Converts the datasets from the CoNLL Spanish NER task [1] to the format used
# by OpenNLP's POS tag trainer.
#
# It creates two versions of the datasets, one using the existing tags and the
# other with the universal POS tags, as described by:
#
# http://code.google.com/p/universal-pos-tags/
#
# [1] http://www.lsi.upc.edu/~nlp/tools/nerc/nerc.html

mkdir -p data/pos-universal
mkdir -p data/pos-es

# Use the files esp.train and esp.testa as training set.
zcat es-conll/esp.train.gz es-conll/esp.testa.gz | python ner2pos.py - > data/pos-es/es-train.pos
zcat es-conll/esp.testb.gz | python ner2pos.py - > data/pos-es/es-test.pos

zcat es-conll/esp.train.gz es-conll/esp.testa.gz | python ner2pos.py --universal - > data/pos-universal/es-train.pos
zcat es-conll/esp.testb.gz | python ner2pos.py --universal  - > data/pos-universal/es-test.pos

echo "Created files:"
ls -1 data/pos-es/
ls -1 data/pos-universal/

echo "Done"
echo
