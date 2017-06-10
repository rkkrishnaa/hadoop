homefolder=$HOME
a=$(openssl rand -hex 2)
input_dir=input_dir
output_dir=output_dir$a
mkdir $homefolder/units
javac -classpath hadoop-core-1.2.1.jar -d units ProcessUnits.java
jar -cvf units.jar -C units/ .
hadoop fs -mkdir $input_dir
hadoop fs -put sample.txt $input_dir
hadoop jar units.jar hadoop.ProcessUnits $input_dir $output_dir
echo $output_dir
