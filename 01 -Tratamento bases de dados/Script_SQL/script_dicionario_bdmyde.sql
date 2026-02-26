-- DICIONARIO DO BANCO DE DADOS --
SELECT 
    table_name, 
    column_name, 
    data_type
FROM 
    information_schema.columns
WHERE 
    table_schema = 'bdmyde'
ORDER BY 
    table_name;