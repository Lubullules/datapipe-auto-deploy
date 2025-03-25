import os
import io
import json
import datetime

import boto3  # type: ignore
import pyarrow
import pyarrow.parquet as pq

# Initialisation du client S3
s3 = boto3.client("s3")
BUCKET_NAME = os.getenv("BUCKET_NAME")

def lambda_handler(event, context):
    try:
        # Extraire les données JSON reçues depuis l'événement
        data = json.loads(event['body'])  # Supposons que les données sont dans 'body'
        
        # Vérifier que les données sont bien une liste de dictionnaires (structure tabulaire)
        if not isinstance(data, list):
            raise ValueError("Les données doivent être une liste de dictionnaires pour être converties en Parquet")

        # Générer un nom de fichier unique
        file_name = f"data_{datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.parquet"

        # Convertir la liste de dictionnaires en dictionnaire de listes
        columns = {key: [d[key] for d in data] for key in data[0]}

        # Conversion en .parquet
        parquet_buffer = io.BytesIO()

        table = pyarrow.Table.from_pydict(columns)
        with pq.ParquetWriter(parquet_buffer, table.schema) as writer:
            writer.write_table(table)

        # Stocker dans S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=parquet_buffer.getvalue(),
            ContentType="application/octet-stream"
        )

        # Retourner une réponse réussie
        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"Données enregistrées avec succès sous {file_name} en format Parquet"})
        }

    except Exception as e:
        raise Exception(f"An error occurred: {str(e)}")
