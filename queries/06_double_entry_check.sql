-- ============================================================
-- DOUBLE ENTRY INTEGRITY CHECK
-- Verifies every posted journal has equal debits and credits
-- Flags any journal where debits != credits
-- ============================================================

SELECT
    j.id                                        AS journal_id,
    j.reference,
    j.journal_date,
    j.description,
    j.status,
    SUM(jl.debit)                               AS total_debits,
    SUM(jl.credit)                              AS total_credits,
    SUM(jl.debit) - SUM(jl.credit)             AS variance,
    CASE
        WHEN SUM(jl.debit) = SUM(jl.credit) THEN 'BALANCED'
        ELSE 'IMBALANCED'
    END                                         AS balance_status
FROM journals j
JOIN journal_lines jl ON jl.journal_id = j.id
GROUP BY j.id, j.reference, j.journal_date, j.description, j.status
ORDER BY balance_status DESC, j.journal_date;