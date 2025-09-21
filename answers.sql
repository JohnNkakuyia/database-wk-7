-- Question 1: Achieving 1NF

-- Use the salesdb database
USE salesdb;

-- Create the ProductDetail table if it doesn't exist
CREATE TABLE IF NOT EXISTS ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Clear any existing data and insert sample data
TRUNCATE TABLE ProductDetail;
INSERT INTO ProductDetail (OrderID, CustomerName, Products) VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Create the 1NF normalized table
DROP TABLE IF EXISTS ProductDetail_1NF;
CREATE TABLE ProductDetail_1NF AS
SELECT 
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) numbers
    ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n - 1
ORDER BY OrderID, Product;

-- Show the results
SELECT 'Original Table:' AS Table_Info;
SELECT * FROM ProductDetail;

SELECT '1NF Normalized Table:' AS Table_Info;
SELECT * FROM ProductDetail_1NF ORDER BY OrderID, Product;


-- Question 2: Achieving 2NF

-- Create the OrderDetails table if it doesn't exist
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

-- Clear any existing data and insert sample data
TRUNCATE TABLE OrderDetails;
INSERT INTO OrderDetails (OrderID, CustomerName, Product, Quantity) VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Create 2NF tables
DROP TABLE IF EXISTS Orders, OrderItems;
CREATE TABLE Orders AS 
SELECT DISTINCT OrderID, CustomerName 
FROM OrderDetails 
ORDER BY OrderID;

CREATE TABLE OrderItems AS 
SELECT OrderID, Product, Quantity 
FROM OrderDetails 
ORDER BY OrderID, Product;

-- Add primary keys
ALTER TABLE Orders ADD PRIMARY KEY (OrderID);
ALTER TABLE OrderItems ADD PRIMARY KEY (OrderID, Product);

-- Show the results
SELECT 'Original 1NF Table:' AS Table_Info;
SELECT * FROM OrderDetails ORDER BY OrderID, Product;

SELECT 'Orders Table (2NF):' AS Table_Info;
SELECT * FROM Orders;

SELECT 'OrderItems Table (2NF):' AS Table_Info;
SELECT * FROM OrderItems ORDER BY OrderID, Product;