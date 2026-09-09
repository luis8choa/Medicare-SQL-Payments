# Medicare Provider Utilization & Payment Analysis

> SQL-first analytics on CMS Medicare Part B provider-level payment data.

**Author:** [Luis Ochoa](https://www.linkedin.com/in/luisochoad)

---

## Project Purpose

<!-- TODO: 2–3 sentences on why this analysis exists and what questions it answers. -->

## Data Source & License

| Field | Value |
|---|---|
| Dataset | CMS Medicare Physician & Other Practitioners – by Provider and Service |
| Publisher | Centers for Medicare & Medicaid Services (CMS) |
| Access | [data.cms.gov](https://data.cms.gov) |
| License | <!-- TODO: confirm license (typically U.S. Government Open Data) --> |
| Year(s) | <!-- TODO: fill in the year(s) covered --> |
| Rows | <!-- TODO: fill in after loading --> |

> Raw CSVs are excluded from version control (see `.gitignore`). Download from CMS and place in `data/raw/`.

## Schema

<!-- TODO: paste the key columns after running 01_setup/. Example:
| Column | Type | Description |
|---|---|---|
| Rndrng_NPI | VARCHAR | Provider NPI |
| Rndrng_Prvdr_Last_Org_Name | VARCHAR | Provider surname / org name |
| HCPCS_Cd | VARCHAR | Procedure code |
| Tot_Srvcs | NUMERIC | Total services rendered |
| Avg_Mdcr_Pymt_Amt | NUMERIC | Average Medicare payment |
-->

## How to Run Locally

### Prerequisites
- Docker & Docker Compose
- Python 3.10+

### 1 — Start Postgres

```bash
# Core services only
docker compose up -d

# Core + pgAdmin (http://localhost:5050)
docker compose --profile pgadmin up -d
```

Default credentials are in `docker-compose.yml`; override with a `.env` file:

```
POSTGRES_USER=medicare_user
POSTGRES_PASSWORD=your_secure_password
```

### 2 — Load the data

```bash
# Inside psql / pgAdmin, after creating the table via sql/01_setup/:
\COPY medicare_providers FROM '/data/raw/your_file.csv' CSV HEADER;
```

### 3 — Python environment

```bash
pip install -r requirements.txt
jupyter lab
```

## Queries Index

| File | Description |
|---|---|
| sql/04_queries/query_1.sql | Top 15 specialties by record count |
| sql/04_queries/query_2.sql | HCPCS codes with >5,000 total services (SUM(tot_srvcs)) |
| sql/04_queries/query_3.sql | Compression ratio (allowed/submitted) by specialty |
| sql/04_queries/query_4.sql | Facility vs. non-facility split by state |
| sql/04_queries/query_5.sql | Top-3 highest-paying HCPCS codes per specialty (window function) |

### Bugs found and fixed during review (2026-09-09)

**query_2.sql**
- Was aggregating with `COUNT(*)` (row count) instead of `SUM(tot_srvcs)` (total services), and filtering `HAVING COUNT(*) > 50` instead of the required `> 5,000` — wrong metric and wrong threshold.
- Was grouping by `(hcpcs_cd, hcpcs_desc)`; changed to group by `hcpcs_cd` alone with `MAX(hcpcs_desc)` for a representative description, to avoid duplicate rows for the same code if the description ever varies.
- Note: with the corrected metric/threshold, this returns 72 rows on the 10K sample — more than the 3-20 rows the exercise sanity-check expects. Worth double-checking the exercise's expected range against this dataset size.

**query_3.sql**
- The spec asks for 3 columns using method (A), `AVG(allowed/submitted)`. The query computed 4 columns, mixing method (A) and method (B) `SUM(allowed)/SUM(submitted)`, and mislabeled them — it named the method (B) column `compression_ratio` and method (A) `collection_ratio`, backwards from what was asked. Reduced to the single, correctly-labeled `compression_ratio` column using method (A).
- `HAVING COUNT(*) > 100` excluded specialties with exactly 100 records; changed to `>= 100` per "at least 100".

**query_5.sql**
- Formula bug: computed `SUM(tot_srvcs) * AVG(avg_mdcr_pymt_amt)` instead of `SUM(tot_srvcs * avg_mdcr_pymt_amt)`. These are only equal when a group has a single row; `(provider_type, hcpcs_cd)` groups can span up to 62 distinct providers (NPIs) each with their own `avg_mdcr_pymt_amt`, so the two formulas diverged by as much as ~29% on some rows. Fixed to sum the per-row product before ranking.
- Missing `hcpcs_desc` column (spec asks for 5 columns, output only had 4).
- Switched `DENSE_RANK()` to `ROW_NUMBER()` so a tie for 3rd place can't return more than 3 rows per specialty (no ties occurred in this sample, but `ROW_NUMBER` guarantees it regardless).
- Dropped the redundant `SELECT DISTINCT` in the CTE — each `(provider_type, hcpcs_cd)` is already unique after the `GROUP BY`.

**query_1.sql / query_4.sql** — reviewed, no issues found; both match the spec as written.

## Key Findings

<!-- TODO: fill in after analysis. -->

## Tech Stack

| Layer | Tool |
|---|---|
| Database | PostgreSQL 16 (Docker) |
| SQL client | psql / pgAdmin 4 |
| Notebooks | Jupyter Lab |
| Data wrangling | pandas, SQLAlchemy |
| Visualization | matplotlib |
| Version control | Git / GitHub |

## License

See [LICENSE](LICENSE).
