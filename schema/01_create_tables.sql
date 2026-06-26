-- ============================================================
-- FINANCE SYSTEMS SQL PORTFOLIO
-- Schema v1 | PostgreSQL
-- ============================================================

-- 1. COMPANIES
CREATE TABLE companies (
    id               SERIAL PRIMARY KEY,
    name             VARCHAR(200) NOT NULL,
    company_type     VARCHAR(50) CHECK (company_type IN ('Ltd', 'LLP', 'Sole Trader', 'Partnership', 'Charity')),
    fiscal_year_end  DATE NOT NULL,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. CHART OF ACCOUNTS
CREATE TABLE chart_of_accounts (
    id            SERIAL PRIMARY KEY,
    company_id    INT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    account_code  VARCHAR(10) NOT NULL,
    account_name  VARCHAR(200) NOT NULL,
    category      VARCHAR(50) NOT NULL CHECK (category IN ('Asset', 'Liability', 'Equity', 'Income', 'Expense')),
    account_type  VARCHAR(50),
    is_active     BOOLEAN DEFAULT TRUE,
    UNIQUE (company_id, account_code)
);

-- 3. CONTACTS
CREATE TABLE contacts (
    id            SERIAL PRIMARY KEY,
    company_id    INT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    contact_name  VARCHAR(200) NOT NULL,
    contact_type  VARCHAR(20) NOT NULL CHECK (contact_type IN ('Customer', 'Supplier', 'Both')),
    email         VARCHAR(200),
    is_active     BOOLEAN DEFAULT TRUE
);

-- 4. JOURNALS
CREATE TABLE journals (
    id            SERIAL PRIMARY KEY,
    company_id    INT NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    journal_date  DATE NOT NULL,
    reference     VARCHAR(100),
    description   TEXT,
    status        VARCHAR(20) DEFAULT 'Draft' CHECK (status IN ('Draft', 'Posted', 'Voided')),
    created_by    VARCHAR(100),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. JOURNAL LINES
CREATE TABLE journal_lines (
    id            SERIAL PRIMARY KEY,
    journal_id    INT NOT NULL REFERENCES journals(id) ON DELETE CASCADE,
    account_id    INT NOT NULL REFERENCES chart_of_accounts(id),
    description   TEXT,
    debit         NUMERIC(15,2) DEFAULT 0 CHECK (debit >= 0),
    credit        NUMERIC(15,2) DEFAULT 0 CHECK (credit >= 0),
    CONSTRAINT not_both_nonzero CHECK (NOT (debit > 0 AND credit > 0))
);

-- 6. INVOICES
CREATE TABLE invoices (
    id              SERIAL PRIMARY KEY,
    company_id      INT NOT NULL REFERENCES companies(id),
    contact_id      INT NOT NULL REFERENCES contacts(id),
    invoice_number  VARCHAR(50) NOT NULL,
    invoice_date    DATE NOT NULL,
    due_date        DATE NOT NULL,
    subtotal        NUMERIC(15,2) NOT NULL,
    vat_amount      NUMERIC(15,2) DEFAULT 0,
    total_amount    NUMERIC(15,2) NOT NULL,
    status          VARCHAR(20) DEFAULT 'Draft' CHECK (status IN ('Draft', 'Sent', 'Paid', 'Overdue', 'Voided')),
    UNIQUE (company_id, invoice_number)
);

-- 7. PAYMENTS
CREATE TABLE payments (
    id              SERIAL PRIMARY KEY,
    invoice_id      INT NOT NULL REFERENCES invoices(id),
    payment_date    DATE NOT NULL,
    amount_paid     NUMERIC(15,2) NOT NULL CHECK (amount_paid > 0),
    payment_method  VARCHAR(50) CHECK (payment_method IN ('BACS', 'CHAPS', 'Card', 'Cheque', 'Cash', 'Direct Debit')),
    reference       VARCHAR(100)
);

-- 8. AUDIT LOG
CREATE TABLE audit_log (
    id            SERIAL PRIMARY KEY,
    table_name    VARCHAR(100) NOT NULL,
    record_id     INT NOT NULL,
    action        VARCHAR(10) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    changed_by    VARCHAR(100),
    changed_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_values    JSONB,
    new_values    JSONB
);