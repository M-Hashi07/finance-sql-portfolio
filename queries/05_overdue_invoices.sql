-- ============================================================
-- OVERDUE INVOICES
-- All invoices past due date with days overdue and company
-- Useful for credit control and collections reporting
-- ============================================================

SELECT
    co.name                                         AS company,
    c.contact_name,
    i.invoice_number,
    i.invoice_date,
    i.due_date,
    i.total_amount,
    COALESCE(SUM(p.amount_paid), 0)                 AS amount_paid,
    i.total_amount - COALESCE(SUM(p.amount_paid), 0) AS amount_outstanding,
    CURRENT_DATE - i.due_date                       AS days_overdue,
    i.status
FROM invoices i
JOIN companies co    ON co.id = i.company_id
JOIN contacts c      ON c.id = i.contact_id
LEFT JOIN payments p ON p.invoice_id = i.id
WHERE i.due_date < CURRENT_DATE
AND   i.status NOT IN ('Paid', 'Voided')
GROUP BY co.name, c.contact_name, i.invoice_number,
         i.invoice_date, i.due_date, i.total_amount, i.status
HAVING i.total_amount - COALESCE(SUM(p.amount_paid), 0) > 0
ORDER BY days_overdue DESC;