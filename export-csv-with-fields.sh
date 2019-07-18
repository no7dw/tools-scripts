#!/bin/bash
OIFS=$IFS;
IFS=",";
# fill in your details here
dbname="nowdone"
user=""
pass=""
host="10.10.20.90"
port="57017"
#Change this to the DB you are dumping if you have the user created at the DB level.
authdb="root"

# first get all collections in the database

collectionArray=("ex_order","ex_ledger")
# for each collection
for col in $collectionArray;
do
    echo 'exporting collection' $col
    # get comma separated list of keys. do this by peeking into the first document in the collection and get his set of keys
    keys=`mongo $dbname --host $host --port $port  --eval "function z(c,e){var a=[];var d=Object.keys(c);for(var f in d){var b=d[f];if(typeof c[b]==='object'){var g=[],h=z(c[b],e+'.'+b);a=g.concat(a,h);}else a.push(e+'.'+b);}return a;}var a=[],b=db.$col.findOne({}),c=Object.keys(b);for(var i in c){var j=c[i];if(typeof b[j]==='object'&&j!='_id'){var t1=[],t2=z(b[j],j);a=t1.concat(a,t2);}else a.push(j);}a.join(',');" --quiet`
    # now use mongoexport with the set of keys to export the collection to csv
    mongoexport --host $host --port $port  --authenticationDatabase $authdb -d $dbname -c $col --fields "$keys" --type=csv --out $dbname.$col.csv --authenticationDatabase wowtokenio;
done

IFS=$OIFS;
