# Cloud Computing and Big Data — Final Project

**Dataset:** US Census Bureau: County Business Patterns (CBP) 2017–2023  

**Source:** https://api.census.gov/data/{year}/cbp

**Colab Project (Spark):** https://colab.research.google.com/drive/1XhiXRfKTXAnBxR9O3AZW_pPesg0kQgPf?usp=sharing

---

## Repository Structure
```
.
├── data_raw/          # Raw JSON files from Census API (gitignored)
├── *.csv              # Merged CSVs (gitignored)
├── notebook.ipynb     # Jupyter notebook with project stage
├── sql/               # SQL queries and views
├── collect.sh         # Data collection script
├── merger.sh          # Data merging script
├── pyproject.toml     # Python dependencies
└── README.md
```

---

## 2. Data Ingestion

### Collect
To Pull County Business Patterns data from the Census API for all counties and states,
across 19 NAICS sectors and years 2017–2023, run .

```bash
chmod +x ./collect.sh
./collect.sh                # creates data_raw folder and stores json data files
```

`collect.sh` needs a free API KEY, available [here](https://api.census.gov/data/key_signup.html).

### Merge

```bash
chmod +x merger.sh
./merger.sh                # produces cbp_county.csv and cbp_state.csv
```

### Upload to GCS
```bash
gcloud storage cp cbp_county.csv cbp_state.csv gs://your-bucket-name/
gcloud storage ls gs://your-bucket-name/    # verify
```

---

## 3. Data Manipulation in BigQuery

Queries, present in `sql/` folder:

| File | Question |
|------|----------|
| `q1.sql` | Which counties significantly outperform their state sector pay? |
| `q2.sql` | Which sectors saw the biggest COVID pay decline in 2021? |
| `q3.sql` | How did wage growth differ by business size since 2017? |
| `q4.sql` | Which sectors are dominated by corporate vs sole proprietorship? |
| `q5.sql` | Which counties grew businesses despite shrinking wages? |


---

## 4. Data Analysis with Spark

Same 5 queries reproduced in [Colab Notebook](https://colab.research.google.com/drive/1XhiXRfKTXAnBxR9O3AZW_pPesg0kQgPf?usp=sharing) but using Spark.

Key findings:
- Hall County GA — Arts & Entertainment 9.5x state average in 2023.
- Accommodation & Food Services saw -6.3% pay ratio decline in 2021 (COVID effect).
- Mid-sized businesses showed strongest wage growth.
- Corporate entities dominate employment but Gov/Nonprofit entities are larger on average in Education and Healthcare.

---

## 5. Data Enrichment (ML)

Two ML tasks in [Colab Notebook](https://colab.research.google.com/drive/1XhiXRfKTXAnBxR9O3AZW_pPesg0kQgPf?usp=sharing):

**Task A — Predict county pay ratio** (Random Forest Regression)
- Features: sector, state, year, num_employees, num_businesses
- Target: pay_ratio (county vs state average)
- Results: $RMSE=0.176$, $R^2=0.31$.
- Key finding: sector (38%) and state (27%) are strongest predictors.

**Task B — Predict county wage growth direction** (Random Forest Classification)
- Features: state, year, avg_pay, tot_businesses.
- Target: binary (wage growth vs decline).
- Class imbalance handled via sample weights.
- Metrics: AUC, F1

---

## 6. Data Visualization (Looker Studio)

[Dashboard link](https://datastudio.google.com/s/rbE9jiSo3Bo)

Charts:
- Scatter plot: county vs state average pay by sector.
- Bar chart: sectors pay change over the years.
- Geo Map: graphical concentration of counties with high pay_ratio.

---

## Local Setup

```bash
# install dependencies
pip install -e .

# set Census API key
echo "API_KEY=your_key_here" > .env

# run collection + merge
./collect.sh && ./merger.sh

# launch notebook
jupyter lab
# Alternatively
code .
```

### Requirements
See `pyproject.toml`.
