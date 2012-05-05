#!/bin/bash
for f in `ls *`
do
    echo $f
    cat $f | grep $1
done
