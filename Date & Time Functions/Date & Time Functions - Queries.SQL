/*###################
  Date Values
######################*/
SELECT
OrderID,
CreationTime,
'2025-08-20' HardCoded,
GETDATE() Today
FROM Sales.Orders


/*###################
  Date Part Extractions
######################*/

SELECT
OrderID,
CreationTime,
-- DATETRUNC Examples
DATETRUNC(year, CreationTime) Year_dt,
DATETRUNC(day, CreationTime) Day_dt,
DATETRUNC(minute, CreationTime) Minute_dt,
-- DATENAME Examples
DATENAME(month, CreationTime) Month_dn,
DATENAME(weekday, CreationTime) Weekday_dn,
DATENAME(day, CreationTime) Day_dn,
DATENAME(year, CreationTime) Year_dn,
-- DATEPART Examples
DATEPART(year, CreationTime) Year_dp,
DATEPART(month, CreationTime) Month_dp,
DATEPART(day, CreationTime) Day_dp,
DATEPART(hour, CreationTime) Hour_dp,
DATEPART(quarter, CreationTime) Quarter_dp,
DATEPART(week, CreationTime) Week_dp,
YEAR(CreationTime) Year,
MONTH(CreationTime) Month,
DAY(CreationTime) Day
FROM Sales.Orders


/*###################
  DATETRUNC Data Aggregation
######################*/
SELECT
DATETRUNC(year,CreationTime) Creation,
COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(year,CreationTime) 


-- ####################################################################### 
 -- DATE PARTS (Use Cases)
 -- ####################################################################### 

--How many orders were placed each year?
SELECT YEAR(OrderDate) Month, COUNT(*) TotalOrders
From Sales.Orders
GROUP BY YEAR(OrderDate)

--How many orders were placed each month?
SELECT MONTH(OrderDate) Month, COUNT(*) TotalOrders
From Sales.Orders
GROUP BY MONTH(OrderDate)

--How many orders were placed each month? (Friendly Names)
SELECT
DATENAME(month, OrderDate) AS OrderDate,
COUNT(*) NrOfOrders
FROM Sales.Orders
GROUP BY DATENAME(month, OrderDate)

-- Filter Data based on specific  year, month, day
-- Show all orders that were placed during the month of February
SELECT
*
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2

-----------------------------------------------------------------------------------

/*###################
  FORMAT
######################*/
SELECT
OrderID,
CreationTime,
FORMAT(CreationTime, 'MM-dd-yyyy') USA_Format,
FORMAT(CreationTime, 'dd-MM-yyyy') EURO_Format,
FORMAT(CreationTime, 'dd') dd,
FORMAT(CreationTime, 'ddd') ddd,
FORMAT(CreationTime, 'dddd') dddd,
FORMAT(CreationTime, 'MM') MM,
FORMAT(CreationTime, 'MMM') MMM,
FORMAT(CreationTime, 'MMMM') MMMM
FROM Sales.Orders

-- Show CreationTime using the following format:
-- Day Wed Jan Q1 2025 12:34:56 PM
SELECT
OrderID,
CreationTime,
'Day ' + FORMAT(CreationTime, 'ddd MMM') +
' Q'+ DATENAME(quarter, CreationTime) + ' ' +
FORMAT(CreationTime, 'yyyy hh:mm:ss tt') AS CustomeFormat
FROM Sales.Orders

/*###################
  CONVERT
######################*/
SELECT
CONVERT(INT, '123') AS [String to Int CONVERT],
CONVERT(DATE, '2025-08-20') AS [String to Date CONVERT],
CreationTime,
CONVERT(DATE, CreationTime) AS [Datetime to Date CONVERT],
CONVERT(DATE, CreationTime) AS [Datetime to Date CONVERT],
CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
CONVERT(VARCHAR, CreationTime, 34) AS [EURO Std. Style:34]
FROM Sales.Orders

/*###################
  CAST
######################*/
SELECT
CAST('123' AS INT) AS [String to Int],
CAST(123 AS VARCHAR) AS [Int to String],
CAST('2025-08-20' AS DATE) AS [String to Date],
CAST('2025-08-20' AS DATETIME2) AS [String to Datetime],
CreationTime,
CAST(CreationTime AS DATE) AS [Datetime to Date]
FROM Sales.Orders

-----------------------------------------------------------------------------------

 -- ####################################################################### 
 -- Date Calculations (Use Cases)
 -- ####################################################################### 

SELECT
OrderID,
OrderDate,
DATEADD(day, -10, OrderDate) AS TenDaysBefore,
DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM Sales.Orders

-- Calculate the age of employees
SELECT
EmployeeID,
BirthDate,
DATEDIFF(year, BirthDate, GETDATE()) Age
FROM Sales.Employees

-- Find the average shipping duration in days for each month
SELECT
MONTH(OrderDate) AS OrderDate,
AVG(DATEDIFF(day, OrderDate, ShipDate)) AvgShip
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- Time Gap Analysis
-- Find the number of days between each order and the previous order
SELECT
OrderID,
OrderDate CurrentOrderDate,
LAG(OrderDate) OVER (ORDER BY OrderDate) PreviousOrderDate,
DATEDIFF(day, LAG(OrderDate) OVER (ORDER BY OrderDate), OrderDate)NrOfDays
FROM Sales.Orders

-----------------------------------------------------------------------------------

/*###################
  ISDATE
######################*/
SELECT
ISDATE('2025-08-20'),
ISDATE('2025'),
ISDATE(20250820),
ISDATE(8),
ISDATE(OrderDate)
FROM Sales.Orders


SELECT
	--CAST(OrderDate AS DATE) OrderDate,
	OrderDate,
	ISDATE(OrderDate),
	CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
		 ELSE '9999-01-01'
	END NewOrderDate
FROM
(
	SELECT '2025-08-20' AS OrderDate UNION
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08' 
)t
--WHERE ISDATE(OrderDate) = 0
