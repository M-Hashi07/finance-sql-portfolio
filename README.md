# finance-sql-portfolio# Finance Systems SQL Portfolio

A PostgreSQL database project modelling a multi-company finance and accounting system, built to demonstrate SQL skills relevant to finance systems support and application support roles.

The data model mirrors the structure of platforms like Xero, QuickBooks, and Sage — covering double-entry bookkeeping, accounts receivable, VAT, payroll liabilities, and audit trails.

---

## Schema

Eight tables across three functional areas:

| Table | Description |
|---|---|
| `companies` | Multi-tenant company register |
| `chart_of_accounts` | Per-company account structure (assets, liabilities, equity, income, expenses) |
| `contacts` | Customers and suppliers |
| `journals` | Journal entry headers (draft / posted / voided) |
| `journal_lines` | Double-entry debit and credit lines |
| `invoices` | Sales invoices with VAT |
| `payments` | Payments against invoices (supports partial payments) |
| `audit_log` | Change history across all tables |

---

## Sample Data

Two companies with realistic finance data:

- **Hartwell Construction Ltd** — construction company with revenue, purchase invoices, salaries, VAT, and insurance
- **Greenway Community Trust** — charity with grant income and programme costs

---

## Queries

| File | Description |
|---|---|
| `03_trial_balance.sql` | Trial balance showing net position per account for posted journals |
| `04_aged_debtors.sql` | Aged debtors report grouped by payment age bucket (current, 1-30, 31-60, 61-90, 90+ days) |
| `05_overdue_invoices.sql` | All invoices past due date with outstanding balance and days overdue |
| `06_double_entry_check.sql` | Integrity check verifying every journal has equal debits and credits |
| `07_audit_queries.sql` | Draft journal flag, late payment analysis, and revenue summary by company |

---

## How to Run

**Requirements**: PostgreSQL 16+

```sql
-- 1. Create the database
CREATE DATABASE finance_portfolio;

-- 2. Run the schema
psql -U postgres -d finance_portfolio -f schema/01_create_tables.sql

-- 3. Load the seed data
psql -U postgres -d finance_portfolio -f data/02_seed_data.sql

-- 4. Run any query file
psql -U postgres -d finance_portfolio -f queries/03_trial_balance.sql
```

---

## Skills Demonstrated

- Relational schema design with foreign keys, constraints, and check conditions
- Double-entry bookkeeping data model
- Aggregate queries with `GROUP BY`, `HAVING`, `SUM`, `COALESCE`
- `CASE` statements for conditional bucketing (aged debtors)
- Multi-table `JOIN` across six related tables
- Date arithmetic for overdue and days-in-draft calculations
- Data integrity checks
- Multi-tenant data isolation by `company_id`

## How to Run

## Try it Live

Run queries against the full dataset in your browser — no setup needed:

[Open in DB Fiddle](https://www.db-fiddle.com/f/7CHgYE5Hiyp7RGZEbW8kCY/2)