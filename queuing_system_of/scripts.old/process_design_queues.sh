#!/bin/sh

echo "This script process all xml files stored in the tool queue directories."
echo "The result is moved to a conventional results directory."
echo "A notification e-mail with a direct access url is sent to user."
echo "or an error e-mail is sent to the administrator and the user."
echo ""

if [ -z "$1" ]
then
	echo "this script needs at last a tool name in parameter"
	exit -1
fi

# exit if the resources are not available (i.e. a design is already running)
if [ -e queue/locked ] 
then
    echo "resources are not available (i.e. a design is already running)"
    exit 0
fi

cd /var/lib/wwwrun/oligofaktory

# lock de design queue
touch queue/locked

# parse argument list
while [ $# -ge 1 ]
do
	tool=$1 #extract the tool (directory) to use for design
	
	echo "file list to process:"
	echo queue/$tool/*.xml
	
	if test -f queue/$tool/*.xml
	then
		for X in queue/$tool/*.xml # process each files of the todo list    
		do
			echo "call process_offline_design.sh $X $tool :"
			./process_offline_design.sh $X $tool
		done
	else
	    echo "no xml file to process"
	fi
shift
done

# job is done; resources are released
rm queue/locked
