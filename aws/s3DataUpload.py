import os
import json
import datetime
import boto3  # type: ignore

# Initialisation du client S3
s3 = boto3.client("s3")
BUCKET_NAME = os.getenv("BUCKET_NAME")

def lambda_handler(event, context):
    # Extraire les données JSON reçues depuis l'événement
    try:
        data = json.loads(event['body'])  # Supposons que les données sont dans 'body'

        # Générer un nom de fichier unique basé sur la date et l'heure
        file_name = f"data_{datetime.datetime.now().strftime('%Y-%m-%d_%H-%M-%S')}.json"

        # Convertir les données en chaîne JSON avant de les envoyer dans S3
        s3.put_object(
            Bucket=BUCKET_NAME,
            Key=file_name,
            Body=json.dumps(data),
            ContentType="application/json"
        )

        # Retourner une réponse réussie
        return {
            "statusCode": 200,
            "body": json.dumps({"message": f"Données enregistrées avec succès sous {file_name}"})
        }

    except Exception as e:
        # Lever une exception en cas d'erreur
        raise Exception(f"An error occurred: {str(e)}")
