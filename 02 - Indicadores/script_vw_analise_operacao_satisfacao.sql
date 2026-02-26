CREATE OR REPLACE VIEW vw_analise_operacao_satisfacao AS
WITH base_unificada AS (
    SELECT 
        o.order_id,
        o.order_status,
        r.review_score,
        -- Classificação de Logística
        CASE 
            WHEN o.order_status = 'delivered' AND o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN 'No Prazo'
            WHEN o.order_status = 'delivered' AND o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Atrasado'
            WHEN o.order_status = 'canceled' THEN 'Cancelado'
            WHEN o.order_status = 'unavailable' THEN 'Indisponível'
            ELSE 'Outros Status'
        END AS classificacao_pedido
    FROM ds_olist_orders o
    LEFT JOIN ds_olist_order_reviews r ON o.order_id = r.order_id
)
SELECT 
    classificacao_pedido,
    FORMAT(COUNT(order_id), 0, 'pt_BR') AS total_pedidos,
    REPLACE(ROUND(AVG(review_score), 2), '.', ',') AS nota_media,
    -- Taxa de Detratores (Notas 1 e 2)
    CONCAT(REPLACE(ROUND((SUM(CASE WHEN review_score <= 2 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 2), '.', ','), '%') AS taxa_detratores
FROM base_unificada
GROUP BY classificacao_pedido
ORDER BY AVG(review_score) DESC;