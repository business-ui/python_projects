USE funding_solution_production;

SELECT 
i_name as ISO,
Relationship_Manager,
CONCAT(Yi,"/",Mi) as yearmonth,
IFNULL(TOTAL_SUBMITTED,0) AS TOTAL_SUBMITTED,
IFNULL(TOTAL_APPROVED,0) AS TOTAL_APPROVED,
IFNULL(TOTAL_FUNDED,0) AS TOTAL_FUNDED,
IFNULL(TOTAL_DECLINED,0) AS TOTAL_DECLINED,
IFNULL(AVERAGE_APPROVAL_AMOUNT,0) AS AVERAGE_APPROVAL_AMOUNT,
IFNULL(AVERAGE_FUNDED_AMOUNT,0) AS AVERAGE_FUNDED_AMOUNT,
IFNULL(LARGEST_FUNDED_AMOUNT,0) AS LARGEST_FUNDED_AMOUNT,
IFNULL(SMALLEST_FUNDED_AMOUNT,0) AS SMALLEST_FUNDED_AMOUNT,
IFNULL(TOTAL_APPROVED_AMOUNT,0) AS TOTAL_APPROVED_AMOUNT,
IFNULL(TOTAL_FUNDED_AMOUNT,0) AS TOTAL_FUNDED_AMOUNT,
LATEST_SUBMISSION,
LATEST_FUNDED,
EARLIEST_SUBMISSION,
EARLIEST_FUNDED_DATE,
TOTAL_FUNDED/TOTAL_SUBMITTED,
TOTAL_APPROVED/TOTAL_SUBMITTED,
TOTAL_DECLINED/TOTAL_SUBMITTED,
TOTAL_FUNDED/TOTAL_APPROVED,
created_at as Sign_up_date
FROM

	(SELECT DISTINCT isos.name as i_name,isos.id AS i_id,b.name as Relationship_Manager,isos.created_at,YEAR(deals.created_at) as Yi,MONTH(deals.created_at) as Mi
	FROM isos
	JOIN users a ON isos.id=a.organization_id
	LEFT JOIN users b ON isos.relationship_manager_id = b.id
	JOIN deals ON deals.sales_rep_id = a.id 
 
	) AS ISOS_table

LEFT JOIN
	
/* TOTAL_SUBMITTED */
	(SELECT isos.id as i_id, 
		YEAR(deals.created_at) as ts_year, 
		MONTH(deals.created_at) as ts_month,
	    count(deals.id) as TOTAL_SUBMITTED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id =users.organization_id
	group by i_id,ts_year,ts_month
	) AS TOTAL_SUBMITTED

ON TOTAL_SUBMITTED.i_id=ISOS_table.i_id and ts_year=Yi and ts_month=Mi
LEFT JOIN

/* TOTAL_APPROVED */
	(SELECT isos.id,
			YEAR(deals.created_at) as ta_year,
			MONTH(deals.created_at) as ta_month,
		    count(deals.id) as TOTAL_APPROVED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where 
	deals.status IN ('Approved','Contracts Back','Contract Sent','Soft Approval','Ready to Fund','Lost Deal','Contract Returned','Funding Call','Open Approval','Funded')
	group by isos.id, ta_year, ta_month
	) AS TOTAL_APPROVED

ON ISOS_table.i_id=TOTAL_APPROVED.id AND TOTAL_APPROVED.ta_year=Yi AND TOTAL_APPROVED.ta_month=Mi
LEFT JOIN

/* TOTAL_FUNDED */
	(SELECT isos.id,
			YEAR(deals.created_at) as tf_year,
			MONTH(deals.created_at) as tf_month,
		 	count(deals.id) as TOTAL_FUNDED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status in ('Ready to Fund','Funded')
	group by isos.id, tf_year, tf_month 
	) AS TOTAL_FUNDED

ON ISOS_table.i_id=TOTAL_FUNDED.id AND TOTAL_FUNDED.tf_year=Yi AND TOTAL_FUNDED.tf_month=Mi
LEFT JOIN

/* TOTAL_DECLINED */
	(SELECT isos.id,
			YEAR(deals.created_at) as td_year,
			MONTH(deals.created_at) as td_month,
		  	count(deals.id) as TOTAL_DECLINED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status IN ('Negative Balances','Declined','Bad Credit','Too Small','No Room','Previous Default','Merchant Declined','Declined Previously','Too Few Deposits','SIC Code','Declined Bad Iso','Suspected Fraud','Auto-declined','Fraud','Missing Stips','Merchant Declined','No Logins','No COJ','Negative Banks','New MCA','Poor Landlord','Contracts Back Declined')
	group by isos.id, td_year, td_month
	) AS TOTAL_DECLINED

ON ISOS_table.i_id=TOTAL_DECLINED.id AND td_year=Yi AND td_month=Mi
LEFT JOIN

/* AVERAGE_APPROVAL_AMOUNT */
	(SELECT isos.id,
		YEAR(deals.created_at) as aa_year,
		MONTH(deals.created_at) as aa_month,
		avg(deals.funded_amount) as AVERAGE_APPROVAL_AMOUNT
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	WHERE 
	deals.status IN ('Approved','Contracts Back','Contract Sent','Soft Approval','Ready to Fund','Lost Deal','Contract Returned','Funding Call','Open Approval','Funded')
	AND
	deals.funded_amount>0
	group by isos.id, aa_year, aa_month 
	) AS AVERAGE_APPROVAL_AMOUNT

ON ISOS_table.i_id=AVERAGE_APPROVAL_AMOUNT.id AND aa_year=Yi AND aa_month=Mi
LEFT JOIN

/* AVERAGE_FUNDED_AMOUNT */
	(select 
		isos.id,
		YEAR(deals.created_at) as af_year,
		MONTH(deals.created_at) as af_month,
		AVG(deals.funded_amount) as AVERAGE_FUNDED_AMOUNT
	from deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status in ('Ready to Fund','Funded')
	group by isos.id, af_year, af_month 
	) AS AVERAGE_FUNDED_AMOUNT

ON ISOS_table.i_id=AVERAGE_FUNDED_AMOUNT.id AND af_year=Yi AND af_month=Mi
LEFT JOIN

/* LARGEST_FUNDED_AMOUNT */
	(select 
		isos.id,
		YEAR(deals.created_at) as lf_year,
		MONTH(deals.created_at) as lf_month,
		max(deals.funded_amount) as LARGEST_FUNDED_AMOUNT
	from deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status in ('Funded','Ready to Fund')
	group by isos.id, lf_year, lf_month 
	) AS LARGEST_FUNDED_AMOUNT

ON ISOS_table.i_id=LARGEST_FUNDED_AMOUNT.id AND LARGEST_FUNDED_AMOUNT.lf_year=Yi AND LARGEST_FUNDED_AMOUNT.lf_month=Mi
LEFT JOIN

/* SMALLEST_FUNDED_AMOUNT */
	(select 
		isos.id,
		YEAR(deals.created_at) as sf_year,
		MONTH(deals.created_at) as sf_month,
		min(deals.funded_amount) as SMALLEST_FUNDED_AMOUNT
	from deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where 
	deals.funded_amount>0 
	and 
	deals.status in ('Funded','Ready to Fund')
	group by isos.id, sf_year, sf_month 
	) AS SMALLEST_FUNDED_AMOUNT

ON ISOS_table.i_id=SMALLEST_FUNDED_AMOUNT.id AND sf_year=Yi AND sf_month=Mi
LEFT JOIN

/* TOTAL_APPROVED_AMOUNT */
	(SELECT 
		isos.id,
		YEAR(deals.created_at) as ta_year,
		MONTH(deals.created_at) as ta_month,
		SUM(deals.funded_amount) as TOTAL_APPROVED_AMOUNT
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status IN ('Approved','Contracts Back','Contract Sent','Soft Approval','Ready to Fund','Lost Deal','Contract Returned','Funding Call','Open Approval','Funded')
	GROUP BY isos.id, ta_year, ta_month
	) AS TOTAL_APPROVED_AMOUNT

ON ISOS_table.i_id=TOTAL_APPROVED_AMOUNT.id AND TOTAL_APPROVED_AMOUNT.ta_year=Yi AND TOTAL_APPROVED_AMOUNT.ta_month=Mi
LEFT JOIN 

/* TOTAL_FUNDED_AMOUNT */
	(select 
		isos.id,
		YEAR(deals.created_at) as tf_year,
		MONTH(deals.created_at) as tf_month,
		SUM(deals.funded_amount) as TOTAL_FUNDED_AMOUNT
	from deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.funded_amount>0 
	and deals.status in ('Funded','Ready to Fund')
	group by isos.id, tf_year, tf_month
	) AS TOTAL_FUNDED_AMOUNT

ON ISOS_table.i_id=TOTAL_FUNDED_AMOUNT.id AND TOTAL_FUNDED_AMOUNT.tf_year=Yi AND TOTAL_FUNDED_AMOUNT.tf_month=Mi
LEFT JOIN

/* LATEST_SUBMISSION */
	(SELECT 
		isos.id as i_id,
		YEAR(deals.created_at ) as ls_year,
		MONTH(deals.created_at ) as ls_month,
		MAX(deals.created_at) AS LATEST_SUBMISSION
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	group by i_id, ls_year, ls_month 
	) AS LATEST_SUBMISSION

ON ISOS_table.i_id=LATEST_SUBMISSION.i_id AND ls_year=Yi AND ls_month=Mi
LEFT JOIN

/* LATEST_FUNDED_DATE */
	(SELECT 
		isos.id as i_id,
		YEAR(deals.funded_date ) as lf_year,
		MONTH(deals.funded_date ) as lf_month,
		MAX(deals.funded_date) AS LATEST_FUNDED
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	WHERE deals.status IN ('Funded','Ready to Fund')
	group by i_id,lf_year,lf_month
	) AS LATEST_FUNDED

ON ISOS_table.i_id=LATEST_FUNDED.i_id AND LATEST_FUNDED.lf_year=Yi AND LATEST_FUNDED.lf_month=Mi
LEFT JOIN

/* EARLIEST_SUBMISSION */
	(SELECT 
		isos.id as i_id,
		YEAR(deals.created_at ) as es_year,
		MONTH(deals.created_at ) as es_month,
		MIN(deals.created_at) AS EARLIEST_SUBMISSION
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	group by i_id,es_year,es_month
	) AS EARLIEST_SUBMISSION

ON ISOS_table.i_id=EARLIEST_SUBMISSION.i_id AND es_year=Yi AND es_month=Mi
LEFT JOIN

/* EARLIEST_FUNDED_DATE */
	(SELECT 
		isos.id as i_id,
		YEAR(deals.created_at ) as ef_year,
		MONTH(deals.created_at ) as ef_month,
		MIN(deals.funded_date) AS EARLIEST_FUNDED_DATE
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	WHERE deals.status IN ('Funded','Ready to Fund')
	group by i_id,ef_year,ef_month
	) AS EARLIEST_FUNDED_DATE

ON ISOS_table.i_id=EARLIEST_FUNDED_DATE.i_id AND ef_year=Yi AND ef_month=Mi
;