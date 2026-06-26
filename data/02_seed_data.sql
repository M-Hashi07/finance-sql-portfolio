-- ============================================================
-- SEED DATA
-- 2 companies: Hartwell Construction Ltd, Greenway Charity
-- ============================================================

-- 1. COMPANIES
INSERT INTO companies (name, company_type, fiscal_year_end) VALUES
    ('Hartwell Construction Ltd', 'Ltd', '2024-03-31'),
    ('Greenway Community Trust', 'Charity', '2024-03-31');

-- 2. CHART OF ACCOUNTS
-- Hartwell Construction Ltd (company_id = 1)
INSERT INTO chart_of_accounts (company_id, account_code, account_name, category, account_type) VALUES
    (1, '1000', 'Bank Account',              'Asset',     'Bank'),
    (1, '1100', 'Accounts Receivable',       'Asset',     'Accounts Receivable'),
    (1, '1200', 'VAT Control Account',       'Asset',     'Tax'),
    (1, '2000', 'Accounts Payable',          'Liability', 'Accounts Payable'),
    (1, '2100', 'VAT Liability',             'Liability', 'Tax'),
    (1, '2200', 'PAYE Liability',            'Liability', 'Payroll'),
    (1, '3000', 'Share Capital',             'Equity',    'Capital'),
    (1, '3100', 'Retained Earnings',         'Equity',    'Retained Earnings'),
    (1, '4000', 'Construction Revenue',      'Income',    'Revenue'),
    (1, '4100', 'Consultancy Revenue',       'Income',    'Revenue'),
    (1, '5000', 'Materials Cost',            'Expense',   'Direct Cost'),
    (1, '5100', 'Subcontractor Cost',        'Expense',   'Direct Cost'),
    (1, '6000', 'Salaries',                  'Expense',   'Overhead'),
    (1, '6100', 'Rent and Rates',            'Expense',   'Overhead'),
    (1, '6200', 'Utilities',                 'Expense',   'Overhead'),
    (1, '6300', 'Insurance',                 'Expense',   'Overhead');

-- Greenway Community Trust (company_id = 2)
INSERT INTO chart_of_accounts (company_id, account_code, account_name, category, account_type) VALUES
    (2, '1000', 'Bank Account',              'Asset',     'Bank'),
    (2, '1100', 'Accounts Receivable',       'Asset',     'Accounts Receivable'),
    (2, '2000', 'Accounts Payable',          'Liability', 'Accounts Payable'),
    (2, '3000', 'Unrestricted Funds',        'Equity',    'Capital'),
    (2, '3100', 'Restricted Funds',          'Equity',    'Capital'),
    (2, '4000', 'Grant Income',              'Income',    'Revenue'),
    (2, '4100', 'Donation Income',           'Income',    'Revenue'),
    (2, '5000', 'Programme Costs',           'Expense',   'Direct Cost'),
    (2, '6000', 'Staff Costs',               'Expense',   'Overhead'),
    (2, '6100', 'Office Costs',              'Expense',   'Overhead');

-- 3. CONTACTS
-- Hartwell contacts
INSERT INTO contacts (company_id, contact_name, contact_type, email) VALUES
    (1, 'Barratt Developments PLC',  'Customer', 'accounts@barratt.co.uk'),
    (1, 'Taylor Wimpey Ltd',         'Customer', 'ap@taylorwimpey.co.uk'),
    (1, 'Jewson Building Supplies',  'Supplier', 'invoices@jewson.co.uk'),
    (1, 'HSS Hire Service',          'Supplier', 'billing@hsshire.co.uk'),
    (1, 'Aon UK Ltd',                'Supplier', 'premiums@aon.co.uk');

-- Greenway contacts
INSERT INTO contacts (company_id, contact_name, contact_type, email) VALUES
    (2, 'National Lottery Community Fund', 'Customer', 'grants@tnlcommunityfund.org.uk'),
    (2, 'London Borough of Enfield',       'Customer', 'finance@enfield.gov.uk'),
    (2, 'Office Depot UK',                 'Supplier', 'accounts@officedepot.co.uk');

-- 4. JOURNALS
-- Hartwell journals
INSERT INTO journals (company_id, journal_date, reference, description, status, created_by) VALUES
    (1, '2024-01-15', 'JNL-001', 'Sales invoice to Barratt Developments',    'Posted', 'zack.kay'),
    (1, '2024-01-20', 'JNL-002', 'Purchase invoice from Jewson',             'Posted', 'zack.kay'),
    (1, '2024-01-31', 'JNL-003', 'January salaries',                         'Posted', 'zack.kay'),
    (1, '2024-02-15', 'JNL-004', 'Sales invoice to Taylor Wimpey',           'Posted', 'zack.kay'),
    (1, '2024-02-28', 'JNL-005', 'February salaries',                        'Posted', 'zack.kay'),
    (1, '2024-03-10', 'JNL-006', 'Insurance premium Aon',                    'Posted', 'zack.kay'),
    (1, '2024-03-31', 'JNL-007', 'Quarter end accruals',                     'Draft',  'zack.kay');

-- Greenway journals
INSERT INTO journals (company_id, journal_date, reference, description, status, created_by) VALUES
    (2, '2024-01-10', 'GW-001', 'National Lottery grant received',           'Posted', 'zack.kay'),
    (2, '2024-02-01', 'GW-002', 'Enfield Council grant drawdown',            'Posted', 'zack.kay'),
    (2, '2024-03-15', 'GW-003', 'Programme delivery costs Q4',               'Posted', 'zack.kay');

-- 5. JOURNAL LINES (double-entry)
-- JNL-001: Sales invoice to Barratt (revenue + VAT)
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (1, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='1100'), 'Barratt invoice AR',         24000.00, 0),
    (1, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='4000'), 'Construction revenue',       0, 20000.00),
    (1, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='2100'), 'VAT on sales',               0,  4000.00);

-- JNL-002: Purchase invoice from Jewson
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (2, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='5000'), 'Materials from Jewson',       8500.00, 0),
    (2, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='1200'), 'Input VAT',                   1700.00, 0),
    (2, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='2000'), 'Jewson payable',              0, 10200.00);

-- JNL-003: January salaries
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (3, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='6000'), 'Gross salaries January',     15000.00, 0),
    (3, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='2200'), 'PAYE liability',              0,  3500.00),
    (3, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='1000'), 'Net pay bank',                0, 11500.00);

-- JNL-004: Sales invoice to Taylor Wimpey
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (4, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='1100'), 'Taylor Wimpey invoice AR',   36000.00, 0),
    (4, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='4000'), 'Construction revenue',        0, 30000.00),
    (4, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='2100'), 'VAT on sales',                0,  6000.00);

-- JNL-005: February salaries
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (5, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='6000'), 'Gross salaries February',    15000.00, 0),
    (5, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='2200'), 'PAYE liability',              0,  3500.00),
    (5, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='1000'), 'Net pay bank',                0, 11500.00);

-- JNL-006: Insurance premium
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (6, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='6300'), 'Aon insurance premium',       3600.00, 0),
    (6, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='1000'), 'Bank payment',                0,  3600.00);

-- JNL-007: Quarter end accruals (draft - intentionally unbalanced for demo purposes)
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (7, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='5100'), 'Subcontractor accrual',       5000.00, 0),
    (7, (SELECT id FROM chart_of_accounts WHERE company_id=1 AND account_code='2000'), 'Accrued liability',            0,  5000.00);

-- GW-001: Lottery grant received
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (8, (SELECT id FROM chart_of_accounts WHERE company_id=2 AND account_code='1000'), 'Grant cash received',         50000.00, 0),
    (8, (SELECT id FROM chart_of_accounts WHERE company_id=2 AND account_code='4000'), 'National Lottery grant',       0, 50000.00);

-- GW-002: Enfield Council grant
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (9, (SELECT id FROM chart_of_accounts WHERE company_id=2 AND account_code='1100'), 'Enfield grant receivable',    15000.00, 0),
    (9, (SELECT id FROM chart_of_accounts WHERE company_id=2 AND account_code='4000'), 'Council grant income',         0, 15000.00);

-- GW-003: Programme costs
INSERT INTO journal_lines (journal_id, account_id, description, debit, credit) VALUES
    (10, (SELECT id FROM chart_of_accounts WHERE company_id=2 AND account_code='5000'), 'Q4 programme delivery',      12000.00, 0),
    (10, (SELECT id FROM chart_of_accounts WHERE company_id=2 AND account_code='6000'), 'Staff costs Q4',              8000.00, 0),
    (10, (SELECT id FROM chart_of_accounts WHERE company_id=2 AND account_code='1000'), 'Bank payment',                 0, 20000.00);

-- 6. INVOICES
-- Hartwell invoices
INSERT INTO invoices (company_id, contact_id, invoice_number, invoice_date, due_date, subtotal, vat_amount, total_amount, status) VALUES
    (1, 1, 'INV-2024-001', '2024-01-15', '2024-02-14', 20000.00, 4000.00, 24000.00, 'Paid'),
    (1, 2, 'INV-2024-002', '2024-02-15', '2024-03-16', 30000.00, 6000.00, 36000.00, 'Overdue'),
    (1, 1, 'INV-2024-003', '2024-03-01', '2024-03-31', 15000.00, 3000.00, 18000.00, 'Sent');

-- Greenway invoices
INSERT INTO invoices (company_id, contact_id, invoice_number, invoice_date, due_date, subtotal, vat_amount, total_amount, status) VALUES
    (2, 6, 'GW-2024-001', '2024-01-10', '2024-01-31', 50000.00, 0, 50000.00, 'Paid'),
    (2, 7, 'GW-2024-002', '2024-02-01', '2024-02-28', 15000.00, 0, 15000.00, 'Sent');

-- 7. PAYMENTS
INSERT INTO payments (invoice_id, payment_date, amount_paid, payment_method, reference) VALUES
    (1, '2024-02-10', 24000.00, 'BACS',   'BACS-REF-001'),
    (4, '2024-01-28', 50000.00, 'BACS',   'BACS-REF-002'),
    (2, '2024-03-20', 18000.00, 'CHAPS',  'CHAPS-REF-001');