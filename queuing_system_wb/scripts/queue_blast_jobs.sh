#! /bin/sh

# Authors: Colas Schretter and Laurent Gatto {cschrett,lgatto}@ulb.ac.be, 2004-2005

# change to the results and queue directories
cd /var/www/localhost/htdocs/blast

# unique temporary file identified by the ID of the running process 
TMPFILE=/tmp/queue_blast_post.$$

# saving the cgi post
cat > $TMPFILE

# parsing the cgi post file to extract blast parameters 
DATALIB=$( cat $TMPFILE | grep -Z -A 2 "DATALIB" | tail -n 1 | tr -d '\r' )
PROGRAM=$( cat $TMPFILE | grep -Z -A 2 "PROGRAM" | tail -n 1 | tr -d '\r' )
EMAIL=$( cat $TMPFILE | grep -Z -A 2 "EMAIL" | tail -n 1 | sed s/@/[at]/ | tr -d '\r' )
DATE=$( date +%Y%m%d%H%M%N )

# creating a new file in the queue
# the size of the query input is limited to 1000 lines
echo "echo \"$( cat $TMPFILE | grep -Z -A 1000 "SEQUENCE" | sed -e 1,2d -e /---/,'$'d )\" | blastall -p $PROGRAM -d $DATALIB -o ../results/$DATE.html -T T" > queue/$DATE.$EMAIL.blast

# remove cgi post
rm $TMPFILE

# output an HTML page
echo "Content-type: text/html"
echo
echo "<h2>Your BLAST job has been enqueued</h2>"
echo "<p>The status of your request will be notified by email when resources are available</p>"
echo "<p>You results will be availables at http://yourblastserver.org/blast/results/$DATE.html as soon as possible.</p>"

# try to run the BLAST immediately
./process_blast_jobs.sh


