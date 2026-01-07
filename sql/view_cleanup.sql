CREATE OR REPLACE VIEW vista_crypto_limpia AS
SELECT
  -- 1. Convertimos la fecha de String a Timestamp
  -- Usamos el formato que genera tu Lambda: 'YYYY-MM-dd HH:mm:ss'
  CAST(date_parse(fecha_extraccion, '%Y-%m-%d %H:%i:%s') AS TIMESTAMP) as fecha,

  -- 2. Extraemos los datos del STRUCT (JSON) y los convertimos a números (Decimal)
  CAST(datos.bitcoin.usd AS DECIMAL(10,2)) as btc_usd,
  CAST(datos.ethereum.usd AS DECIMAL(10,2)) as eth_usd,
  CAST(datos.cardano.usd AS DECIMAL(10,4)) as ada_usd

FROM raw
WHERE fecha_extraccion IS NOT NULL
ORDER BY fecha DESC;