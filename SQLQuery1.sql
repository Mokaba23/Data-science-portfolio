CREATE VIEW VwTest
AS
SELECT Name, DueDate, Type 
	FROM sales.Store S
	JOIN sales.SalesPerson sp ON sp.BusinessEntityID = s.SalesPersonID
	JOIN sales.SalesOrderHeader soh ON soh.SalesPersonID = sp.BusinessEntityID
	JOIN sales.SalesOrderDetail sod ON sod.SalesOrderID = soh.SalesOrderID
	JOIN Sales.SpecialOffer so ON so.SpecialOfferID = sod.SpecialOfferID

-----Variables declaration

DECLARE @SpID Int 
SET @SpID = 250

SELECT * FROM Sales.Store
WHERE SalesPersonID >= @SpID

DECLARE @StoreName Varchar(100) 
SET @StoreName = 'North Bike Company'

SELECT * FROM Sales.Store
WHERE Name = @StoreName


DECLARE @Date date 
SET @Date = '2014-09-12'

SELECT * FROM Sales.Store
WHERE Convert(date,ModifiedDate) = @Date

-----Stored Procedure

CREATE PROCEDURE SpListAllStores
AS
BEGIN

SELECT * FROM Sales.Store

END

Execute SpListAllStores

---------

CREATE PROC SpFilterSalesPersonID @SalesPID int
AS
BEGIN

SELECT * FROM Sales.Store s
WHERE s.SalesPersonID =  @SalesPID

END

--DROP PROC SpFilterSalesPersonID

EXEC SpFilterSalesPersonID 288

--- Stored procedure taking multiple arguments.
CREATE PROC SpFilterByMultipleArgs @Status Varchar(100), @Bonus float, @Type Int
AS
BEGIN
	SELECT Name, DueDate, Type 
	FROM sales.Store S
	JOIN sales.SalesPerson sp ON sp.BusinessEntityID = s.SalesPersonID
	JOIN sales.SalesOrderHeader soh ON soh.SalesPersonID = sp.BusinessEntityID
	JOIN sales.SalesOrderDetail sod ON sod.SalesOrderID = soh.SalesOrderID
	JOIN Sales.SpecialOffer so ON so.SpecialOfferID = sod.SpecialOfferID
	WHERE Status = @Status AND Bonus > = @Bonus AND Type = @Type
END

EXEC SpFilterByMultipleArgs '1', 10000.00, 2

SELECT * FROM Sales.SpecialOffer

--- T-SQL FUNCTIONS 

CREATE FUNCTION 
FnListAllStore()
RETURNS TABLE
AS RETURN 
(
	SELECT * FROM Sales.Store

)

SELECT * FROM FnListAllStore()

----Function taking one argument

CREATE FUNCTION 
FnFilterStoreWith1Arg(@SalesPersonID int)
RETURNS TABLE 
AS RETURN
(

SELECT * FROM Sales.Store 
WHERE SalesPersonID = @SalesPersonID

)

SELECT * FROM FnFilterStoreWith1Arg(288)

--- CREATE A FUCTION LISTING OrderDate, Bonus, Name, Description, CarrierTrackingNumber, UnitPrice. 
---Your fucntion should take four arguments and filter the data as follows: Type, Orderdate, OrderQty and CustomerId


CREATE FUNCTION 
FnFilterStoreWithMultipleArg(@Type varchar(100), @orderdate date, @OrderQty int, @CustomerId int)
RETURNS TABLE 
AS RETURN
(

	SELECT OrderDate, Bonus,Description,CarrierTrackingNumber,UnitPrice,OrderDate,CustomerID
		FROM sales.Store S

		JOIN sales.SalesPerson sp ON sp.BusinessEntityID = s.SalesPersonID

		JOIN sales.SalesOrderHeader soh ON soh.SalesPersonID = sp.BusinessEntityID

		JOIN sales.SalesOrderDetail sod ON sod.SalesOrderID = soh.SalesOrderID

		JOIN Sales.SpecialOffer so ON so.SpecialOfferID = sod.SpecialOfferID
	
		WHERE Type = @Type AND CONVERT(DATE,OrderDate) = @orderdate AND OrderDate > @OrderQty AND CustomerID = @CustomerId
)

SELECT * FROM FnFilterStoreWithMultipleArg('No Discount', '2011-05-31',40,29825)

--No Discount

2004-01-01 2020-01-01


CREATE FUNCTION 
FnCalculateEmpleyeesAge (@Date1 date, @Date2 date)
RETURNS TABLE
AS RETURN 
(
	SELECT JobTitle, DATEDIFF(YY,@Date1,@Date2) Age
	 FROM HumanResources.Employee
	 WHERE BirthDate BETWEEN @Date1 AND @Date2
)


SELECT * FROM FnCalculateEmpleyeesAge('1980-01-01','2016-01-01')

SELECT * FROM HumanResources.Employee
	2004-01-01      2019-01-01   