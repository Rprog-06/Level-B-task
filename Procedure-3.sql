USE AdventureWorks2019;
GO

IF OBJECT_ID('GetOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE GetOrderDetails;
GO

CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @OrderID
    )
    BEGIN
        RAISERROR('No order details found for the given OrderID.', 10, 1);
        RETURN;
    END

    SELECT 
        sod.SalesOrderID,
        sod.SalesOrderDetailID,
        sod.ProductID,
        p.Name AS ProductName,
        sod.OrderQty,
        sod.UnitPrice,
        sod.UnitPriceDiscount,
        sod.LineTotal,
        sod.ModifiedDate
    FROM Sales.SalesOrderDetail sod
    INNER JOIN Production.Product p ON sod.ProductID = p.ProductID
    WHERE sod.SalesOrderID = @OrderID;
END;
GO
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderDetail;
-- Example: 43659
EXEC GetOrderDetails @OrderID = 43659;
