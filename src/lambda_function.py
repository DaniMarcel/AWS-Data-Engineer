import json
import boto3
import urllib.request
from datetime import datetime

# --- CONFIGURACIÓN ---
BUCKET_NAME = "portafolio-crypto-dl-danielmarcel" 
CARPETA = "raw"
# ---------------------

def lambda_handler(event, context):
    # 1. Definir la URL de la API (CoinGecko)
    # Traemos Bitcoin, Ethereum y Cardano en USD
    url = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,cardano&vs_currencies=usd"
    
    try:
        print(f"Consultando API: {url}")
        
        # 2. Hacer la petición
        req = urllib.request.Request(url)
        # CoinGecko a veces pide User-Agent para no bloquear
        req.add_header('User-Agent', 'Mozilla/5.0')
        
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
            
        print("Datos recibidos correctamente.")

        # 3. Agregar Timestamp (para saber cuándo bajamos el dato)
        timestamp_actual = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        # Estructuramos un poco mejor el dato para guardarlo
        data_to_save = {
            "fecha_extraccion": timestamp_actual,
            "datos": data
        }

        # 4. Generar nombre de archivo único
        # Ej: crypto_2023-10-27_10-30-05.json
        file_name_ts = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
        key = f"{CARPETA}/crypto_{file_name_ts}.json"

        # 5. Guardar en S3
        s3 = boto3.client('s3')
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=key,
            Body=json.dumps(data_to_save),
            ContentType='application/json'
        )

        print(f"Archivo guardado exitosamente en s3://{BUCKET_NAME}/{key}")
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Exito! Datos guardados: {key}')
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f"Error procesando datos: {str(e)}")
        }