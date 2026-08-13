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

<!-- TODO: fill in as you write queries this week. Example:
| File | Description |
|---|---|
| sql/02_exploration/01_row_counts.sql | Basic row and null counts |
| sql/03_analysis/01_top_procedures.sql | Top 20 procedures by total payments |
-->

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
