#!/bin/sh

echo "This script process all xml files stored in the tool    "
echo "queue directories. The result is moved to a conventional"
echo "results directory. A notification e-mail with a direct  "
echo "access url is sent to user or an error e-mail is sent to"
echo "the administrator and the user.			      "
echo

if [ -z "$1" ]
then
    echo "This script needs at last a tool name in parameter"
    exit -1
fi

# exit if the resources are not available (a design is already running)
if [ -e queues/locked ]
then
    echo "Resources are not available (a design is already running)"
    exit 0
fi

cd /var/lib/wwwrun

# lock de design queue
touch queues/locked

# parse argument list
while [ $# -ge 1 ]
do
    tool=$1 #extract the tool (directory) to use for design
    echo "File list to process:"
    echo queues/$tool/*.xml
    if test -f queues/$tool/*.xml
    then
        # process each files of the todo list
        for X in queues/$tool/*.xml 
        do
            echo "Call process_offline_design.sh $X $tool :"
            ./process_offline_design.sh $X $tool
        done
    else
        echo "No xml file to process"
    fi
shift
done

# job is done; resources are released
rm queues/locked

