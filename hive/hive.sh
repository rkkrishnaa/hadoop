#!/bin/bash
homefolder=$HOME
#a=$(openssl rand -hex 2)
a=$(date +%Y%m%d%H%M%S)
input_dir=hive_input_dir$a
output_dir=hive_output_dir$a
echo "hive input directory"  $input_dir
echo "hive output directory" $output_dir

mkdir -p $HOME/$input_dir
cp hive/* $HOME/$input_dir
hadoop fs -mkdir $input_dir
hadoop fs -put  $HOME/$input_dir/drivers.csv $input_dir
hadoop fs -put  $HOME/$input_dir/timesheet.csv $input_dir
hadoop fs -put  $HOME/$input_dir/truck_event_text_partition.csv $input_dir

hive -e "show databases;"
hive -e "show tables;"

hive -e "create database $USER$a;"

hive -e "use $USER$a;"

hive -e "create table $USER$a.temp_drivers (col_value STRING);"

hive -e "LOAD DATA INPATH '$input_dir/drivers.csv' OVERWRITE INTO TABLE $USER$a.temp_drivers;"

hive -e "select * from $USER$a.temp_drivers LIMIT 100;"

hive -e "CREATE TABLE $USER$a.drivers (driverId INT, name STRING, ssn BIGINT, location STRING, certified STRING, wageplan STRING);"

hive -e "insert overwrite table $USER$a.drivers SELECT regexp_extract(col_value, '^(?:([^,]*),?){1}', 1) driverId, regexp_extract(col_value, '^(?:([^,]*),?){2}', 1) name, regexp_extract(col_value, '^(?:([^,]*),?){3}', 1) ssn, regexp_extract(col_value, '^(?:([^,]*),?){4}', 1) location, regexp_extract(col_value, '^(?:([^,]*),?){5}', 1) certified, regexp_extract(col_value, '^(?:([^,]*),?){6}', 1) wageplan from temp_drivers;"

hive -e "CREATE TABLE $USER$a.temp_timesheet (col_value string);"

hive -e "LOAD DATA INPATH '$input_dir/timesheet.csv' OVERWRITE INTO TABLE $USER$a.temp_timesheet;"

hive -e "CREATE TABLE $USER$a.timesheet (driverId INT, week INT, hours_logged INT , miles_logged INT);"

hive -e "insert overwrite table $USER$a.timesheet  SELECT regexp_extract(col_value, '^(?:([^,]*),?){1}', 1) driverId, regexp_extract(col_value, '^(?:([^,]*),?){2}', 1) week, regexp_extract(col_value, '^(?:([^,]*),?){3}', 1) hours_logged, regexp_extract(col_value, '^(?:([^,]*),?){4}', 1) miles_logged from temp_timesheet;"

hive -e "SELECT driverId, sum(hours_logged), sum(miles_logged) FROM $USER$a.timesheet GROUP BY driverId;"

hive -e "SELECT d.driverId, d.name, t.total_hours, t.total_miles from $USER$a.drivers d JOIN (SELECT driverId, sum(hours_logged)total_hours, sum(miles_logged)total_miles FROM timesheet GROUP BY driverId ) t ON (d.driverId = t.driverId);"

#hive -e "DROP TABLE IF EXISTS $USER$a.timesheet;"

#hive -e "DROP TABLE IF EXISTS $USER$a.drivers;"

#hive -e "DROP TABLE IF EXISTS $USER$a.temp_drivers;"

#hive -e "DROP DATABASE IF EXISTS $USER$a;"

#hadoop fs -rmr -skipTrash /user/$labuser/data
#rm -rf /home/$labuser/data
#rm -rf /home/$labuser/driver_data.zip
