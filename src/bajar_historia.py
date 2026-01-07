import yfinance as yf
import pandas as pd
from datetime import datetime

# 1. Configuración: Lista de monedas que quieras
# Yahoo usa los tickers: BTC-USD, ETH-USD, ADA-USD, SOL-USD, DOT-USD, XRP-USD
monedas = ["BTC-USD", "ETH-USD", "ADA-USD", "SOL-USD", "XRP-USD"]

print("Iniciando descarga masiva de historia...")

# 2. Descargar historia completa (Max) con intervalo diario
# Esto baja datos desde 2014 (o antes si hay disponibilidad)
df = yf.download(monedas, period="max", interval="1d")

# 3. Limpieza y Transformación
# Yahoo devuelve una tabla compleja, la aplanamos para que sea fácil de leer en Athena
df_clean = df['Close'].stack().reset_index()
df_clean.columns = ['Fecha', 'Simbolo', 'Precio']

# Agregamos fecha de extracción para auditoría
df_clean['fecha_carga'] = datetime.now().strftime("%Y-%m-%d")

# Renombramos para estandarizar (BTC-USD -> BTC)
df_clean['Simbolo'] = df_clean['Simbolo'].str.replace('-USD', '')

print(f"Descargados {len(df_clean)} registros históricos.")
print(df_clean.head())

# 4. Guardar como CSV
nombre_archivo = "historia_crypto_2010_2026.csv"
df_clean.to_csv(nombre_archivo, index=False)

print(f"¡Listo! Archivo '{nombre_archivo}' generado.")