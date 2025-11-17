-- Project: Finance_Analytics
-- Purpose: Analyze revenue, costs, profit margins for drug sales


-- 1. Drugs table
CREATE TABLE Drugs (
    DrugID INT PRIMARY KEY,
    DrugName VARCHAR(100)
);

INSERT INTO Drugs (DrugID, DrugName) VALUES
(1, 'Cefadroxil 500mg'),
(2, 'Diclofenac 50mg'),
(3, 'Metformin 500mg');

-- 2. Sales table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    DrugID INT,
    QuantitySold INT,
    UnitPrice DECIMAL(10,2),
    SaleDate DATE,
    FOREIGN KEY (DrugID) REFERENCES Drugs(DrugID)
);

INSERT INTO Sales (SaleID, DrugID, QuantitySold, UnitPrice, SaleDate) VALUES
(1, 1, 100, 120.00, '2024-03-05'),
(2, 2, 200, 90.00, '2024-03-06'),
(3, 3, 150, 80.00, '2024-03-07'),
(4, 1, 50, 120.00, '2024-03-08'),
(5, 2, 100, 90.00, '2024-03-09');

-- 3. Costs table (production costs per drug)
CREATE TABLE Costs (
    CostID INT PRIMARY KEY,
    DrugID INT,
    CostPerUnit DECIMAL(10,2),
    FOREIGN KEY (DrugID) REFERENCES Drugs(DrugID)
);

INSERT INTO Costs (CostID, DrugID, CostPerUnit) VALUES
(1, 1, 70.00),
(2, 2, 45.00),
(3, 3, 50.00);

-- 4. Expenses table (departmental)
CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY,
    Department VARCHAR(50),
    Amount DECIMAL(10,2),
    ExpenseDate DATE
);

INSERT INTO Expenses (ExpenseID, Department, Amount, ExpenseDate) VALUES
(1, 'Production', 50000, '2024-03-01'),
(2, 'Sales', 30000, '2024-03-02'),
(3, 'Marketing', 20000, '2024-03-03'),
(4, 'R&D', 40000, '2024-03-04');

-- =====================================================
-- Finance Analytics Queries
-- =====================================================

-- 1. Total revenue per drug
SELECT 
    d.DrugName,
    SUM(s.QuantitySold * s.UnitPrice) AS TotalRevenue
FROM Sales s
JOIN Drugs d ON s.DrugID = d.DrugID
GROUP BY d.DrugName
ORDER BY TotalRevenue DESC;

-- 2. Profit per drug
SELECT 
    d.DrugName,
    SUM(s.QuantitySold * s.UnitPrice) AS Revenue,
    SUM(s.QuantitySold * c.CostPerUnit) AS TotalCost,
    SUM(s.QuantitySold * s.UnitPrice) - SUM(s.QuantitySold * c.CostPerUnit) AS Profit
FROM Sales s
JOIN Costs c ON s.DrugID = c.DrugID
JOIN Drugs d ON s.DrugID = d.DrugID
GROUP BY d.DrugName
ORDER BY Profit DESC;

-- 3. Total departmental expenses
SELECT 
    Department,
    SUM(Amount) AS TotalExpenses
FROM Expenses
GROUP BY Department
ORDER BY TotalExpenses DESC;

-- 4. Monthly revenue summary
SELECT 
    YEAR(SaleDate) AS Year,
    MONTH(SaleDate) AS Month,
    SUM(QuantitySold * UnitPrice) AS MonthlyRevenue
FROM Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate)
ORDER BY Year, Month;

-- 5. Profit margin per drug
SELECT 
    d.DrugName,
    (SUM(s.QuantitySold * s.UnitPrice) - SUM(s.QuantitySold * c.CostPerUnit)) / SUM(s.QuantitySold * s.UnitPrice) * 100 AS ProfitMarginPercent
FROM Sales s
JOIN Costs c ON s.DrugID = c.DrugID
JOIN Drugs d ON s.DrugID = d.DrugID
GROUP BY d.DrugName
ORDER BY ProfitMarginPercent DESC;
