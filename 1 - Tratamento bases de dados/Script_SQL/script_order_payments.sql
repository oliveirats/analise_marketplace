-- VIZUALIZAR TABELA --
SELECT * FROM bdmyde.ds_olist_order_payments;

-- CRIAR COLUNAS --
CREATE TABLE ds_olist_order_enriched_payments AS
SELECT 
    *,
    -- 1. Conta quantos pagamentos sequenciais existem para aquele pedido
    COUNT(payment_sequential) OVER(PARTITION BY order_id) AS qtd_pagamentos_sequenciais,
    
    -- 2. Soma o valor total de todos os pagamentos do mesmo pedido
    SUM(payment_value) OVER(PARTITION BY order_id) AS valor_total_pedido
FROM 
    bdmyde.ds_olist_order_payments;