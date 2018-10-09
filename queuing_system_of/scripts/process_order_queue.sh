#!/bin/sh

echo "This script process all xml files stored queues/order/"
echo "The results are put in queues/order/processed/"
echo "A notification e-mail of the ordering list is sent to user."
echo "A formated order e-mail is sent to the ordering facility."
echo ""

echo "file list to process:"
echo queues/order/*.xml
cd /var/lib/wwwrun

if test -f queues/order/*.xml
then
    # process each files of the order list:
    for X in queues/order/*.xml 
    do
        # move the file to avoid concurrent access collisions:
        mv $X queues/order/processed/
        # we will work with the file stored in the processed directory:
        X=queues/order/processed/`basename $X`
        # set useful variables:
        file_id=`basename $X .xml`
        customer_email=`cat $X | grep "email" | awk -F '"' '{print $4}'` 
		#  Use " as input field separator to be replaced
        order_email=administrator@yourdomain.org
        
	# send an e-mail to the automated synthesis queue:
        echo "sending a formated e-mail to <$order_email>"
        xsltproc results_to_order.xsl $X \
        	| mail -s "Order from OligoFaktory ('$X')" \
        	-r $customer_email $order_email
        # send a confirmation e-mail to the customer:
        echo "sending a notification e-mail to <$customer_email>"
        xsltproc results_to_customer.xsl $X \
        	| mail -s "Oligo Order Confirmation (id=$file_id)" \
          	-r $order_email $customer_email
    done
else
    echo "no xml file to process"
fi
