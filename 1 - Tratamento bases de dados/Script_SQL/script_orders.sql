-- VIZUALIZAR TABELA --
SELECT * FROM bdmyde.ds_olist_orders;

-- CONVERTER VARIAVEIS DE DATA DE FORMATO TEXTO PARA DATA --
-- converter:
ALTER TABLE bdmyde.ds_olist_orders 
MODIFY COLUMN order_purchase_timestamp DATETIME,
MODIFY COLUMN order_approved_at DATETIME,
MODIFY COLUMN order_delivered_carrier_date DATETIME,
MODIFY COLUMN order_estimated_delivery_date DATETIME,
MODIFY COLUMN order_delivered_customer_date DATETIME;

-- VERIFICAR DISTRIBUICAO DA VARIAVEL --
SELECT
order_status,
COUNT(*) as total
FROM bdmyde.ds_olist_orders
GROUP BY
order_status;