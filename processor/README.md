# PROCESSOR

Initial setup:

```bash
bundle install
./bin/setup.rb
```

The processor has two components:

## SITE

Add or delete sites with manifests to process.

```bash
# add $site
./bin/site.rb \
  --site="demo" \
  --manifest="https://archivesspace.lyrasistechnology.org/files/exports/manifest_ead_xml.csv" \
  --name="LYRASIS" \
  --contact="Mark Cooper" \
  --email="example@example.com" \
  --timezone="US/New_York" \
  --add

# delete $site
./bin/site.rb --site="demo" --delete
```

## PROCESS

Process a site manifest.
