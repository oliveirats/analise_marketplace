-- VIZUALIZAR TABELA --
SELECT * FROM bdmyde.ds_olist_sellers;

-- PADRONIZAR OS NOMES DAS CIDADES --
-- Remover siglas --
UPDATE ds_olist_sellers
SET seller_city = TRIM(LOWER(
    REGEXP_REPLACE(seller_city, ' [a-z]{2}$', '')
));

-- Analizar valores após o tratamento --
SELECT
seller_city,
COUNT(*) as total
FROM bdmyde.ds_olist_sellers
GROUP BY
seller_city;

UPDATE ds_olist_sellers s
JOIN (
    -- Seleciona a cidade mais frequente para cada CEP na tabela de geo
    SELECT geolocation_zip_code_prefix, geolocation_city, COUNT(*)
    FROM ds_olist_unique_geolocation
    GROUP BY geolocation_zip_code_prefix, geolocation_city
    ORDER BY COUNT(*) DESC
) geo ON s.seller_zip_code_prefix = geo.geolocation_zip_code_prefix
SET s.seller_city = geo.geolocation_city;