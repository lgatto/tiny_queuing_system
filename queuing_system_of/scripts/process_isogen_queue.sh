#!/bin/sh

echo "This script process all xml files stored in the queue/isogen/ directory."
echo "The results are put in the queue/isogen/processed directory."
echo "A notification e-mail of the ordering list is sent to user."
echo "A formated order e-mail is sent to the isogen facility."
echo ""

echo "file list to process:"
echo queue/isogen/*.xml

cd /var/lib/wwwrun/oligofaktory

if test -f queue/isogen/*.xml
then
	for X in queue/isogen/*.xml # process each files of the order list    
	do
		mv $X queue/isogen/processed/ # move the file to avoid concurent access collisions

		# we will work with the file stored in the processed directory:
		X=queue/isogen/processed/`basename $X` # files a stored in a conventional tool directory
  
		# set usefull variables:
		file_id=`basename $X .xml`
		customer_email=`cat $X | grep "email" | awk -F '"' '{print $4}'` 
		isogen_email=order@isogen-lifescience.com
 
		# send an e-mail to the automated synthesis queue:
		echo "sending a formated e-mail to <$isogen_email>"
		xsltproc results_to_isogen.xsl $X | mail -s "Order from OligoFaktory ('$X')" -r $customer_email $isogen_email

		# send a confirmation e-mail to the customer:
		echo "sending a notification e-mail to <$customer_email>"
		xsltproc results_to_customer.xsl $X | mail -s "Oligo Order Confirmation (id='$file_id')" -r $isogen_email $customer_email 
	done
else
	echo "no xml file to process"
fi
