IF OBJECT_ID('trg_DeleteOrder', 'TR') IS NOT NULL
    DROP TRIGGER trg_DeleteOrder;
GO

CREATE TRIGGER trg_DeleteOrder
ON Sales.SalesOrderHeader
INSTEAD OF DELETE
AS
BEGIN
    -- Delete from child table first
    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID IN (SELECT SalesOrderID FROM DELETED);

    -- Then delete from parent
    DELETE FROM Sales.SalesOrderHeader
    WHERE SalesOrderID IN (SELECT SalesOrderID FROM DELETED);
END;
GO
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderHeader;
-- Example: 43659
DELETE FROM Sales.SalesOrderHeader WHERE SalesOrderID = 43659;
SELECT * FROM Sales.SalesOrderHeader WHERE SalesOrderID = 43659;
SELECT * FROM Sales.SalesOrderDetail WHERE SalesOrderID = 43659;
