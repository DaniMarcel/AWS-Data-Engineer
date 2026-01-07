CREATE OR REPLACE VIEW vista_crypto_limpia AS
SELECT
  -- 1. Fecha
  CAST(date_parse(fecha_extraccion, '%Y-%m-%d %H:%i:%s') AS TIMESTAMP) as fecha,

  -- 2. Precios (Agregamos SOL y XRP)
  CAST(datos.bitcoin.usd AS DECIMAL(10,2)) as btc_usd,
  CAST(datos.ethereum.usd AS DECIMAL(10,2)) as eth_usd,
  CAST(datos.cardano.usd AS DECIMAL(10,4)) as ada_usd,
  CAST(datos.solana.usd AS DECIMAL(10,2)) as sol_usd,
  CAST(datos.ripple.usd AS DECIMAL(10,4)) as xrp_usd

FROM raw
WHERE fecha_extraccion IS NOT NULL
ORDER BY fecha DESC;