--SQL Advance Case Study
--...............TO SEE COLUMN NAMES OF ALL TABLES................
SELECT TOP 1 * FROM DIM_CUSTOMER;
SELECT TOP 1 * FROM DIM_DATE;
SELECT TOP 1 * FROM DIM_LOCATION;
SELECT TOP 1 * FROM DIM_MANUFACTURER;
SELECT TOP 1 * FROM DIM_MODEL;
SELECT TOP 1 * FROM FACT_TRANSACTIONS;

--Q1. List all the states in which we have customers who have bought cellphones from 2005 till today.
--Q1--BEGIN 
SELECT TOP 1 * FROM DIM_LOCATION;
SELECT TOP 1 * FROM FACT_TRANSACTIONS;

/*select * from fact_transactions
WHERE DATE > '2005-01-01' AND DATE <= GETDATE()
SELECT GETDATE() AS CURRENT_DATE_
*/

SELECT DISTINCT State, FT.Date
FROM DIM_LOCATION AS L 
JOIN
FACT_TRANSACTIONS AS FT
ON L.IDLocation=FT.IDLocation
WHERE ( FT.Date >'01-01-2005' AND FT.Date <= GETDATE()) 
ORDER BY FT.DATE;

--=========================================
--RE-SUBMISSION ANSWER
-- (DATE) is removed from SELECT & ORDER BY clause.
--=========================================
SELECT DISTINCT State
FROM DIM_LOCATION AS L 
JOIN
FACT_TRANSACTIONS AS FT
ON L.IDLocation=FT.IDLocation
WHERE ( FT.Date >'01-01-2005' AND FT.Date <= GETDATE()) 
ORDER BY STATE;

--Q1--END

--Q2 What state in the US is buying the most 'Samsung' cell phones?
--Q2--BEGIN
SELECT TOP 1 * FROM DIM_LOCATION;
SELECT TOP 1 * FROM DIM_MANUFACTURER;
SELECT TOP 1 * FROM DIM_MODEL;
SELECT TOP 1 * FROM FACT_TRANSACTIONS;	

/*SELECT DISTINCT State, COUNTRY
FROM DIM_LOCATION AS DL
WHERE DL.Country='US'
*/

SELECT TOP 1 DMF.MANUFACTURER_NAME,L.COUNTRY,L.STATE,SUM(FT.QUANTITY)AS CNT_
FROM 
FACT_TRANSACTIONS AS FT
JOIN DIM_LOCATION AS L ON FT.IDLOCATION=L.IDLOCATION
JOIN DIM_MODEL AS DMO ON FT.IDMODEL=DMO.IDMODEL
JOIN DIM_MANUFACTURER AS DMF ON DMO.IDMANUFACTURER=DMF.IDMANUFACTURER
WHERE L.COUNTRY='US' AND DMF.MANUFACTURER_NAME='SAMSUNG'
GROUP BY DMF.MANUFACTURER_NAME,L.COUNTRY,L.STATE
ORDER BY CNT_ DESC;
--Q2--END

--Q3. Show the number of transactions for each model per zip code per state.
--Q3--BEGIN      
SELECT TOP 1 * FROM DIM_LOCATION;	
SELECT TOP 1 * FROM DIM_MODEL;
SELECT TOP 1 * FROM FACT_TRANSACTIONS;	

SELECT L.State,L.ZIPCODE,DML.MODEL_NAME,count(ft.date) as cnt_transaction
FROM 
FACT_TRANSACTIONS AS FT
JOIN DIM_LOCATION AS L ON FT.IDLOCATION=L.IDLOCATION
JOIN DIM_MODEL AS DML ON FT.IDMODEL=DML.IDMODEL
group by dmL.model_name,l.state,l.zipcode
--Q3--END

-- Q4 Show the cheapest cellphone (Output should contain the price also
--Q4--BEGIN
SELECT TOP 1 DMF.Manufacturer_Name , DML.Model_Name , MIN(DML.UNIT_PRICE) AS PRICE_
FROM DIM_MANUFACTURER AS DMF
JOIN
DIM_MODEL AS DML
ON DMF.IDManufacturer=DML.IDManufacturer
GROUP BY DMF.Manufacturer_Name , DML.Model_Name; 
--Q4--END

--Q5 Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price.
--Q5--BEGIN
SELECT TOP 5 DMF.MANUFACTURER_NAME,SUM(FT.QUANTITY) AS S_QTY,AVG(FT.TOTALPRICE) AS AVG_SALES
FROM 
DIM_MANUFACTURER AS DMF
JOIN DIM_MODEL AS DML ON DMF.IDMANUFACTURER=DML.IDMANUFACTURER
JOIN FACT_TRANSACTIONS AS FT ON FT.IDMODEL=DML.IDMODEL
GROUP BY DMF.MANUFACTURER_NAME
ORDER BY AVG_SALES;

--=========================================
--RE-SUBMISSION ANSWER
-- Use of Subquery is there.
--=========================================
SELECT model_name
FROM DIM_MODEL
WHERE exists(
SELECT TOP 5 DMO.IDMANUFACTURER,SUM(FT.QUANTITY) AS S_QTY,AVG(FT.TOTALPRICE) AS AVG_SALES
FROM 
DIM_MANUFACTURER AS DMN
JOIN DIM_MODEL AS DMO ON DMN.IDMANUFACTURER=DMO.IDMANUFACTURER
JOIN FACT_TRANSACTIONS AS FT ON FT.IDMODEL=DMO.IDMODEL
GROUP BY DMN.MANUFACTURER_NAME, DMO.IDMANUFACTURER                                                                 
ORDER BY AVG_SALES)

--Q5--END

--Q6 List the names of the customers and the average amount spent in 2009, where the average is higher than 500
--Q6--BEGIN
SELECT DC.Customer_Name, FT.DATE, AVG(FT.TOTALPRICE) AS AVG_SALES
FROM DIM_CUSTOMER AS DC
JOIN 
FACT_TRANSACTIONS AS FT
ON DC.IDCustomer=FT.IDCustomer
WHERE FT.Date>='2009-01-01' AND FT.Date<'2010-01-01'
GROUP BY DC.Customer_Name , FT.Date
HAVING  AVG(FT.TOTALPRICE)>500;

--=========================================
--RE-SUBMISSION ANSWER
-- (DATE) is removed from SELECT & GROUP BY clause.
-- ORDER BY clause is added in query.
--=========================================

SELECT DC.Customer_Name,AVG(FT.TOTALPRICE) AS AVG_SALES
FROM DIM_CUSTOMER AS DC
JOIN 
FACT_TRANSACTIONS AS FT
ON DC.IDCustomer=FT.IDCustomer
WHERE FT.Date>='2009-01-01' AND FT.Date<'2010-01-01'
GROUP BY DC.Customer_Name
HAVING  AVG(FT.TOTALPRICE)>500
ORDER BY DC.Customer_Name;


--Q6--END

--Q7 .List if there is any model that was in the top 5 in terms of quantity ,simultaneously in 2008, 2009 and 2010	
--Q7--BEGIN  
SELECT TOP 5 DML.idmodel,
COUNT(ft.quantity) AS total_quantity,DML.model_name
FROM
DIM_MODEL AS DML
JOIN
FACT_TRANSACTIONS AS FT ON FT.IDMODEL=DML.IDMODEL
WHERE
year(ft.date) IN (2008, 2009, 2010)
GROUP BY ft.quantity,DML.idmodel,DML.model_name
ORDER BY total_quantity DESC;	

--=========================================
--RE-SUBMISSION ANSWER
--Use of RANK() and PARTITION BY () and INTERSECTION  is there .
--=========================================
SELECT model_name
FROM (
    SELECT model_name, RANK() OVER (PARTITION BY (FT.DATE) ORDER BY quantity DESC) AS rank
    FROM DIM_MODEL AS DML
       JOIN FACT_TRANSACTIONS AS FT ON FT.IDMODEL=DML.IDMODEL
    WHERE year(ft.date)=2008
) AS top_models_2008
INTERSECT
SELECT model_name AS top_models_2009
FROM (
    SELECT model_name, RANK() OVER (PARTITION BY  (FT.DATE) ORDER BY quantity DESC) AS rank
    FROM DIM_MODEL AS DML
       JOIN FACT_TRANSACTIONS AS FT ON FT.IDMODEL=DML.IDMODEL
    WHERE year(ft.date)=2009
) AS top_models_2009
INTERSECT
SELECT model_name AS top_models_2010
FROM (
    SELECT model_name, RANK() OVER (PARTITION BY (FT.DATE) ORDER BY quantity DESC) AS rank
 FROM DIM_MODEL AS DML
       JOIN FACT_TRANSACTIONS AS FT ON FT.IDMODEL=DML.IDMODEL
    WHERE year(ft.date)=2010
     ) AS top_models_2010

--Q7--END	

--Q8 Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.
--Q8--BEGIN

SELECT TOP 2 manufacturer_name,SUM(totalprice) AS total_sales
FROM
  fact_transactions AS FT
JOIN
  dim_model AS DML
ON
  FT.idmodel = DML.idmodel
 JOIN
  dim_manufacturer AS DMF
ON
  DML.idmanufacturer = DMF.idmanufacturer
WHERE
  year(date) IN (2009) OR YEAR(DATE)IN (2010)
GROUP BY
  DMF.manufacturer_name
ORDER BY
  total_sales DESC;

  --=========================================
--RE-SUBMISSION ANSWER
--Insted of Manufacturer; MODEL NAME is used in SELECT & GROUP BY clause.
--=========================================
SELECT TOP 2 DML.model_name,SUM(totalprice) AS total_sales
FROM
  fact_transactions AS FT
 JOIN
  dim_model AS DML
ON
  fT.idmodel = DML.idmodel
 JOIN
  dim_manufacturer AS DMF
ON
  DML.idmanufacturer = DMF.idmanufacturer
WHERE
  year(date) IN (2009) OR YEAR(DATE)IN (2010)--
GROUP BY
  DML.model_name
ORDER BY
  total_sales DESC

--Q8--END

--Q9. Show the manufacturers that sold cellphones in 2010 but did not in 2009.
--Q9--BEGIN

SELECT  manufacturer_name,SUM(totalprice) AS total_sales,YEAR(DATE) AS YEAR_DATE
FROM
fact_transactions AS FT
JOIN
dim_model AS DML
ON
 FT.idmodel = DML.idmodel
JOIN
dim_manufacturer AS DMF
ON
DML.idmanufacturer = DMF.idmanufacturer
WHERE year(date) IN (2010) AND YEAR(DATE) NOT IN (2009)--
GROUP BY
DMF.manufacturer_name,YEAR(DATE)
ORDER BY
total_sales DESC;

--Q9--END

--Q10. Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend
--Q10--BEGIN
select top 100
CUS.IDCUSTOMER,
YEAR(FT.DATE) AS YEAR_,
AVG(FT.TOTALPRICE)as avg_spend,LAG(AVG(FT.TOTALPRICE), 1) OVER (PARTITION BY CUS.idcustomer ORDER BY YEAR(FT.DATE)) as lag_avg_spend,
avg(ft.quantity) AS average_quantity,
AVG(FT.TOTALPRICE) - LAG(AVG(FT.TOTALPRICE), 1) OVER (PARTITION BY CUS.idcustomer ORDER BY YEAR(FT.DATE)) AS change_in_spend,
LAG(AVG(TOTALPRICE), 1) OVER 
(PARTITION BY CUS.idcustomer ORDER BY YEAR(FT.DATE)) as deno_,
((AVG(FT.TOTALPRICE) - (LAG(AVG(FT.TOTALPRICE), 1) OVER (PARTITION BY CUS.idcustomer ORDER BY YEAR(FT.DATE))))/(LAG(AVG(TOTALPRICE), 1) OVER 
(PARTITION BY CUS.idcustomer ORDER BY YEAR(FT.DATE))))*100 AS percentage_change_in_spend
FROM
FACT_TRANSACTIONS AS FT
INNER JOIN
DIM_CUSTOMER AS CUS
ON
FT.IDCUSTOMER=CUS.IDCUSTOMER
group by ft.date,cus.idcustomer
order by cus.idcustomer;

-- LAG() is used here.
--Q10--END
	