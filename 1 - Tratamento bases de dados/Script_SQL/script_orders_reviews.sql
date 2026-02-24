SELECT * FROM bdmyde.ds_olist_order_reviews;

-- VERIFICAR DISTRIBUICAO DA VARIAVEL --
SELECT
review_score,
COUNT(*) as total
FROM bdmyde.ds_olist_order_reviews
GROUP BY
review_score;

-- CONVERTER COLUNAS DE DATA DE FORMATO TEXTO PARA DATA --

-- Desativa o modo seguro para evitar bloqueios
SET SQL_SAFE_UPDATES = 0;

ALTER TABLE bdmyde.ds_olist_order_reviews 
MODIFY COLUMN review_creation_date DATETIME,
MODIFY COLUMN review_answer_timestamp DATETIME;