CREATE OR REPLACE VIEW vista_completa_master AS

/* PARTE 1: DATOS HISTÓRICOS (Batch) */
SELECT
  CAST(date_parse(fecha, '%Y-%m-%d') AS TIMESTAMP) as fecha,
  simbolo,
  CAST(precio AS DECIMAL(20,4)) as precio_usd,
  'HISTORICO' as fuente
FROM "crypto_db"."static_historico"

UNION ALL

/* PARTE 2: DATOS EN VIVO (Streaming) - Ahora con 5 monedas */

-- Bitcoin
SELECT fecha, 'BTC' as simbolo, btc_usd as precio_usd, 'EN_VIVO' as fuente
FROM vista_crypto_limpia WHERE btc_usd IS NOT NULL

UNION ALL
-- Ethereum
SELECT fecha, 'ETH' as simbolo, eth_usd as precio_usd, 'EN_VIVO' as fuente
FROM vista_crypto_limpia WHERE eth_usd IS NOT NULL

UNION ALL
-- Cardano
SELECT fecha, 'ADA' as simbolo, ada_usd as precio_usd, 'EN_VIVO' as fuente
FROM vista_crypto_limpia WHERE ada_usd IS NOT NULL

UNION ALL
-- Solana (NUEVO)
SELECT fecha, 'SOL' as simbolo, sol_usd as precio_usd, 'EN_VIVO' as fuente
FROM vista_crypto_limpia WHERE sol_usd IS NOT NULL

UNION ALL
-- Ripple (NUEVO)
SELECT fecha, 'XRP' as simbolo, xrp_usd as precio_usd, 'EN_VIVO' as fuente
FROM vista_crypto_limpia WHERE xrp_usd IS NOT NULL;