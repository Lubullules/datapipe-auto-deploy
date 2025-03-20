from datetime import datetime
import json

def lambda_handler(event, context):
    # Extraire les données JSON reçues depuis l'événement
    try:
        # Récupérer le timestamp de l'événement
        timestamp = datetime.fromtimestamp(event['body']['info']['time']).strftime('%Y-%m-%d %H:%M:%S')

        # Récupérer les données JSON
        json_data = event['body']['data']

        # Liste les clés qui sont à convertir en float
        keys_to_float = ['price_usd', 'percent_change_24h', 'percent_change_1h', 'percent_change_7d', 'price_btc', 'market_cap_usd', 'volume24', 'volume24a', 'csupply', 'tsupply', 'msupply']


        # Traitement des données
        for object in json_data:
            # Supprimer les clés inutiles
            del object['rank']

            # Rajouter le timestamp
            object['timestamp'] = timestamp

            # Convertir les clés en float ou en None si elles sont vides
            for key in keys_to_float:
                if object[key] == '':
                    object[key] = None
                else:
                    object[key] = float(object[key])
            
        # Retourner le JSON sous forme de chaîne dans la clé "body"
        return {
            "statusCode": 200,
            "body": json.dumps(json_data)  # Convertir l'objet Python en JSON pour la réponse
        }

    # Lever une exception en cas d'erreur
    except Exception as e:
        raise Exception(f"An error occurred: {str(e)}")