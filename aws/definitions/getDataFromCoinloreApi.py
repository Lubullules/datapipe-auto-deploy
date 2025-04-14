import urllib3
import os
import json
import pandas as pd
import awswrangler as wr

# Config S3
BUCKET_NAME = os.getenv("BUCKET_NAME")

def fetch_crypto_data():
    """Get the data from the CoinLore API."""
    http = urllib3.PoolManager()
    cryptos = []

    for start in range(0, 1000, 100):  # limited by the API
        url = f"https://api.coinlore.net/api/tickers/?start={start}&limit=100"
        response = http.request("GET", url)

        if response.status != 200:
            raise Exception(f"Erreur API: {response.status}")

        data = json.loads(response.data.decode("utf-8"))
        cryptos.extend(data["data"])

    return cryptos

def save_to_s3(data, timestamp):
    """Save the data to S3. Data is a list of dictionaries. Timestamp is a float."""
    df = pd.DataFrame(data)  # Convert in pandas DataFrame
    
    # Add the timestamp column
    df["wf_timestamp"] = timestamp

    # Name of the file and path
    s3_path = f"s3://{BUCKET_NAME}/coinlore/raw/"

    # Save the data to S3
    wr.s3.to_parquet(df=df, path=s3_path, dataset=True, partition_cols=["wf_timestamp"], index=False)

def lambda_handler(event, context):
    try:
        # Get the timestamp
        timestamp = event.get("wf_timestamp")

        crypto_data = fetch_crypto_data()
        save_to_s3(crypto_data, timestamp)

        return {
            "statusCode": 200,
            "body": "Data saved successfully",
        }
    
    except Exception as e:
        raise ValueError(f"An error occurred: {str(e)}")