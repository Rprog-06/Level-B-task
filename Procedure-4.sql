IF OBJECT_ID('DeleteOrderDetails', 'P') IS NOT NULL
    DROP PROCEDURE DeleteOrderDetails;
GO

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM [Order Details]
        WHERE OrderID = @OrderID AND ProductID = @ProductID
    )
    BEGIN
        PRINT 'Invalid parameters. Deletion failed.'
        RETURN -1
    END

    DELETE FROM [Order Details]
    WHERE OrderID = @OrderID AND ProductID = @ProductID

    PRINT 'Order detail successfully deleted.'
END
