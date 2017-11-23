#!/bin/bash
a=$(date +%Y%m%d%H%M%S)
input_dir=mapred_input_dir$a
output_dir=mapred_output_dir$a

hdfs dfs -mkdir $input_dir
hdfs dfs -ls 
hdfs dfs -put /var/log/boot.log $input_dir
hdfs dfs -cat $input_dir/boot.log
yarn jar /opt/cloudera/parcels/CDH/jars/hadoop-mapreduce-examples-2.6.0-cdh5.12.1.jar wordcount $input_dir $output_dir
hdfs dfs -ls $output_dir
hdfs dfs -cat $output_dir/part-r-00000
