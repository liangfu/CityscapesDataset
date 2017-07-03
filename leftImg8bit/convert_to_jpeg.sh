#!/usr/bin/env bash

for i in `find . | grep .png`;
do
    f=`basename $i`;
    echo $f;
    convert $i /var/www/labelme/Images/cityscapes/${f:0:${#f}-4}.jpg;
done

cp cityscapes.txt /var/www/labelme/annotationCache/DirLists


