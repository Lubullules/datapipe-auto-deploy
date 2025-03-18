import urllib3
import json

def lambda_handler(event, context):
    http = urllib3.PoolManager()
    response = http.request("GET", "https://api.coinlore.net/api/tickers/")

    if response.status == 200:
        data = json.loads(response.data.decode("utf-8"))  # Convertir en JSON

        # Retourner le JSON sous forme de chaîne dans la clé "body"
        return {
            "statusCode": 200,
            "body": json.dumps(data)  # Convertir l'objet Python en JSON pour la réponse
        }

    # Lever une exception en cas d'erreur
    raise Exception(f"Erreur lors de la récupération des données: {response.status}")
