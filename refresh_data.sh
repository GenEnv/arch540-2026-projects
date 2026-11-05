#!/bin/zsh
# Saves a fresh copy of the two sheet tabs into data/ (used by the page only when the live sheet cannot be reached).
set -e
cd "$(dirname "$0")"
SHEET=10-8GOJDdNf2oM-7lpjZlFgsWTTEWyE2AjwOprtiw5ow
curl -sfL "https://docs.google.com/spreadsheets/d/$SHEET/export?format=csv&gid=0" -o data/midreview.csv
curl -sfL "https://docs.google.com/spreadsheets/d/$SHEET/export?format=csv&gid=1681716343" -o data/assignment1.csv
sed -i '' "s/var SNAPSHOT_DATE='[0-9-]*'/var SNAPSHOT_DATE='$(date +%Y-%m-%d)'/" index.html
wc -l data/*.csv
