from datetime import datetime
import pandas as pd

def lambda_handler(event, context):
    # Extraire les données JSON reçues depuis l'événement
    try:
        df = pd.DataFrame(event['body']['data']) # Supposons que les données sont dans 'body'

        # Récupérer le timestamp et le convertir en format lisible
        timestamp = datetime.fromtimestamp(event['body']['info']['time']).strftime('%Y-%m-%d %H:%M:%S')

        df['timestamp'] = timestamp

        # Convertir les valeurs manquantes en NaN
        df = df.replace('', None)

        # Dropper les colonnes inutiles
        df = df.drop(columns=['rank'])

        # Transformer les types de données
        df['price_usd'] = df['price_usd'].astype(float)
        df['percent_change_24h'] = df['percent_change_24h'].astype(float)
        df['percent_change_1h'] = df['percent_change_1h'].astype(float)
        df['percent_change_7d'] = df['percent_change_7d'].astype(float)
        df['price_btc'] = df['price_btc'].astype(float)
        df['market_cap_usd'] = df['market_cap_usd'].astype(float)
        df['volume24'] = df['volume24'].astype(float)
        df['volume24a'] = df['volume24a'].astype(float)
        df['csupply'] = df['csupply'].astype(float)
        df['tsupply'] = df['tsupply'].astype(float)
        df['msupply'] = df['msupply'].astype(float)

        # Retourner le DataFrame sous forme de chaîne JSON
        return {
            "statusCode": 200,
            "body": df.to_json(orient='records')
        }
    
    # Lever une exception en cas d'erreur
    except Exception as e:
        raise Exception(f"An error occurred: {str(e)}")