USE AdventureWorks2019;
GO
CREATE TRIGGER trg_CheckStockBeforeInsert
ON Sales.SalesOrderDetail
INSTEAD OF INSERT
AS
BEGIN
    -- Check for insufficient stock
    IF EXISTS (
        SELECT 1
        FROM INSERTED i
        JOIN Production.ProductInventory pi ON i.ProductID = pi.ProductID
        WHERE pi.Quantity < i.OrderQty
    )
    BEGIN
        RAISERROR('Cannot place order: Insufficient stock.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Proceed to insert
    INSERT INTO Sales.SalesOrderDetail (
        SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount,
        rowguid, ModifiedDate, SpecialOfferID
    )
    SELECT 
        SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount,
        NEWID(), GETDATE(), ISNULL(SpecialOfferID, 1)
    FROM INSERTED;

    -- Update inventory
    UPDATE pi
    SET pi.Quantity = pi.Quantity - i.OrderQty
    FROM Production.ProductInventory pi
    JOIN INSERTED i ON pi.ProductID = i.ProductID;
END;
GO
INSERT INTO Sales.SalesOrderDetail (
    SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount,
    rowguid, ModifiedDate, SpecialOfferID
)
VALUES (
    43700, 776, 3, 50.00, 0.0, NEWID(), GETDATE(), 1
);
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderHeader;
SELECT TOP 1 ProductID, Quantity FROM Production.ProductInventory WHERE Quantity >= 5;

