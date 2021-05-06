#!/bin/bash

git clone https://github.com/Aasthaengg/auto_coding.git && cd auto_coding
pip install -r requirements.txt # transformers, pytorch etc.

declare -A hashmap
hashmap["pytorch_examples"]="https://github.com/pytorch/examples.git"
hashmap["tensorflow_examples"]="https://github.com/tensorflow/examples.git"
hashmap["algorithm_examples"]="https://github.com/TheAlgorithms/Python.git"
hashmap["Computer_vision"]="https://github.com/PacktPublishing/Computer-Vision-with-Python-3.git"
hashmap["NVIDIA_DeepLearning_examples"]="https://github.com/NVIDIA/DeepLearningExamples.git"

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
sed -i "s/'examples'/'pytorch_examples', 'tensorflow_examples', 'algorithm_examples', 'Computer_vision', 'NVIDIA_DeepLearning_examples'/g" convert.py && python3 convert.py --segment_len 256 --stride 10 --dev_size 0.1
sed -i 's/"<examples>"/"<pytorch_examples>", "<tensorflow_examples>", "<algorithm_examples>", "<Computer_vision>', "<NVIDIA_DeepLearning_examples'/g>" ../train.py
echo "Finished pre-processing data"

cd ../ && python3 train.py --model_select distilgpt2
