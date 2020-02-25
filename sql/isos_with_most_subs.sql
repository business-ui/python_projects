USE funding_solution_production;
SELECT isos.id,
	   isos.name,
	   count(deals.id)
FROM deals
RIGHT JOIN users on deals.sales_rep_id=users.id
RIGHT JOIN isos on isos.id=users.organization_id
GROUP BY isos.id
ORDER BY count(deals.id) DESC
LIMIT 40;