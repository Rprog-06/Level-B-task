IF OBJECT_ID('InsertOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE InsertOrderDetails;
GO

CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice MONEY = NULL,
    @Quantity INT,
    @Discount FLOAT = 0
AS
BEGIN
    DECLARE @AvailableStock INT, @ProductPrice MONEY;

    --  Get stock and price
    SELECT 
        @AvailableStock = pi.Quantity,
        @ProductPrice = p.ListPrice
    FROM Production.Product p
    JOIN Production.ProductInventory pi ON p.ProductID = pi.ProductID
    WHERE p.ProductID = @ProductID;

	

    --  Default price
    IF @UnitPrice IS NULL
        SET @UnitPrice = @ProductPrice;

    --  Check stock
    IF @AvailableStock < @Quantity
    BEGIN
        PRINT 'Not enough stock. Order aborted.';
        RETURN;
    END

    --  Insert order detail
    INSERT INTO Sales.SalesOrderDetail (
        SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount, rowguid, ModifiedDate
    )
    VALUES (
        @OrderID, @ProductID, @Quantity, @UnitPrice, @Discount, NEWID(), GETDATE()
    );

    --  Check if inserted
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT ' Failed to place the order.';
        RETURN;
    END

    --  Update stock
    UPDATE Production.ProductInventory
    SET Quantity = Quantity - @Quantity
    WHERE ProductID = @ProductID;

    --  Optional warning
    IF @AvailableStock - @Quantity < 10 -- arbitrary reorder level
        PRINT ' Warning: Stock dropped below safe threshold.';
END;
GO
-- Use an existing order (e.g., 43659) and product (e.g., 776)
SELECT TOP 1 SalesOrderID FROM Sales.SalesOrderHeader ORDER BY NEWID(); -- Get random order
SELECT TOP 1 ProductID, Quantity FROM Production.ProductInventory WHERE Quantity > 10; -- Get a valid product
EXEC InsertOrderDetails 
    @OrderID = 56464,     -- Use a valid SalesOrderID
    @ProductID = 1,     -- Ensure this ProductID has quantity > 10
    @UnitPrice = NULL,    -- Should default to Product.ListPrice
    @Quantity = 408,        
    @Discount = 0.1;







