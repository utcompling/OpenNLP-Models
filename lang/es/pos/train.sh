#!/bin/bash
#
# Train the OpenNLP POS models for Spanish.
#
# This script requires that the training and testing data already exists in 
# the following directories:
#
#   data/pos-es (for the original tagset included in the ConLL data)
#   data/pos-universal (for the universal POS tags)
#


if [ -z $OPENNLP_HOME ]; then
    echo "OPENNLP_HOME environment variable is not defined."
    exit 1
fi

data_dirs="pos-es pos-universal"

for subd in $data_dirs; do
    d="data/$subd"
    if [ ! -f $d/es-train.pos ] || [ ! -f $d/es-test.pos ]; then
        echo "Directory does not contain training and testing data: $d"
    fi
done

outdir="models"
if [ ! -d $outdir ]; then
    mkdir $outdir;
fi;

# Number of iterations
iters=200

opennlp=$OPENNLP_HOME/bin/opennlp

# Temporary log file for the evaluation output
log_eval=`mktemp --tmpdir opennlp_es_train.XXXXXX`

model_types="perceptron maxent"

for data_dir in $data_dirs; do
    train_path=data/$data_dir/es-train.pos
    test_path=data/$data_dir/es-test.pos

    for model_type in $model_types; do
        out_model="$outdir/opennlp-es-${model_type}-${data_dir}.bin"

        echo "Training model: $out_model"
        $opennlp POSTaggerTrainer -type $model_type -iterations $iters \
            -lang es -encoding utf-8 -data $train_path -model $out_model

        eval_results=`$opennlp POSTaggerEvaluator -encoding utf-8 \
            -data $test_path -model $out_model`

        eval_accuracy=`echo -e $eval_results | grep 'Accuracy:' | cut -d ':' -f 2`

        echo "Evaluating model"
        echo -e $eval_results
        echo
        echo "------------"
        echo

        echo -e "$out_model\n$eval_accuracy\n" >> $log_eval
    done
done

# Print results and delete temporary file
echo
echo "Evaluation results"
echo 
cat $log_eval
rm $log_eval
echo
