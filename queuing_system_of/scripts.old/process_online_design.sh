#!/bin/sh

echo "This script process a given xml file with a given java tool."
echo "The result is moved to a conventional results directory."
echo ""

if [ -z "$2" ]
then
	echo "this script needs a file name and a tool name in parameters"
	exit -1
fi

# set usefull variables:
filename=$1 # full path file name
tool=$2 # extract the tool name to use for design
file_id=`basename $filename .xml`

# avoid concurent access collisions:
mv $filename results
    
# we will work with the file stored in the results directory:
filename=results/`basename $filename`

# launch the appropriate design tool:
ssh wwwrun@164.15.232.116 "java -jar $tool.jar" <$filename 2>log/$file_id.log >log/$file_id.out

if [ "$?" != 0 ] # test if no error occured
then
	# we keep the log and output files in case of errors
	echo "Error: failed to run $tool on $filename!"
	cat log/$file_id.log >&2
	exit -1
else
	cat log/$file_id.log >&2
	rm log/$file_id.log # we erase empty log file
	mv log/$file_id.out $filename # we move output file
	echo "Design of $tool on $filename done!"
	exit 0
fi