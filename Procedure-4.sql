USE AdventureWorks2019;
GO

IF OBJECT_ID('DeleteOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE DeleteOrderDetails;
GO

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM Sales.SalesOrderDetail
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
    )
    BEGIN
        PRINT 'Invalid parameters. Deletion failed.'
        RETURN -1
    END

    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    PRINT ' Order detail successfully deleted.'
END;
GO
-- Get a real combination

SELECT TOP 1 SalesOrderID, ProductID FROM Sales.SalesOrderDetail;

EXEC DeleteOrderDetails 
    @OrderID = 43668, 
    @ProductID = 707;
-- Confirm deletion
SELECT * FROM Sales.SalesOrderDetail 
WHERE SalesOrderID = 43668 AND ProductID = 707;

