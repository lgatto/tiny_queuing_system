#!/bin/sh

# Authors: Laurent Gatto and Colas Schretter {lgatto,cschrett}@ulb.ac.be, 2004-2005

# change to the working directory
cd /var/www/localhost/htdocs/blast/queue/

if [ -e ./locked ] 
then
    # Resources are not available
    exit 0
fi

# lock de system
touch ./locked

# process all enqueued files reverse sorted by timestamp
for JOB in $( ls -1tr *blast )
do
	# get the results' url and the user's email
	EMAIL=$( basename $JOB .blast | sed -e s/^[0-9]*\.// -e s/\\[at\\]/@/ )
	HTML=${JOB%%.*}.html

	sh $JOB
	rm $JOB
	
	# mail user that the results are ready
	echo "Dear user,
your BLAST results are available at 
http://yourblastserver.org/blast/results/$HTML

Enjoy" | mail -s "BLAST results" $EMAIL

done

# job(s) is/are done; resources are freed
rm ./locked

