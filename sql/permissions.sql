USE funding_solution_production;

select u.name,
u.email,
a.activity
from users u 
join user_activities ua on u.id = ua.user_id 
join activities a on ua.activity_id = a.id 
where organization_id = 1 and organization_type = 'funder' and a.activity in ('ActiveAdmin::Page:show', 'iso:update', 'iso:Create') 
order by name;