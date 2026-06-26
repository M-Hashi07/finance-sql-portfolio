-- ============================================================
-- TRIAL BALANCE
-- Total debits and credits per account for a given company
-- Only includes posted journals
-- ============================================================

SELECT
    coa.account_code,
    coa.account_name,
    coa.category,
    coa.account_type,
    SUM(jl.debit)                               AS total_debits,
    SUM(jl.credit)                              AS total_credits,
    SUM(jl.debit) - SUM(jl.credit)             AS net_balance
FROM chart_of_accounts coa
JOIN journal_lines jl   ON jl.account_id = coa.id
JOIN journals j         ON j.id = jl.journal_id
WHERE j.status = 'Posted'
AND   coa.company_id = 1  -- Hartwell Construction Ltd
GROUP BY coa.account_code, coa.account_name, coa.category, coa.account_type
ORDER BY coa.account_code;