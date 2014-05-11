#!/bin/sh

#ELASTICSEARCH=http://elasticsearch.example.com:9200/
ELASTICSEARCH=http://localhost:49200/

for file in generated/*.json
do
    name=`basename $file .json`
    echo "Loading $name: "
    curl -XPUT $ELASTICSEARCH/kibana-int/dashboard/$name \
        -d @$file || exit 1
    echo
done
