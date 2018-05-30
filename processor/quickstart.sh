#!/bin/bash

./bin/dynamodb.rb --stop
./bin/dynamodb.rb --start
sleep 1
./bin/setup.rb

./bin/site.rb \
  --site="demo" \
  --manifest="https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv" \
  --name="LYRASIS" \
  --contact="Mark Cooper" \
  --email="example@example.com" \
  --timezone="America/New_York" \
  --add

./bin/process.rb --site="demo"
open http://localhost:8000/
