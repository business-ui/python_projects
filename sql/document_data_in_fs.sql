USE funding_solution_development;
SELECT documents.id,
	   documents.document_data,
       isos.name,
       isos.id
FROM documents
JOIN isos ON documents.documentable_id=isos.id
WHERE documents.documentable_type="Iso"
ORDER BY isos.id;