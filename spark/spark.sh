#!/bin/bash
SPARK_HOME='/usr/hdp/current/spark2-client/'
CLASS='org.apache.spark.examples.SparkPi'
MASTER='yarn'
NUM_EXECUTORS='3'
DRIVER_MEMORY='512m'
EXECUTOR_MEMORY='1024m'
EXECUTOR_CORES='1'
cd $SPARK_HOME
spark-submit --class $CLASS \
             --master $MASTER \
             --num-executors $NUM_EXECUTORS --driver-memory $DRIVER_MEMORY  \
             --executor-memory $EXECUTOR_MEMORY \
             --executor-cores $EXECUTOR_CORES \
             $SPARK_HOME/examples/jars/spark-examples*.jar 10
