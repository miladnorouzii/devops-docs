#!/bin/bash

min=10
max=200

for i in $(seq 5)
do
       	ran_num=$(( RANDOM % ( $max-$min ) + $min ))
 	echo $ran_num
done

