-- VIZUALIZAR TABELA --
SELECT * FROM bdmyde.ds_olist_order_items;

-- CONVERTER TEXTO E DATA --
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE bdmyde.ds_olist_order_items 
MODIFY COLUMN shipping_limit_date DATETIME;

-- Verificar Valores Nulos ou Zerados de preço --
SELECT COUNT(*) 
FROM bdmyde.ds_olist_order_items 
WHERE price <= 0 OR price IS NULL;