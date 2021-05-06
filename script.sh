#!/bin/bash

git clone https://github.com/krshrimali/auto_coding.git && cd auto_coding
pip install -r requirements.txt # transformers, pytorch etc.

declare -A hashmap
hashmap["pytorch_examples"]="https://github.com/pytorch/examples.git"
hashmap["tensorflow_examples"]="https://github.com/tensorflow/examples.git"
hashmap["algorithm_examples"]="https://github.com/TheAlgorithms/Python.git"
hashmap["scikitlearn_examples"]="https://github.com/scikit-learn/scikit-learn/tree/main/examples.git"
hashmap["Computer_vision"]="https://github.com/PacktPublishing/Computer-Vision-with-Python-3.git"
hashmap["NVIDIA_DeepLearning_examples"]="https://github.com/NVIDIA/DeepLearningExamples.git"
hashmap["Seaborn_examples"]="https://github.com/mwaskom/seaborn/tree/master/examples.git"
hashmap["Matplotlib_examples"]="https://github.com/matplotlib/matplotlib/tree/master/examples.git"


cd dataset/

echo "Cloning repositories NOW"

for key in ${!hashmap[@]}; 
	do
		echo $key, ${hashmap[$key]};
		git clone ${hashmap[$key]} $key
		echo "Done cloning repo: $key"
	done

echo hashmap has ${#hashmap[@]} elements

echo "Starting pre-processing data..."
sed -i "s/'examples'/'pytorch_examples', 'tensorflow_examples', 'algorithm_examples', 'scikitlearn_examples', 'Computer_vision', 'NVIDIA_DeepLearning_examples', 'Seaborn_examples', 'Matplotlib_examples'/g" convert.py && python3 convert.py --segment_len 256 --stride 10 --dev_size 0.1
echo "Finished pre-processing data"

cd ../ && python3 train.py --model_select distilgpt2
