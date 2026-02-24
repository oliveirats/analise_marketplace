-- VIZUALIZAR TABELA --
SELECT * FROM bdmyde.ds_olist_geolocation;

-- ADICIONAR COLUNA ID --
-- 1. Adiciona a coluna se ela não existir
ALTER TABLE bdmyde.ds_olist_geolocation ADD COLUMN id INT;

-- CRIAR ID --
-- 2. Popula a coluna baseada na combinação única de lat/long
SET SQL_SAFE_UPDATES = 0 ;
UPDATE bdmyde.ds_olist_geolocation t
JOIN (
    SELECT 
        geolocation_lat, 
        geolocation_lng, 
        DENSE_RANK() OVER (ORDER BY geolocation_lat, geolocation_lng) as novo_id
    FROM bdmyde.ds_olist_geolocation
    GROUP BY geolocation_lat, geolocation_lng -- O GROUP BY reduz o volume de dados do JOIN
) mapa ON t.geolocation_lat = mapa.geolocation_lat 
      AND t.geolocation_lng = mapa.geolocation_lng
SET t.id = mapa.novo_id;

-- CRIAR TABELA APENAS COM IDS UNICOS --
SET SESSION wait_timeout = 100000;
SET SESSION interactive_timeout = 100000;

CREATE TABLE bdmyde.ds_olist_unique_geolocation AS
SELECT 
    id,
    geolocation_lat,
    geolocation_lng,
    -- Usamos MIN para escolher um valor caso haja cidades/estados escritos de forma diferente
    MIN(geolocation_zip_code_prefix) AS geolocation_zip_code_prefix,
    MIN(geolocation_city) AS geolocation_city,
    MIN(geolocation_state) AS geolocation_state
FROM bdmyde.ds_olist_geolocation
GROUP BY id, geolocation_lat, geolocation_lng;