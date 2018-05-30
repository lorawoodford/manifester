# PROCESSOR

Initial setup for development:

```bash
bundle install
./bin/dynamodb.rb --start
./bin/setup.rb

# or use the quickstart
./quickstart.sh
```

This will create two tables in DynamoDB on `http://localhost:8000`:

- `manifester_general_development_files`
- `manifester_general_development_sites`

To stop DynamoDB use: `./bin/dynamodb.rb --stop`

## Overview

The processor has two components:

### SITE

Add or delete sites with manifests to process.

```bash
# add $site
./bin/site.rb \
  --site="demo" \
  --manifest="https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv" \
  --name="LYRASIS" \
  --contact="Mark Cooper" \
  --email="example@example.com" \
  --timezone="America/New_York" \
  --add

# delete $site
./bin/site.rb --site="demo" --delete
```

### PROCESS

Process a site manifest.

```bash
./bin/process.rb --site="demo"
```

## Test

The tests require DynamoDB local: `./bin/dynamodb.rb --start`

The tests be run anytime and will not interfere with `development` data as
separate tables are created and destroyed for test runs.

## Production

Docker is recommended for production use (and the environment is set to
production by default in the `Dockerfile`):

```bash
docker build -t manifester/processor .
```

The base docker run command:

```bash
docker run -it --rm --name processor \
  -e MANIFESTER_AWS_ACCESS_KEY_ID=$MANIFESTER_AWS_ACCESS_KEY_ID \
  -e MANIFESTER_AWS_SECRET_ACCESS_KEY=$MANIFESTER_AWS_SECRET_ACCESS_KEY \
  -e MANIFESTER_AWS_REGION=us-west-2 \
  -e MANIFESTER_GRP=general \
```

Setup the tables:

```bash
  manifester/processor ./bin/setup.rb
```

Create a site:

```bash
  manifester/processor ./bin/site.rb \
    --site="demo" \
    --manifest="https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv" \
    --name="LYRASIS" \
    --contact="Mark Cooper" \
    --email="example@example.com" \
    --timezone="America/New_York" \
    --add
```

Delete a site:

```bash
  manifester/processor ./bin/site.rb --site=demo --delete
```

Process a site:

```bash
  manifester/processor ./bin/process.rb --site=demo
```
