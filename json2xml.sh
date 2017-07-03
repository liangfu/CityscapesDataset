#!/usr/bin/env bash

echo "" > task.txt

files=`find gtFine_trainvaltest | grep json`
for i in $files
do
    echo "echo $i && python json2xml.py $i" >> task.txt
done

parallel -j4 < task.txt

cp `find gtFine_trainvaltest | grep xml` /var/www/labelme/Annotations/cityscapes/


