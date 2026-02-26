-- VIZUALIZAÇÃO DA TABELA --
SELECT * FROM bdmyde.ds_olist_products;

-- SUBSTITUIR NULL POR CLASSIFICAÇÃO DE NÃO REGISTRO --
UPDATE bdmyde.ds_olist_products
SET product_category_name = 'nao_registrado'
WHERE product_category_name IS NULL;
