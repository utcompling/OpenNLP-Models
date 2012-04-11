
=================================
Spanish POS Tagger OpenNLP Models
=================================

These POS tagging models for Spanish were trained using the CoNLL data [1] and 
OpenNLP 1.5.2 [2]

There are two versions using a different model type (percetron and maxent) and 
there are also versions of the models using the universal Part of Speech
Tags [3].

The models are distributed under the same terms of the CoNLL data, so they 
cannot be used for commercial purposes.


Creating the models
===================

1. Download the Spanish data of the CoNLL 2002 Shared task [1]:
    ./download-conll.sh

2. Convert the data to the format required by OpenNLP:
    ./convert-data.sh

3. Train the models:
    ./train.sh

Evaluation results
==================

The following are the accuracies of the models on the testb dataset:

Original tags
-------------

models/opennlp-es-pos-perceptron-pos-es.model
 0.9606339070165875

models/opennlp-es-pos-maxent-pos-es.model
 0.9629507047737715

Universal tags
--------------

models/opennlp-es-pos-perceptron-pos-universal.model
 0.9611985047893467

models/opennlp-es-pos-maxent-pos-universal.model
 0.9629117669963398


Contact information
===================

Please send your comments and questions to Juan Manuel Caicedo Carvajal:

    http://cavorite.com/labs/nlp/opennlp-models-es/


[1] http://www.lsi.upc.edu/~nlp/tools/nerc/nerc.html
[2] http://incubator.apache.org/opennlp/
[3] http://code.google.com/p/universal-pos-tags/

