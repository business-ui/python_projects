USE funding_solution_production;

select u.name,
u.email,
a.name 
from users u 
join user_groups ua on u.id = ua.user_id 
join groups a on ua.group_id = a.id 
where u.organization_id = 1 and u.organization_type = 'funder' 
order by u.name;