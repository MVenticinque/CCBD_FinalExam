#!/bin/bash

jq -r '.[0] + ["year"] | @csv' $(ls data_raw/cbp_county_*.json | head -1) >cbp_county.csv
jq -r '.[0] + ["year"] | @csv' $(ls data_raw/cbp_state_*.json | head -1) >cbp_state.csv

for f in data_raw/cbp_county_*.json; do

  year=$(echo $f | grep -o '[0-9]\{4\}')
  jq -r --arg y "$year" '.[1:][] | . + [$y] | @csv' "$f"

done >>cbp_county.csv

for f in data_raw/cbp_state_*.json; do

  year=$(echo $f | grep -o '[0-9]\{4\}')
  jq -r --arg y "$year" '.[1:][] | . + [$y] | @csv' "$f"

done >>cbp_state.csv

echo -e "Done:\n$(wc -l <cbp_county.csv) rows for county\n$(wc -l <cbp_state.csv) rows for state"
