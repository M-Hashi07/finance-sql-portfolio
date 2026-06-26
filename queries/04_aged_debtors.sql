-- ============================================================
-- AGED DEBTORS REPORT
-- Outstanding invoices grouped by age bucket
-- Mirrors the aged debtors report in Xero / Sage / QuickBooks
-- ============================================================

SELECT
    c.contact_name,
    i.invoice_number,
    i.invoice_date,
    i.due_date,
    i.total_amount,
    COALESCE(SUM(p.amount_paid), 0)                         AS amount_paid,
    i.total_amount - COALESCE(SUM(p.amount_paid), 0)        AS amount_outstanding,
    CURRENT_DATE - i.due_date                               AS days_overdue,
    CASE
        WHEN i.total_amount - COALESCE(SUM(p.amount_paid), 0) = 0
            THEN 'Paid'
        WHEN CURRENT_DATE <= i.due_date
            THEN 'Current'
        WHEN CURRENT_DATE - i.due_date BETWEEN 1 AND 30
            THEN '1-30 days'
        WHEN CURRENT_DATE - i.due_date BETWEEN 31 AND 60
            THEN '31-60 days'
        WHEN CURRENT_DATE - i.due_date BETWEEN 61 AND 90
            THEN '61-90 days'
        ELSE '90+ days'
    END                                                     AS age_bucket
FROM invoices i
JOIN contacts c     ON c.id = i.contact_id
LEFT JOIN payments p ON p.invoice_id = i.id
WHERE i.company_id = 1
GROUP BY c.contact_name, i.invoice_number, i.invoice_date,
         i.due_date, i.total_amount
ORDER BY days_overdue DESC;