USE AdventureWorks2019;
GO

IF OBJECT_ID('UpdateOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE UpdateOrderDetails;
GO

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT = NULL,
    @Discount FLOAT = NULL
AS
BEGIN
    UPDATE Sales.SalesOrderDetail
    SET
        UnitPrice = ISNULL(@UnitPrice, UnitPrice),
        OrderQty = ISNULL(@Quantity, OrderQty),
        UnitPriceDiscount = ISNULL(@Discount, UnitPriceDiscount)
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;
END;
GO


SELECT TOP 5 * FROM Sales.SalesOrderDetail;
EXEC UpdateOrderDetails 
    @OrderID = 43659,        -- Use a real SalesOrderID
    @ProductID = 776,        -- Use a real ProductID
    @Quantity = 5,
    @UnitPrice = 25.00,
    @Discount = 0.1;
SELECT * FROM Sales.SalesOrderDetail 
WHERE SalesOrderID = 43659 AND ProductID = 776;


