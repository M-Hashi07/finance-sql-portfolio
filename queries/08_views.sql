-- ============================================================
-- VIEWS
-- Saved queries that simplify reporting for end users
-- Mirrors how finance platforms expose data to non-technical users
-- ============================================================

-- 1. Outstanding debtors view
-- Shows all unpaid or partially paid invoices with days overdue
CREATE VIEW v_outstanding_debtors AS
SELECT
    co.name                                             AS company,
    c.contact_name,
    i.invoice_number,
    i.invoice_date,
    i.due_date,
    i.total_amount,
    COALESCE(SUM(p.amount_paid), 0)                     AS amount_paid,
    i.total_amount - COALESCE(SUM(p.amount_paid), 0)    AS amount_outstanding,
    CURRENT_DATE - i.due_date                           AS days_overdue
FROM invoices i
JOIN companies co     ON co.id = i.company_id
JOIN contacts c       ON c.id = i.contact_id
LEFT JOIN payments p  ON p.invoice_id = i.id
GROUP BY co.name, c.contact_name, i.invoice_number,
         i.invoice_date, i.due_date, i.total_amount
HAVING i.total_amount - COALESCE(SUM(p.amount_paid), 0) > 0;


-- 2. Posted journal summary view
-- One row per journal showing totals and balance status
CREATE VIEW v_journal_summary AS
SELECT
    j.id                                        AS journal_id,
    co.name                                     AS company,
    j.reference,
    j.journal_date,
    j.description,
    j.status,
    j.created_by,
    SUM(jl.debit)                               AS total_debits,
    SUM(jl.credit)                              AS total_credits,
    CASE
        WHEN SUM(jl.debit) = SUM(jl.credit) THEN 'BALANCED'
        ELSE 'IMBALANCED'
    END                                         AS balance_status
FROM journals j
JOIN companies co    ON co.id = j.company_id
JOIN journal_lines jl ON jl.journal_id = j.id
GROUP BY j.id, co.name, j.reference, j.journal_date,
         j.description, j.status, j.created_by;


-- 3. Revenue by company view
-- Summarises all posted income lines per company
CREATE VIEW v_revenue_summary AS
SELECT
    co.name                                     AS company,
    coa.account_code,
    coa.account_name,
    SUM(jl.credit)                              AS total_revenue
FROM journal_lines jl
JOIN chart_of_accounts coa  ON coa.id = jl.account_id
JOIN journals j             ON j.id = jl.journal_id
JOIN companies co           ON co.id = j.company_id
WHERE coa.category = 'Income'
AND   j.status = 'Posted'
GROUP BY co.name, coa.account_code, coa.account_name;


-- 4. Invoice payment status view
-- Full invoice list with payment progress and status
CREATE VIEW v_invoice_status AS
SELECT
    co.name                                             AS company,
    c.contact_name,
    i.invoice_number,
    i.invoice_date,
    i.due_date,
    i.total_amount,
    COALESCE(SUM(p.amount_paid), 0)                     AS total_paid,
    i.total_amount - COALESCE(SUM(p.amount_paid), 0)    AS balance_remaining,
    i.status,
    CASE
        WHEN i.total_amount - COALESCE(SUM(p.amount_paid), 0) = 0
            THEN 'Fully Paid'
        WHEN COALESCE(SUM(p.amount_paid), 0) > 0
            THEN 'Partially Paid'
        ELSE 'Unpaid'
    END                                                 AS payment_progress
FROM invoices i
JOIN companies co    ON co.id = i.company_id
JOIN contacts c      ON c.id = i.contact_id
LEFT JOIN payments p ON p.invoice_id = i.id
GROUP BY co.name, c.contact_name, i.invoice_number,
         i.invoice_date, i.due_date, i.total_amount, i.status;