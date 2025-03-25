import urllib3
import os
import json
import pandas as pd
from datetime import datetime, timezone
import awswrangler as wr

# Config S3
BUCKET_NAME = os.getenv("BUCKET_NAME")
BASE_PATH = "raw/"  # Dossier sur S3

def fetch_crypto_data():
    """Récupère les 1000 premières cryptos depuis CoinLore."""
    http = urllib3.PoolManager()
    cryptos = []

    for start in range(0, 1000, 100):  # Paginer par 100 (limite API)
        url = f"https://api.coinlore.net/api/tickers/?start={start}&limit=100"
        response = http.request("GET", url)

        if response.status != 200:
            raise Exception(f"Erreur API: {response.status}")

        data = json.loads(response.data.decode("utf-8"))
        cryptos.extend(data["data"])

    return cryptos

def save_to_s3(data, timestamp):
    """Sauvegarde les données en Parquet sous un fichier raw nommé data-{timestamp}.parquet."""
    df = pd.DataFrame(data)  # Convertir en DataFrame Pandas
    
    # Ajouter la colonne timestamp
    df["timestamp"] = timestamp

    # Formater le timestamp pour le nom du fichier
    timestamp_str = datetime.utcfromtimestamp(timestamp).strftime("%Y%m%d-%H%M%S")

    # Nom du fichier sur S3
    file_name = f"data-{timestamp_str}.parquet"
    s3_path = f"s3://{BUCKET_NAME}/{BASE_PATH}{file_name}"

    # Sauvegarde en Parquet (désactivation de dataset pour garder le nom défini)
    wr.s3.to_parquet(df=df, path=s3_path, dataset=False)

def lambda_handler(event, context):
    """Handler principal de la Lambda."""
    try:
        # Récupérer le timestamp depuis l'event ou utiliser l'heure actuelle
        timestamp = event.get("wf_timestamp", datetime.now(timezone.utc).timestamp())

        crypto_data = fetch_crypto_data()
        save_to_s3(crypto_data, timestamp)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Donnees enregistrees sur S3",
                "timestamp": timestamp
            })
        }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
