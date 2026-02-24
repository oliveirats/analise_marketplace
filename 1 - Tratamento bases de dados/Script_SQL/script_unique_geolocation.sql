-- VISUALIZAR TABELA -- 
SELECT * FROM bdmyde.ds_olist_unique_geolocation;

-- PADRONIZAÇÃO DE NOMES

SET SESSION wait_timeout = 50000;
SET SESSION interactive_timeout = 50000;
SET SQL_SAFE_UPDATES = 0 ;
-- 1. Criamos um mapa de correção apenas com os nomes que existem na tabela unique
CREATE TABLE bdmyde.temp_mapa_nomes AS
SELECT 
    geolocation_city AS nome_original,
    -- Escolhe o nome mais frequente para cada versão "limpa"
    FIRST_VALUE(geolocation_city) OVER(
        PARTITION BY LOWER(TRIM(REPLACE(REPLACE(REPLACE(geolocation_city, 'ã', 'a'), 'á', 'a'), 'é', 'e'))) 
        ORDER BY COUNT(*) DESC
    ) as nome_padronizado
FROM bdmyde.ds_olist_unique_geolocation
GROUP BY geolocation_city;

-- 2. Atualizamos a tabela unique usando esse mapa (será muito rápido)

CREATE TABLE bdmyde.ds_olist_geolocation_final AS
SELECT 
    t.id,
    t.geolocation_lat,
    t.geolocation_lng,
    m.nome_padronizado AS geolocation_city,
    t.geolocation_state,
    t.geolocation_zip_code_prefix
FROM bdmyde.ds_olist_unique_geolocation t
JOIN bdmyde.temp_mapa_nomes m ON t.geolocation_city = m.nome_original;

-- 1. Remove as tabelas que não precisa mais (opcional, mas libera espaço)
DROP TABLE bdmyde.ds_olist_unique_geolocation;
DROP TABLE bdmyde.temp_mapa_nomes;

-- 2. Renomeia a final para ser sua tabela oficial
ALTER TABLE bdmyde.ds_olist_geolocation_final RENAME TO bdmyde.ds_olist_unique_geolocation;

-- 3. Adiciona a Primary Key para garantir performance total
ALTER TABLE bdmyde.ds_olist_unique_geolocation ADD PRIMARY KEY (id);
