IF OBJECT_ID('vwYesterdayCustomerOrders', 'V') IS NOT NULL
    DROP VIEW vwYesterdayCustomerOrders;
GO

CREATE VIEW vwYesterdayCustomerOrders AS
SELECT 
    s.Name AS CompanyName,
    soh.SalesOrderID AS OrderID,
    soh.OrderDate,
    sod.ProductID,
    p.Name AS ProductName,
    sod.OrderQty AS Quantity,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice) AS TotalPrice
FROM Sales.Customer cust
JOIN Sales.SalesOrderHeader soh ON cust.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Sales.Store s ON cust.StoreID = s.BusinessEntityID
WHERE cust.StoreID IS NOT NULL
  AND CAST(soh.OrderDate AS DATE) = CAST(GETDATE() - 1 AS DATE);
  GO
SELECT * FROM vwYesterdayCustomerOrders;
