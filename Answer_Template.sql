--SQL Advance Case Study
use db_SQLCaseStudies


--Q1--BEGIN 

select [state] from

(select distinct State, YEAR from

	(select IDModel,
		IDCustomer,FT.IDLocation,FT.Date,TotalPrice,
		Quantity,ZipCode,Country,[State],
		City,[YEAR],[QUARTER],[MONTH] 
		
		from FACT_TRANSACTIONS as FT
		inner join DIM_LOCATION as LT
		on FT.IDLocation = Lt.IDLocation
		inner join DIM_DATE as DT
		on FT.Date = DT.DATE
	where [year] between 2005 and (select max([year]) from DIM_DATE)
	) as t1
) as tb2
group by [State]



--Q1--END

--Q2--BEGIN
	
select top 1 State, count(*) as [count of cell phones] from FACT_TRANSACTIONS as FT
inner join DIM_LOCATION as LT
on FT.IDLocation = Lt.IDLocation
inner join DIM_MODEL as MT
on FT.IDModel = MT.IDModel
inner join DIM_MANUFACTURER as MFT
on MT.IDManufacturer = MFT.IDManufacturer
where Country = 'US' and Manufacturer_Name = 'Samsung'
group by State 
order by [count of cell phones] desc



--Q2--END

--Q3--BEGIN      
	


select Model_Name, ZipCode, [State], count(*) [Number of transactions] from

(
select F_tb.IDModel, Model_Name, ZipCode,[State] from FACT_TRANSACTIONS as F_tb
inner join DIM_MODEL as M_tb
on F_tb.IDModel = M_tb.IDModel
inner join DIM_LOCATION as L_tb
on F_tb.IDLocation = L_tb.IDLocation
) as Mod_Loc_tb

group by Model_Name, ZipCode, [State]




--Q3--END

--Q4--BEGIN

select top 1 Manufacturer_Name, Model_Name, Unit_price from DIM_MODEL
inner join DIM_MANUFACTURER
on DIM_MODEL.IDManufacturer = DIM_MANUFACTURER.IDManufacturer
order by Unit_price 


--Q4--END

--Q5--BEGIN



select Model_Name, Avg(Unit_price) as [Average price of each model] from FACT_TRANSACTIONS as F_tb
inner join DIM_MODEL as M_tb
on F_tb.IDModel = M_tb.IDModel
inner join DIM_MANUFACTURER as Man_tb
on M_tb.IDManufacturer = Man_tb.IDManufacturer 

where Manufacturer_Name in                                 -- Sub-query for top 5 manufactures
							(
								select top 5 Manufacturer_Name from 
								(
								select Manufacturer_Name, sum(Quantity) as [sales quantity] from FACT_TRANSACTIONS as F_tb
								inner join DIM_MODEL as M_tb
								on F_tb.IDModel = M_tb.IDModel
								inner join DIM_MANUFACTURER as Man_tb
								on M_tb.IDManufacturer = Man_tb.IDManufacturer 
								group by Manufacturer_Name
								) as Manufact_tb
								order by [sales quantity] desc
							)

group by Model_Name
order by [Average price of each model]




--Q5--END

--Q6--BEGIN


select Customer_Name, avg(TotalPrice) as [Average_Spent] from FACT_TRANSACTIONS as FT
inner join DIM_CUSTOMER as CT
on FT.IDCustomer = CT.IDCustomer
inner join DIM_DATE as DT
on FT.Date = DT.DATE
where YEAR = 2009
group by Customer_Name
having avg(TotalPrice)>500


--Q6--END
	
--Q7--BEGIN  
	
	

select * from

(
select top 5 * from

(
select Model_Name, sum(Quantity) as [Total Qty 2008] from FACT_TRANSACTIONS as F_tb
inner join DIM_MODEL as D_tb
on F_tb.IDModel = D_tb.IDModel
inner join DIM_DATE as Date_tb
on F_tb.Date = Date_tb.DATE
where [YEAR] = 2008 
group by Model_Name
) as tb_2008

order by [Total Qty 2008] desc
) as table_08

inner join 

(
select top 5 * from

(
select Model_Name, sum(Quantity) as [Total Qty 2009] from FACT_TRANSACTIONS as F_tb
inner join DIM_MODEL as D_tb
on F_tb.IDModel = D_tb.IDModel
inner join DIM_DATE as Date_tb
on F_tb.Date = Date_tb.DATE
where [YEAR] = 2009 
group by Model_Name
) as tb_2009

order by [Total Qty 2009] desc
) as table_09

on table_08.Model_Name = table_09.Model_Name

inner join 

(
select top 5 * from

(
select Model_Name, sum(Quantity) as [Total Qty 2010] from FACT_TRANSACTIONS as F_tb
inner join DIM_MODEL as D_tb
on F_tb.IDModel = D_tb.IDModel
inner join DIM_DATE as Date_tb
on F_tb.Date = Date_tb.DATE
where [YEAR] = 2010 
group by Model_Name
) as tb_2010

order by [Total Qty 2010] desc
) as table_10

on table_09.Model_Name = table_10.Model_Name





--Q7--END	
--Q8--BEGIN



select * from

(
select top 1 * from

(
select top 2 * from 

(select Manufacturer_Name as [top second manufacturer 2009],sum(TotalPrice) as [sales of 2009] from DIM_MODEL as MO_tb
inner join DIM_MANUFACTURER MA_tb
on MO_tb.IDManufacturer = MA_tb.IDManufacturer
inner join FACT_TRANSACTIONS as F_tb
on MO_tb.IDModel = F_tb.IDModel
inner join DIM_DATE as D_tb
on F_tb.Date = D_tb.DATE
where year = 2009
group by Manufacturer_Name
) as top_manfac_tb1

order by [sales of 2009] desc
) as sales_tb1

order by [sales of 2009]
) as top2_manufact2009_tb

inner join 

(
select top 1 * from

(
select top 2 * from

(select Manufacturer_Name as [top second manufacturer 2010], sum(TotalPrice) as [sales of 2010 ] from DIM_MODEL as MO_tb
inner join DIM_MANUFACTURER MA_tb
on MO_tb.IDManufacturer = MA_tb.IDManufacturer
inner join FACT_TRANSACTIONS as F_tb
on MO_tb.IDModel = F_tb.IDModel
inner join DIM_DATE as D_tb
on F_tb.Date = D_tb.DATE
where year = 2010
group by Manufacturer_Name
) as top_manfac_tb2

order by [sales of 2010 ] desc
) as sales_tb2

order by [sales of 2010 ]
) top2_manufact2010_tb

on top2_manufact2009_tb.[top second manufacturer 2009] = top2_manufact2010_tb.[top second manufacturer 2010] or 
   top2_manufact2009_tb.[top second manufacturer 2009] <> top2_manufact2010_tb.[top second manufacturer 2010]






--Q8--END
--Q9--BEGIN
	

select tb2010.Manufacturer_Name from

(
select distinct Manufacturer_Name, YEAR from DIM_MODEL as MO_tb
inner join DIM_MANUFACTURER MA_tb
on MO_tb.IDManufacturer = MA_tb.IDManufacturer
inner join FACT_TRANSACTIONS as F_tb
on MO_tb.IDModel = F_tb.IDModel
inner join DIM_DATE as D_tb
on F_tb.Date = D_tb.DATE
where [year] = 2010 
) as tb2010

left join 

(
select distinct Manufacturer_Name, YEAR from DIM_MODEL as MO_tb
inner join DIM_MANUFACTURER MA_tb
on MO_tb.IDManufacturer = MA_tb.IDManufacturer
inner join FACT_TRANSACTIONS as F_tb
on MO_tb.IDModel = F_tb.IDModel
inner join DIM_DATE as D_tb
on F_tb.Date = D_tb.DATE
where [year] = 2009 

) as tb2009

on tb2010.Manufacturer_Name = tb2009.Manufacturer_Name
where tb2009.Manufacturer_Name is null




--Q9--END

--Q10--BEGIN	


select top 100 YEAR, Customer_name, Total_price , Avg_Amt_Spent, Avg_Quantity, Change, Ranking from 

(
select year(Date) as [YEAR],
Customer_Name,
sum(TotalPrice) as Total_price,
avg(TotalPrice) as Avg_Amt_Spent, 
avg(Quantity) as Avg_Quantity,

concat(((sum(TotalPrice)-lag(sum(TotalPrice)) over (partition by Customer_name order by Year(date)))/
lag(sum(TotalPrice)) over (partition by Customer_Name order by year(date))) * 100,'%') as [Change],
row_number() over (partition by year(date) order by sum(totalPrice) desc) as [Ranking]

from DIM_CUSTOMER as C_tb
inner join FACT_TRANSACTIONS as F_tb
on  C_tb.IDCustomer = F_tb.IDCustomer
group by YEAR(date), Customer_Name
) as [TABLE]

where [Ranking] <= 100
order by YEAR desc, Total_price desc




--Q10--END
	