CREATE OR REPLACE VIEW vw_status_pedidos_mensal AS
WITH contagem_status AS (
    SELECT 
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS mes,
        COUNT(CASE WHEN order_status = 'created' THEN 1 END) AS criado,
        COUNT(CASE WHEN order_status = 'approved' THEN 1 END) AS aprovado,
        COUNT(CASE WHEN order_status = 'invoiced' THEN 1 END) AS faturado,
        COUNT(CASE WHEN order_status = 'processing' THEN 1 END) AS processando,
        COUNT(CASE WHEN order_status = 'shipped' THEN 1 END) AS enviado,
        COUNT(CASE WHEN order_status = 'delivered' THEN 1 END) AS entregue,
        COUNT(CASE WHEN order_status = 'unavailable' THEN 1 END) AS indisponivel,
        COUNT(CASE WHEN order_status = 'canceled' THEN 1 END) AS cancelado,
        COUNT(order_id) AS total_geral
    FROM ds_olist_orders
    GROUP BY 1
)
SELECT 
    mes,
    FORMAT(total_geral, 0, 'pt_BR') AS total_geral,
    FORMAT(entregue, 0, 'pt_BR') AS entregue,
    FORMAT(cancelado, 0, 'pt_BR') AS cancelado,
    -- Taxa de Sucesso: (Entregues / Total)
    CONCAT(REPLACE(ROUND((entregue / total_geral) * 100, 2), '.', ','), '%') AS taxa_sucesso_entrega,
    -- Taxa de Cancelamento: (Cancelados / Total)
    CONCAT(REPLACE(ROUND((cancelado / total_geral) * 100, 2), '.', ','), '%') AS taxa_cancelamento,
    -- Outros status para detalhamento
    FORMAT(faturado, 0, 'pt_BR') AS faturado,
    FORMAT(processando, 0, 'pt_BR') AS processando,
    FORMAT(enviado, 0, 'pt_BR') AS enviado
FROM contagem_status
ORDER BY mes DESC;