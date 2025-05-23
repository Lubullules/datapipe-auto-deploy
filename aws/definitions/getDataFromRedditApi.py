import urllib3
import json
import base64
import pandas as pd
import numpy as np
import awswrangler as wr
import os
from urllib.parse import urlencode
from datetime import datetime

# Config S3
BUCKET_NAME = os.getenv("BUCKET_NAME")

# Variables d'environnement pour Reddit
reddit_username = os.getenv("reddit_username")
reddit_password = os.getenv("reddit_password")
user_agent = os.getenv("reddit_user_agent")
client_id = os.getenv("reddit_client_id")
client_secret = os.getenv("reddit_client_secret")

def safe_convert(value):
    if isinstance(value, (dict, list, tuple)) or isinstance(value, np.ndarray):
        return json.dumps(value)
    if pd.isna(value):
        return "null"
    return str(value)


def lambda_handler(event, context):
    try:
        # ----- Étape 1 : Authentification OAuth -----
        basic_auth = f"{client_id}:{client_secret}"
        encoded_auth = base64.b64encode(basic_auth.encode()).decode()

        auth_url = "https://www.reddit.com/api/v1/access_token"
        auth_payload = {
            "grant_type": "password",
            "username": reddit_username,
            "password": reddit_password
        }

        auth_headers = {
            "authorization": f"Basic {encoded_auth}",
            "content-type": "application/x-www-form-urlencoded",
            "user-agent": user_agent
        }

        http = urllib3.PoolManager()

        encoded_auth_data = urlencode(auth_payload)
        auth_response = http.request(
            "POST",
            auth_url,
            body=encoded_auth_data,
            headers=auth_headers
        )

        if auth_response.status != 200:
            raise ValueError(f"Failed to authenticate. Status code: {auth_response.status}, response: {auth_response.data}")


        auth_data = json.loads(auth_response.data.decode("utf-8"))
        access_token = auth_data.get("access_token")

        # ----- Étape 2 : Appel API Reddit avec OAuth -----
        api_url = "https://oauth.reddit.com/r/cryptocurrency/new/?limit=50"
        api_headers = {
            "authorization": f"bearer {access_token}",
            "user-agent": user_agent
        }


        api_response = http.request("GET", api_url, headers=api_headers)
        data = json.loads(api_response.data.decode("utf-8"))

        # ----- Étape 3 : Transformation des données -----
        posts = [child["data"] for child in data["data"]["children"]]
        df = pd.DataFrame(posts)

        # Remplacer dict/NaN et convertir toutes les valeurs en str
        df = df.applymap(safe_convert)

        # ----- Étape 4 : Génération du nom de fichier avec timestamp -----
        timestamp = event.get("pipeline_timestamp")
        df["pipeline_timestamp"] = timestamp

        # ----- Étape 5 : Sauvegarde dans S3 -----
        wr.s3.to_parquet(df=df, path=f"s3://{BUCKET_NAME}/reddit/raw/", dataset=True, partition_cols=["pipeline_timestamp"], index=False)


        return {
            'statusCode': 200,
            'body': json.dumps(f"Data successfully uploaded to s3://{BUCKET_NAME}/reddit/raw")
        }

    except Exception as e:
        raise ValueError(f"An error occurred: {str(e)}")