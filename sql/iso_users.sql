USE funding_solution_production;

SELECT isos.name,isos.id as i_id,users.email,users.name, users.id as u_id
FROM users
JOIN isos ON isos.id=users.organization_id
;

