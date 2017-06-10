homefolder=$HOME
a=$(openssl rand -hex 2)
input_dir=input_dir$a
output_dir=output_dir$a
echo "hadoop input directory"  $input_dir
echo "hadoop output directory" $output_dir
mkdir -p mapred$a/units
javac -classpath hadoop-core-1.2.1.jar -d mapred$a/units ProcessUnits.java
jar -cvf units.jar -C mapred$a/units/ .
hadoop fs -mkdir $input_dir
hadoop fs -put sample.txt $input_dir
hadoop jar units.jar hadoop.ProcessUnits $input_dir $output_dir
