-- Digiledger Solutions Ltd - Staff Attendance & Payroll System
-- Database Schema

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- EMPLOYEES TABLE
-- =====================================================
CREATE TABLE employees (
    employee_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    full_name VARCHAR(255) NOT NULL,
    designation VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for active employees lookup
CREATE INDEX idx_employees_active ON employees(is_active) WHERE is_active = true;

-- =====================================================
-- EMPLOYEE WAGES TABLE
-- =====================================================
CREATE TABLE employee_wages (
    wage_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(employee_id) ON DELETE CASCADE,
    daily_wage NUMERIC(10, 2) NOT NULL DEFAULT 40.00,
    effective_from_date DATE NOT NULL,
    effective_to_date DATE NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Constraint: effective_to_date must be after effective_from_date
    CONSTRAINT check_wage_dates CHECK (
        effective_to_date IS NULL OR effective_to_date >= effective_from_date
    ),

    -- Constraint: Only one active wage record per employee (where effective_to_date IS NULL)
    CONSTRAINT unique_active_wage UNIQUE (employee_id, effective_to_date)
);

-- Index for employee wage lookups
CREATE INDEX idx_employee_wages_employee ON employee_wages(employee_id);
CREATE INDEX idx_employee_wages_dates ON employee_wages(effective_from_date, effective_to_date);

-- =====================================================
-- ATTENDANCE TABLE
-- =====================================================
CREATE TABLE attendance (
    attendance_id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    employee_id UUID NOT NULL REFERENCES employees(employee_id) ON DELETE CASCADE,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('Present', 'Absent', 'Leave')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    -- Constraint: One attendance record per employee per day
    CONSTRAINT unique_attendance_per_day UNIQUE (employee_id, date)
);

-- Indexes for attendance queries
CREATE INDEX idx_attendance_employee ON attendance(employee_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_attendance_employee_date ON attendance(employee_id, date);
CREATE INDEX idx_attendance_status ON attendance(status);

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

-- Function to get the applicable wage for an employee on a specific date
CREATE OR REPLACE FUNCTION get_employee_wage_for_date(
    p_employee_id UUID,
    p_date DATE
)
RETURNS NUMERIC AS $$
DECLARE
    wage_amount NUMERIC;
BEGIN
    SELECT daily_wage INTO wage_amount
    FROM employee_wages
    WHERE employee_id = p_employee_id
      AND effective_from_date <= p_date
      AND (effective_to_date IS NULL OR effective_to_date >= p_date)
    ORDER BY effective_from_date DESC
    LIMIT 1;

    RETURN COALESCE(wage_amount, 0);
END;
$$ LANGUAGE plpgsql;

-- Function to update employee wage (closes old record and creates new one)
CREATE OR REPLACE FUNCTION update_employee_wage(
    p_employee_id UUID,
    p_new_daily_wage NUMERIC,
    p_effective_date DATE DEFAULT CURRENT_DATE
)
RETURNS UUID AS $$
DECLARE
    v_new_wage_id UUID;
BEGIN
    -- Close out the current active wage record
    UPDATE employee_wages
    SET effective_to_date = p_effective_date - INTERVAL '1 day'
    WHERE employee_id = p_employee_id
      AND effective_to_date IS NULL;

    -- Insert new wage record
    INSERT INTO employee_wages (employee_id, daily_wage, effective_from_date, effective_to_date)
    VALUES (p_employee_id, p_new_daily_wage, p_effective_date, NULL)
    RETURNING wage_id INTO v_new_wage_id;

    RETURN v_new_wage_id;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_attendance_updated_at BEFORE UPDATE ON attendance
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS
ALTER TABLE employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE employee_wages ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

-- Policies for authenticated users (adjust based on your auth requirements)
CREATE POLICY "Allow all operations for authenticated users" ON employees
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow all operations for authenticated users" ON employee_wages
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Allow all operations for authenticated users" ON attendance
    FOR ALL USING (auth.role() = 'authenticated');

-- =====================================================
-- SAMPLE DATA (Optional - for testing)
-- =====================================================

-- Insert sample employees
INSERT INTO employees (full_name, designation, is_active) VALUES
    ('John Doe', 'Software Engineer', true),
    ('Jane Smith', 'Project Manager', true),
    ('Bob Johnson', 'Designer', true);

-- Insert initial wages for sample employees
INSERT INTO employee_wages (employee_id, daily_wage, effective_from_date)
SELECT employee_id, 40.00, '2024-01-01'
FROM employees;

-- =====================================================
-- USEFUL VIEWS
-- =====================================================

-- View for current employee wages
CREATE VIEW current_employee_wages AS
SELECT
    e.employee_id,
    e.full_name,
    e.designation,
    e.is_active,
    ew.daily_wage,
    ew.effective_from_date
FROM employees e
LEFT JOIN employee_wages ew ON e.employee_id = ew.employee_id
WHERE ew.effective_to_date IS NULL;

-- View for payroll calculation
CREATE VIEW payroll_summary AS
SELECT
    e.employee_id,
    e.full_name,
    e.designation,
    a.date,
    a.status,
    ew.daily_wage,
    CASE
        WHEN a.status = 'Present' THEN ew.daily_wage
        ELSE 0
    END AS wage_earned
FROM attendance a
JOIN employees e ON a.employee_id = e.employee_id
JOIN employee_wages ew ON a.employee_id = ew.employee_id
    AND a.date >= ew.effective_from_date
    AND (ew.effective_to_date IS NULL OR a.date <= ew.effective_to_date);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Additional composite indexes for common queries
CREATE INDEX idx_attendance_date_status ON attendance(date, status);
CREATE INDEX idx_employee_wages_active ON employee_wages(employee_id, effective_to_date) WHERE effective_to_date IS NULL;
