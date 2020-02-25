USE funding_solution_production;

SELECT 
email,
u_name as USER,
i_name as ISO,
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
TOTAL_FUNDED/TOTAL_APPROVED
FROM 

	(SELECT DISTINCT users.id,users.email,users.name as u_name,isos.name as i_name
	FROM users 
	JOIN isos ON isos.id=users.organization_id
	) AS USERS_table

LEFT JOIN

/* TOTAL_SUBMITTED */
	(SELECT users.id,count(deals.id) as TOTAL_SUBMITTED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	group by users.id asc
	) AS TOTAL_SUBMITTED

ON TOTAL_SUBMITTED.id=USERS_table.id
LEFT JOIN

/* TOTAL_APPROVED */
	(SELECT users.id,count(deals.id) as TOTAL_APPROVED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status IN ('Approved','Contracts Back','Contract Sent','Soft Approval','Ready to Fund','Lost Deal','Contract Returned','Funding Call','Open Approval','Funded')
	group by users.id asc 
	) AS TOTAL_APPROVED

ON USERS_table.id=TOTAL_APPROVED.id
LEFT JOIN

/* TOTAL_FUNDED */
	(SELECT users.id,
		   count(deals.id) as TOTAL_FUNDED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status in ('Ready to Fund','Funded')
	group by users.id asc 
	) AS TOTAL_FUNDED

ON USERS_table.id=TOTAL_FUNDED.id
LEFT JOIN

/* TOTAL_DECLINED */
(SELECT users.id,
		   count(deals.id) as TOTAL_DECLINED
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status IN ('Negative Balances','Declined','Bad Credit','Too Small','No Room','Previous Default','Merchant Declined','Declined Previously','Too Few Deposits','SIC Code','Declined Bad Iso','Suspected Fraud','Auto-declined','Fraud','Missing Stips','Merchant Declined','No Logins','No COJ','Negative Banks','New MCA','Poor Landlord','Contracts Back Declined')
	group by users.id asc 
	) AS TOTAL_DECLINED

ON USERS_table.id=TOTAL_DECLINED.id
LEFT JOIN

/* AVERAGE_APPROVAL_AMOUNT */
	(SELECT users.id,
		   avg(deals.funded_amount) as AVERAGE_APPROVAL_AMOUNT
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	WHERE deals.status IN ('Approved','Contracts Back','Contract Sent','Soft Approval','Ready to Fund','Lost Deal','Contract Returned','Funding Call','Open Approval','Funded')
	AND
	deals.funded_amount>0
	group by users.id ASC 
	) AS AVERAGE_APPROVAL_AMOUNT

ON USERS_table.id=AVERAGE_APPROVAL_AMOUNT.id
LEFT JOIN

/* AVERAGE_FUNDED_AMOUNT */
	(select 
		users.id,
		AVG(deals.funded_amount) as AVERAGE_FUNDED_AMOUNT
	from deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status in ('Ready to Fund','Funded')
	group by users.id ASC
	) AS AVERAGE_FUNDED_AMOUNT

ON USERS_table.id=AVERAGE_FUNDED_AMOUNT.id
LEFT JOIN

/* LARGEST_FUNDED_AMOUNT */
	(select 
		users.id,
		max(deals.funded_amount) as LARGEST_FUNDED_AMOUNT
	from deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status in ('Funded','Ready to Fund')
	group by users.id ASC 
	) AS LARGEST_FUNDED_AMOUNT

ON USERS_table.id=LARGEST_FUNDED_AMOUNT.id
LEFT JOIN

/* SMALLEST_FUNDED_AMOUNT */
	(select 
		users.id,
		min(deals.funded_amount) as SMALLEST_FUNDED_AMOUNT
	from deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.funded_amount>0 
	and deals.status in ('Funded','Ready to Fund')
	group by users.id ASC
	) AS SMALLEST_FUNDED_AMOUNT

ON USERS_table.id=SMALLEST_FUNDED_AMOUNT.id
LEFT JOIN

/* TOTAL_APPROVED_AMOUNT */
	(SELECT users.id,
		   SUM(deals.funded_amount) as TOTAL_APPROVED_AMOUNT
	FROM deals
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.status IN ('Approved','Contracts Back','Contract Sent','Soft Approval','Ready to Fund','Lost Deal','Contract Returned','Funding Call','Open Approval','Funded')
	GROUP BY users.id
	) AS TOTAL_APPROVED_AMOUNT

ON USERS_table.id=TOTAL_APPROVED_AMOUNT.id
LEFT JOIN 

	(select 
		users.id,
		SUM(deals.funded_amount) as TOTAL_FUNDED_AMOUNT
	from deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	where deals.funded_amount>0 
	and deals.status in ('Funded','Ready to Fund')
	group by users.id ASC) AS TOTAL_FUNDED_AMOUNT

ON USERS_table.id=TOTAL_FUNDED_AMOUNT.id
LEFT JOIN

/* LATEST_SUBMISSION */
	(SELECT users.id as u_id,
	MAX(deals.created_at) AS LATEST_SUBMISSION
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	group by u_id) AS LATEST_SUBMISSION

ON USERS_table.id=LATEST_SUBMISSION.u_id
LEFT JOIN

/* LATEST_FUNDED_DATE */
	(SELECT users.id as u_id,
	MAX(deals.funded_date) AS LATEST_FUNDED
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	WHERE deals.status IN ('Funded','Ready to Fund')
	group by u_id) AS LATEST_FUNDED

ON USERS_table.id=LATEST_FUNDED.u_id
LEFT JOIN

/* EARLIEST_SUBMISSION */
	(SELECT users.id as u_id,
	MIN(deals.created_at) AS EARLIEST_SUBMISSION
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	group by u_id) AS EARLIEST_SUBMISSION

ON USERS_table.id=EARLIEST_SUBMISSION.u_id
LEFT JOIN

/* EARLIEST_FUNDED_DATE */
	(SELECT users.id as u_id,
	MIN(deals.funded_date) AS EARLIEST_FUNDED_DATE
	FROM deals 
	JOIN users on deals.sales_rep_id=users.id
	JOIN isos on isos.id=users.organization_id
	WHERE deals.status IN ('Funded','Ready to Fund')
	group by u_id) AS EARLIEST_FUNDED_DATE

ON USERS_table.id=EARLIEST_FUNDED_DATE.u_id

;