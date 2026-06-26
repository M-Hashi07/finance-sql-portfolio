-- ============================================================
-- AUDIT QUERIES
-- Analysis of the audit log and journal activity
-- Demonstrates audit trail awareness for finance systems roles
-- ============================================================

-- 1. All activity by user
SELECT
    changed_by,
    action,
    table_name,
    COUNT(*)                        AS total_changes,
    MIN(changed_at)                 AS first_change,
    MAX(changed_at)                 AS last_change
FROM audit_log
GROUP BY changed_by, action, table_name
ORDER BY changed_by, table_name;

-- 2. Draft journals older than 7 days (should have been posted or voided)
SELECT
    j.id,
    j.reference,
    j.journal_date,
    j.description,
    j.created_by,
    j.created_at,
    CURRENT_DATE - j.journal_date   AS days_in_draft
FROM journals j
WHERE j.status = 'Draft'
AND   j.journal_date < CURRENT_DATE - INTERVAL '7 days'
ORDER BY j.journal_date;

-- 3. Invoices paid after due date (late payments)
SELECT
    co.name                         AS company,
    c.contact_name,
    i.invoice_number,
    i.due_date,
    p.payment_date,
    p.payment_date - i.due_date     AS days_late,
    p.amount_paid,
    p.payment_method
FROM payments p
JOIN invoices i  ON i.id = p.invoice_id
JOIN contacts c  ON c.id = i.contact_id
JOIN companies co ON co.id = i.company_id
WHERE p.payment_date > i.due_date
ORDER BY days_late DESC;

-- 4. Revenue summary by company
SELECT
    co.name                         AS company,
    coa.account_name,
    SUM(jl.credit)                  AS total_revenue
FROM journal_lines jl
JOIN chart_of_accounts coa  ON coa.id = jl.account_id
JOIN journals j             ON j.id = jl.journal_id
JOIN companies co           ON co.id = j.company_id
WHERE coa.category = 'Income'
AND   j.status = 'Posted'
GROUP BY co.name, coa.account_name
ORDER BY co.name, total_revenue DESC;