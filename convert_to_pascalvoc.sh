#!/usr/bin/env bash

mkdir -p Cityscapes/JPEGImages
mkdir -p Cityscapes/SegmentationClass

echo "" > task.txt

files=`find leftImg8bit | grep .png`
for i in $files
do
    f=`basename $i`
    echo "echo $i && convert $i -resize 1024x512 Cityscapes/JPEGImages/${f:0:${#f}-4}.jpg" >> task.txt
done

files=`find gtFine_trainvaltest | grep labelIds`
for i in $files
do
    f=`basename $i`
    echo "echo $i && convert $i -interpolate nearest -filter point -resize 1024x512 Cityscapes/SegmentationClass/${f:0:${#f}-4}.png" >> task.txt
done

parallel -j4 < task.txt

echo "" > train.lst
files=`find leftImg8bit/train | grep .png`
for i in $files
do
    f=`basename $i`
    echo -e "0\tJPEGImages/${f:0:${#f}-4}.png\tSegmentationClass/${f:0:${#f}-16}_gtFine_labelIds.png" >> train.lst
done
echo "" >> train.lst

echo "" > val.lst
files=`find leftImg8bit/val | grep .png`
for i in $files
do
    f=`basename $i`
    echo -e "0\tJPEGImages/${f:0:${#f}-4}.png\tSegmentationClass/${f:0:${#f}-16}_gtFine_labelIds.png" >> val.lst
done
echo "" >> val.lst

echo "" > test.lst
files=`find leftImg8bit/test | grep .png`
for i in $files
do
    f=`basename $i`
    echo -e "0\tJPEGImages/${f:0:${#f}-4}.png\tSegmentationClass/${f:0:${#f}-16}_gtFine_labelIds.png" >> test.lst
done
echo "" >> test.lst

mv *.lst Cityscapes

