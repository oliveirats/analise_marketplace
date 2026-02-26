CREATE OR REPLACE VIEW vw_crescimento_faturamento_mensal AS
WITH faturamento_mensal AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS mes,
        SUM(p.payment_value) AS faturamento
    FROM olist_orders_dataset o
    JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY 1
)
SELECT 
    mes,
    -- Formata para: 1.250,50
    FORMAT(faturamento, 2, 'pt_BR') AS faturamento_br,
    
    -- Formata o faturamento anterior
    FORMAT(LAG(faturamento) OVER (ORDER BY mes), 2, 'pt_BR') AS fat_anterior_br,
    
    -- Formata o percentual com vírgula e o símbolo %
    CONCAT(REPLACE(ROUND(((faturamento - LAG(faturamento) OVER (ORDER BY mes)) / 
           LAG(faturamento) OVER (ORDER BY mes)) * 100, 2), '.', ','), '%') AS crescimento_br
FROM faturamento_mensal;