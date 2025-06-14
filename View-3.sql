IF OBJECT_ID('MyProducts', 'V') IS NOT NULL
    DROP VIEW MyProducts;
GO

CREATE VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.Size AS QuantityPerUnit,
    p.ListPrice AS UnitPrice,
    v.Name AS SupplierName,
    c.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductSubcategory c ON p.ProductSubcategoryID = c.ProductSubcategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID  -- fixed schema
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE p.SellEndDate IS NULL;
