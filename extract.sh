#!/bin/bash

file="$1"

mkdir -p $file/

for topic in `rostopic list -b $file.bag` ;
do rostopic echo -p -b $file.bag $topic > $file/${topic//\//_}.csv ;
echo "Iterating"
done
