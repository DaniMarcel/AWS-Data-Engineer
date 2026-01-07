CREATE OR REPLACE VIEW vista_completa_master AS

/* PARTE 1: DATOS HISTÓRICOS (Batch Layer)
   Estos vienen del CSV estático. Ya tienen la estructura: Fecha, Simbolo, Precio.
   Solo necesitamos asegurar los tipos de datos correctos.
*/
SELECT
  -- Convertimos el string '2014-09-17' a Timestamp real
  CAST(date_parse(fecha, '%Y-%m-%d') AS TIMESTAMP) as fecha,
  simbolo,
  CAST(precio AS DECIMAL(20,4)) as precio_usd,
  'HISTORICO' as fuente
FROM "crypto_db"."static_historico" -- ASEGÚRATE QUE ESTE NOMBRE COINCIDA CON TU TABLA EN ATHENA

UNION ALL

/* PARTE 2: DATOS EN VIVO (Speed Layer)
   Estos vienen de la vista limpia. Están en columnas separadas (btc_usd, eth_usd...).
   Usamos 3 SELECTs unidos para "rotar" (unpivot) la tabla y dejarla igual que la histórica.
*/

-- Bloque para Bitcoin
SELECT
  fecha,
  'BTC' as simbolo,
  btc_usd as precio_usd,
  'EN_VIVO' as fuente
FROM vista_crypto_limpia
WHERE btc_usd IS NOT NULL

UNION ALL

-- Bloque para Ethereum
SELECT
  fecha,
  'ETH' as simbolo,
  eth_usd as precio_usd,
  'EN_VIVO' as fuente
FROM vista_crypto_limpia
WHERE eth_usd IS NOT NULL

UNION ALL

-- Bloque para Cardano
SELECT
  fecha,
  'ADA' as simbolo,
  ada_usd as precio_usd,
  'EN_VIVO' as fuente
FROM vista_crypto_limpia
WHERE ada_usd IS NOT NULL;