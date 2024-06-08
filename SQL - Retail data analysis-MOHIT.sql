CREATE DATABASE RETAIL_CASESTUDY;

USE RETAIL_CASESTUDY;

/* NOW I'LL BE IMPORTING FILES.... SEE DATA SCHEMA WHICH TABLE IS DEPENDENT/ INDEPENDENT.
AFTER IMPORTING FILES I CHECKED THEM BY REFRESHING THE DATABASE */
--OR BY
SELECT*
FROM CUSTOMER; -- TOTALS ROWS 5647
SELECT*
FROM prod_cat_info; -- TOTALS ROWS 23
SELECT*
FROM TRANSACTIONS; -- TOTALS ROWS 23053

/* SET PK AND FK ,,,,SET CARDINALITY.....TAKE HELP OF DATA SCHEMA.
NOTE: IM NOT ABLE TO SET PK&FK....DO ASK SOMEONE*/

--NOW WE ARE GOOD TO GO FOR FUTHER QUESTIONS.

----------------------------DATA PREPARATION AND UNDERSTANDING----------------------------

--Q1. What is the total number of rows in each of the 3 tables in the database?
SELECT COUNT(*) AS Total_number_of_rows
FROM CUSTOMER;
SELECT COUNT(*) AS Total_number_of_rows
FROM prod_cat_info;
SELECT COUNT(*) AS Total_number_of_rows
FROM TRANSACTIONS;

--BUT I NEED THEM IN A SINGLE OUTPUT
SELECT COUNT(*) AS Total_number_of_rows
FROM CUSTOMER
UNION
SELECT COUNT(*) 
FROM prod_cat_info
UNION
SELECT COUNT(*) 
FROM TRANSACTIONS;

--OR 
SELECT 'CUSTOMER' AS TABLE_NAME,
COUNT(*) AS Total_number_of_rows
FROM CUSTOMER
UNION
SELECT 'prod_cat_info',
COUNT(*) 
FROM prod_cat_info
UNION
SELECT 'TRANSACTIONS',
COUNT(*) 
FROM TRANSACTIONS;
-------------------------------THEREFORE FOR A SINGLE QUERY THERE CAN BE MULTIPLE WAYS TO WRITE ,,,,,THING TO REMMEMBER IS WHICH IS TIME EFFICIENT------------

--Q2.	What is the total number of transactions that have a return?-----return means items sold but returned later.
SELECT COUNT(*)AS TOTAL_RETURN_TARNSACTIONS
FROM TRANSACTIONS
WHERE QTY<0;

--Q3.	As you would have noticed, the dates provided across the datasets are not in a correct format. As first steps, pls convert the date variables into valid date formats before proceeding ahead.
--DATE IS IN PROPER FORMAT,,,,,BUT IF WANT TO REMOVES THOES ZEROES THEN,
SELECT CONVERT(DATE,DOB,120) AS DATES
FROM CUSTOMER;
--AND
SELECT CONVERT(DATE,TRAN_DATE,120) AS DATES
FROM Transactions;
--NOW IF WE CHECK
SELECT * FROM Customer;
SELECT * FROM Transactions;
----ITS NOT SHOWING ANY CHANGES WHY????????????????????????????????????????

/*--Q4.	What is the time range of the transaction data available for analysis?
Show the output in number of days, months and years simultaneously in different columns.
*/

SELECT
DATEDIFF(YEAR,MIN(TRAN_DATE),Max(tran_date))as YEAR_RANGE,
DATEDIFF(month,MIN(TRAN_DATE),Max(tran_date))as MONTH_RANGE,
DATEDIFF(day,MIN(TRAN_DATE),Max(tran_date))as DAY_RANGE
FROM Transactions;

--Q5.	Which product category does the sub-category “DIY” belong to?
SELECT prod_cat, prod_sub_cat_code
FROM prod_cat_info
WHERE prod_subcat='DIY';

------------------------------------------------DATA ANALYSIS--------------------------------------------------

--Q1 Which channel is most frequently used for transactions?
SELECT*
FROM TRANSACTIONS;

SELECT STORE_TYPE AS CHANNELS,
COUNT(STORE_TYPE) AS INDIVIDUAL_TRANSACTIONS
FROM Transactions
GROUP BY Store_type
ORDER BY Store_type;
-- THEREFORE E-SHOP HAS MAX. TRANSACTIONS OF 9311.

--Q2 What is the count of Male and Female customers in the database?
SELECT * FROM Customer;

SELECT GENDER, COUNT(GENDER) AS GENDER_COUNT
FROM Customer
WHERE GENDER IS NOT NULL
GROUP BY GENDER 
ORDER BY GENDER DESC;

--Q3 From which city do we have the maximum number of customers and how many?
SELECT city_code,COUNT(city_code) AS MAX_CUSTOMERS_CITY
FROM Customer
GROUP BY city_code
ORDER BY COUNT(city_code) DESC;
--ORDER BY MAX_CUSTOMERS_CITY DESC;
------NOTE= THIS WILL GIVE US A LIST OF ALL CITIES CORRESPONDENCE TO ITS MAX CUSTOMERS......BUT IF WE NEED ONLY 1 CITY WITH MAX. CUSTOMERS THEN FOLLOWING CODE WILL WORK.
SELECT TOP 1 city_code,COUNT(city_code) AS MAX_CUSTOMERS_CITY
FROM Customer
GROUP BY city_code
ORDER BY COUNT(city_code) DESC;
-- HERE WE USED (TOP 1) KEYWORD FOR RETURNING THE TOP FIRST ROW OF THE RESULT SET...ie, RESULT OF (((COUNT(CITY_CODE)))))

--Q4. How many sub-categories are there under the Books category?
SELECT*
FROM prod_cat_info;

--SHOWS TOTAL NO. OF SUB CATEGORIES.
SELECT  prod_cat, COUNT(prod_subcat) AS SUB_CATERGORIES
FROM PROD_CAT_INFO
WHERE prod_cat='BOOKS'
GROUP BY prod_cat;

--SHOWS LIST OF SUB CATEGORIES.
SELECT prod_cat, prod_subcat
FROM prod_cat_info
WHERE prod_cat='BOOKS';

--Q5 What is the maximum quantity of products ever ordered?
SELECT*
FROM TRANSACTIONS;
--SHOWS MAX QUANTITY OF ORDERS CATEGORY WISE LIST.
SELECT prod_cat_code , COUNT(QTY) AS MAX_QUANTITY_ORDERD
FROM TRANSACTIONS
GROUP BY prod_cat_code
ORDER BY MAX_QUANTITY_ORDERD DESC;

--SHOWS MAX_QUANTITY_PRODUCT CAN BE EVER ORDER....ie, WE CANT ORDER A PRODUCT MORE THAN 5 IN QUANTITY.   5 IS THE LIMIT OF QUANTITY OF AN ORDER .
SELECT prod_cat_code ,MAX(QTY) AS MAX_QUANTITY_PRODUCT
FROM TRANSACTIONS
WHERE Qty>0
GROUP BY prod_cat_code
ORDER BY prod_cat_code;

--Q6 What is the net total revenue generated in categories Electronics and Books?
SELECT*
FROM TRANSACTIONS;
SELECT*
FROM prod_cat_info;
--HERE 2 TABLES ARE REQUIRED 1 HOLDS CODE AND ANOTHER HOLDS AMOUNT.

--FOLLOWING CODE SHOWS THE CODE AGAINST (ELECTRONICS) AND (BOOKS) 
SELECT prod_cat,prod_sub_cat_code
FROM prod_cat_info
WHERE prod_cat IN ('ELECTRONICS','BOOKS');

---HERE THIS CODE IS 2 TABLES ARE USED WITH THE HELP OF SUBQUERY .NOTE= ABOVE CODE IS USED AS SUBQUERY SEE CAREFULLY.
SELECT SUM(TOTAL_AMT) AS TOTAL_REVENUE
FROM TRANSACTIONS
WHERE prod_cat_code IN 
(
SELECT prod_cat_code
FROM prod_cat_info
WHERE prod_cat IN ('ELECTRONICS','BOOKS')
);

--Q7 How many customers have >10 transactions with us, excluding returns?
SELECT*
FROM TRANSACTIONS;

--SHOWS ((LIST)) OF CUSTOMERS HAVING MORE THAN 10 TRANSACTIONS.
SELECT cust_id , COUNT(DISTINCT (transaction_id)) AS TRANSACTIONS
FROM TRANSACTIONS
WHERE Qty>0
GROUP BY CUST_ID
HAVING COUNT(DISTINCT transaction_id)>10;

--SHOWS TOTAL CUSTOMERS ONLY ,,,..,.,.,,,, SUB QUERY IN (FROM)
SELECT COUNT (*) AS TOTAL_CUSTOMER
FROM(
SELECT cust_id , COUNT(DISTINCT (transaction_id)) AS TRANSACTIONS
FROM TRANSACTIONS
WHERE Qty>0
GROUP BY CUST_ID
HAVING COUNT(DISTINCT transaction_id)>10) AS SUB_QUERY;

--Q8  What is the combined revenue earned from the “Electronics” & “Clothing” categories, from “Flagship stores”?
----------------SAME AS Q6 ............SORT OFF,,,,,,,,,,,,,,......!!!!
SELECT*
FROM TRANSACTIONS;
SELECT*
FROM prod_cat_info;
--HERE 2 TABLES ARE REQUIRED 1 HOLDS CODE AND ANOTHER HOLDS AMOUNT.

/*--FOLLOWING CODE SHOWS THE CODE AGAINST (ELECTRONICS) AND (CLOTHING) 
SELECT prod_cat,prod_sub_cat_code
FROM prod_cat_info
WHERE prod_cat IN ('ELECTRONICS','CLOTHING');
*/

---HERE THIS CODE IS 2 TABLES ARE USED WITH THE HELP OF SUBQUERY .NOTE= ABOVE CODE IS USED AS SUBQUERY SEE CAREFULLY.
SELECT  SUM(TOTAL_AMT) AS TOTAL_REVENUE
FROM TRANSACTIONS
WHERE STORE_TYPE = 'FLAGSHIP STORE' AND prod_cat_code IN (SELECT prod_cat_code FROM prod_cat_info WHERE prod_cat IN ('ELECTRONICS','CLOTHING'));

--Q9 What is the total revenue generated from “Male” customers in “Electronics” category? Output should display total revenue by prod sub-cat.
SELECT*
FROM CUSTOMER; 
SELECT*
FROM prod_cat_info;
SELECT*
FROM TRANSACTIONS;

/*SELECT  DISTINCT customer_Id AS ALL_MALE_CUSTOMERS
FROM Customer
WHERE Gender='M';

SELECT prod_cat,prod_sub_cat_code
FROM prod_cat_info
WHERE prod_cat IN ('ELECTRONICS');
*/
----------------------BY USE OF JOINS,,,,,,,,,,,,,,,,,,,

SELECT Gender,SUM(TOTAL_AMT) AS REVENUE
FROM Customer AS C
RIGHT JOIN Transactions AS T
ON C.customer_Id=T.cust_id
WHERE Gender='M' AND prod_cat_code IN
(SELECT prod_cat_CODE
FROM prod_cat_info
WHERE prod_cat ='ELECTRONICS')
GROUP BY Gender; 

--Q10  What is percentage of sales and returns by product sub category; display only top 5 sub categories in terms of sales?
 
	SELECT*
	FROM prod_cat_info;
	SELECT*
	FROM TRANSACTIONS;
/*............................................STEP BY STEP APPROACH.................................
	SELECT SUM(TOTAL_AMT) AS SALES
	FROM Transactions
	WHERE total_amt>0

	SELECT SUM(TOTAL_AMT) AS RETURN_SALES
	FROM Transactions
	WHERE total_amt<0

	SELECT SUM(TOTAL_AMT)*100/(SELECT SUM(TOTAL_AMT) FROM Transactions WHERE total_amt>0) AS SALES_PERCENT 
	FROM Transactions AS T

	SELECT SUM(TOTAL_AMT)*100/(SELECT SUM(TOTAL_AMT) FROM Transactions WHERE total_amt<0) AS RETURN_SALES_PERCENT
	FROM Transactions AS T
*/

	SELECT  TOP 5 PCI.prod_subcat,
	SUM(TOTAL_AMT)*100/(SELECT SUM(TOTAL_AMT) AS SALES FROM Transactions WHERE total_amt>0) AS SALES_PERCENT,
	SUM(TOTAL_AMT)*100/(SELECT SUM(TOTAL_AMT) FROM Transactions WHERE total_amt<0) AS RETURN_SALES_PERCENT
	FROM Transactions AS T
	JOIN
	prod_cat_info AS PCI
	ON PCI.prod_sub_cat_code=T.prod_subcat_code
	AND 
	PCI.prod_cat_code=T.prod_cat_code
	GROUP BY PCI.prod_subcat
	ORDER BY PCI.prod_subcat DESC ;

/*Q11  For all customers aged between 25 to 35 years 
find what is the net total revenue generated by these consumers in last 30 days of transactions 
from max transaction date available in the data?
*/
SELECT*
FROM CUSTOMER; 
SELECT*
FROM prod_cat_info;
SELECT*
FROM TRANSACTIONS;

SELECT DATEDIFF(YEAR,DOB,MAX(TRAN_DATE))as AGE_,T.CUST_ID,T.TOTAL_AMT
FROM TRANSACTIONS AS T
JOIN 
CUSTOMER AS C
ON T.CUST_ID=C.CUSTOMER_ID
WHERE (TRAN_DATE>=(SELECT DATEADD(DAY,-30,MAX(TRAN_DATE)) AS CUTOFF FROM TRANSACTIONS)) and Qty>0

GROUP BY C.DOB,T.CUST_ID,TOTAL_AMT
HAVING DATEDIFF(YEAR,DOB,MAX(TRAN_DATE)) BETWEEN 25 AND 35

--Q12 	Which product category has seen the max value of returns in the last 3 months of transactions?
SELECT*
FROM prod_cat_info;
SELECT*
FROM TRANSACTIONS;

SELECT top 1 PCI.PROD_CAT,SUM(T.TOTAL_AMT) AS REVENUE_
FROM TRANSACTIONS AS T
JOIN 
PROD_CAT_INFO AS PCI
ON T.PROD_CAT_CODE= PCI.PROD_CAT_CODE
AND
T.PROD_SUBCAT_CODE=PCI.PROD_SUB_CAT_CODE
WHERE T.TRAN_DATE >= (SELECT DATEADD(MONTH,-3,MAX(TRAN_DATE))AS DATE_ FROM Transactions)
AND 
T.QTY<0 
GROUP BY PCI.PROD_CAT;

--Q13 Which store-type sells the maximum products; by value of sales amount and by quantity sold?

SELECT * FROM Transactions;

SELECT TOP 1 STORE_TYPE,COUNT(PROD_CAT_CODE) AS COUNT_,SUM(TOTAL_AMT) AS TOTAL_SALES
FROM TRANSACTIONS
WHERE QTY>0
GROUP BY Store_type
ORDER BY 3 DESC;

--Q14 What are the categories for which average revenue is above the overall average.
SELECT*
FROM prod_cat_info;
SELECT*
FROM TRANSACTIONS;

/*..........OVERALL REVENUE .......
SELECT AVG(TOTAL_AMT) AS OVER_ALL_AVG 
FROM Transactions ;
*/

SELECT PCI.PROD_CAT AS PRODUCT_CAYERGORY, AVG(T.TOTAL_AMT)AS INDIVIDUAL_AVG 
FROM TRANSACTIONS AS T
JOIN 
PROD_CAT_INFO AS PCI
ON T.PROD_CAT_CODE= PCI.PROD_CAT_CODE
AND
T.PROD_SUBCAT_CODE=PCI.PROD_SUB_CAT_CODE
GROUP BY PROD_CAT
HAVING AVG(T.TOTAL_AMT)>(SELECT AVG(TOTAL_AMT) FROM Transactions)
ORDER BY 2 DESC;

--Q15 Find the average and total revenue by each subcategory for the categories which are among top 5 categories in terms of quantity sold.
SELECT*
FROM prod_cat_info;
SELECT*
FROM TRANSACTIONS;

/*.............TOP 5 CATEGORIES.............
SELECT TOP 5 PCI.PROD_CAT
FROM Transactions as t
JOIN PROD_CAT_INFO AS PCI
ON T.PROD_CAT_CODE= PCI.PROD_CAT_CODE
AND
T.PROD_SUBCAT_CODE=PCI.PROD_SUB_CAT_CODE
where Qty>0
*/

SELECT PCI.PROD_CAT, AVG(T.TOTAL_AMT) AS AVG_SALES, SUM(T.TOTAL_AMT) AS TOTAL_REVENUE
FROM TRANSACTIONS AS T
JOIN PROD_CAT_INFO AS PCI
ON T.PROD_CAT_CODE= PCI.PROD_CAT_CODE
AND
T.PROD_SUBCAT_CODE=PCI.PROD_SUB_CAT_CODE
WHERE QTY>0 AND PROD_CAT IN 
(SELECT TOP 5 PCI.PROD_CAT
FROM Transactions as t
JOIN PROD_CAT_INFO AS PCI
ON T.PROD_CAT_CODE= PCI.PROD_CAT_CODE
AND
T.PROD_SUBCAT_CODE=PCI.PROD_SUB_CAT_CODE
where Qty>0)
GROUP BY prod_cat
ORDER BY 2 DESC;

