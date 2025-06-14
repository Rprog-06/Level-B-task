IF OBJECT_ID('trg_CheckStock', 'TR') IS NOT NULL
    DROP TRIGGER trg_CheckStock;
GO

CREATE TRIGGER trg_CheckStock
ON Sales.SalesOrderDetail
INSTEAD OF INSERT
AS
BEGIN
    -- Check if any inserted product has insufficient stock
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN Production.ProductInventory pi ON i.ProductID = pi.ProductID
        WHERE pi.Quantity < i.OrderQty
    )
    BEGIN
        RAISERROR('❌ Insufficient stock to fulfill the order.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Insert the order details
    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate)
    SELECT 
        SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount, NEWID(), GETDATE()
    FROM INSERTED;

    -- Update the stock
    UPDATE pi
    SET pi.Quantity = pi.Quantity - i.OrderQty
    FROM Production.ProductInventory pi
    JOIN INSERTED i ON pi.ProductID = i.ProductID;
END;
