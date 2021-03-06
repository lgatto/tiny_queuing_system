#!/bin/sh

echo "This script process a given xml file with a given java tool."
echo "The result is moved to a conventional results directory."
echo "A notification e-mail with a direct access url is sent to user."
echo "or an error e-mail is sent to the administrator and the user."
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
designer_email=`cat $filename | grep "email" | awk -F '"' '{print $4}'` 
administrator_email=oligofak@ulb.ac.be

# avoid concurent access collisions:
mv $filename results
    
# we will work with the file stored in the results directory:
filename=results/`basename $filename`

# launch the appropriate design tool:
ssh wwwrun@164.15.232.116 "java -jar $tool.jar" <$filename 2>log/$file_id.log >log/$file_id.out

if [ "$?" != 0 ] # test if no error occured
then
	# we keep the log in case of errors
	echo "Error: failed to run $tool on $filename!"
	echo "sending a notification e-mail to <$designer_email> and <$administrator_email>"

	cat log/$file_id.log

	# send a reply to user and to administrator a notification with the error message (cc)
	echo "
	Dear OligoFaktory User!

	This e-mail has been generated.

	An error occured at the execution of $tool on your design query of id '$file_id'!
	In most of the case, this mean that your input data contains integrity errors.
	
	The following error message could help developpers to understand the exact cause:
	`cat log/$file_id.log`
	" \
	| mail -s "OligoFaktory Design ERROR (id='$file_id')" -r $administrator_email $administrator_email	
#	| mail -s "OligoFaktory Design ERROR (id='$file_id')" -r $administrator_email $designer_email -c $administrator_email	
else
	rm log/$file_id.log # we erase empty log file
	mv log/$file_id.out $filename # we move output file
	
	echo "Design of $tool on $filename done!"
	echo "sending a notification e-mail to <$designer_email>"
	
	# send a notification e-mail to the customer:
	echo "
	Dear OligoFaktory User!

	This e-mail has been generated.

	Your results sheet corresponding to $tool design of id '$file_id' is available on the OligoFaktory website.

	You can access directly to the results with the following URL:

	http://ueg.ulb.ac.be/oligofaktory/results.jsp?id=$file_id

	Have a nice day.
	" \
	| mail -s "OligoFaktory Design (id='$file_id')" -a $filename -r $administrator_email $designer_email 	
fi