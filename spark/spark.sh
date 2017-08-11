#!/bin/bash
SPARK_HOME='/usr/hdp/current/spark2-client/'
CLASS='org.apache.spark.examples.SparkPi'
MASTER='yarn-client'
NUM_EXECUTORS='3'
DRIVER_MEMORY='512m'
EXECUTOR_MEMORY='512m'
EXECUTOR_CORES='1'

spark-submit --class $CLASS \
             --master $MASTER \
             --num-executors $NUM_EXECUTORS \
             --driver-memory $DRIVER_MEMORY \ 
             --executor-memory $EXECUTOR_MEMORY \
             --executor-cores $EXECUTOR_CORES \
             $SPARK_HOME/examples/jars/spark-examples*.jar 10
