#!/bin/bash

set -a
source .env
set +a

if [ -z "$API_KEY" ]; then
  echo "Error: API_KEY not set"
  exit 1
fi

BASE_URL="https://api.census.gov/data"
OUTPUT_DIR="./data_raw"

mkdir -p "$OUTPUT_DIR"

SECTORS=("00" "11" "21" "22" "23" "31-33" "42" "44-45" "48-49" "51" "52" "53" "54" "56" "61" "62" "71" "72" "81")

for YEAR in $(seq 2017 2023); do
  for SECTOR in "${SECTORS[@]}"; do
    curl -s "${BASE_URL}/${YEAR}/cbp?get=NAME,NAICS2017_LABEL,EMP,PAYANN,ESTAB&for=county:*&NAICS2017=${SECTOR}&key=${API_KEY}" \
      -o "${OUTPUT_DIR}/cbp_county_${SECTOR}_${YEAR}.json"
    sleep 0.5
  done
done

for YEAR in $(seq 2017 2023); do
  for SECTOR in "${SECTORS[@]}"; do
    curl -s "${BASE_URL}/${YEAR}/cbp?get=NAME,NAICS2017_LABEL,EMP,PAYANN,ESTAB,EMPSZES,EMPSZES_LABEL,LFO,LFO_LABEL&for=state:*&NAICS2017=${SECTOR}&key=${API_KEY}" \
      -o "${OUTPUT_DIR}/cbp_state_${SECTOR}_${YEAR}.json"
    sleep 0.5
  done
done

echo "Done. Files saved to $OUTPUT_DIR/"
