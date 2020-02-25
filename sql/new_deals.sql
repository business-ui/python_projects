USE funding_solution_development;
SELECT 
deals.*,users.name
FROM deals
JOIN users ON users.id=deals.underwriter_id
WHERE deals.underwriter_id=270 and deals.status="New" and deals.funded_amount>0 and deals.created_at<"2019-12-13"
/*GROUP BY deals.status,deals.underwriter_id
ORDER BY COUNT(deals.id)*/;
