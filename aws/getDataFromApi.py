import urllib3
import os
import json
import pandas as pd
from datetime import datetime, timezone
import awswrangler as wr

# Config S3
BUCKET_NAME = os.getenv("BUCKET_NAME")
BASE_PATH = "raw/"  # File on S3

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

    # Format the timestamp as a string for the file name
    timestamp_str = datetime.fromtimestamp(timestamp, tz=timezone.utc).strftime("%Y%m%d-%H%M%S")


    # Name of the file and path
    file_name = f"data-{timestamp_str}.parquet"
    s3_path = f"s3://{BUCKET_NAME}/{BASE_PATH}{file_name}"

    # Save the data to S3
    wr.s3.to_parquet(df=df, path=s3_path, dataset=False)

def lambda_handler(event, context):
    try:
        # Get the timestamp
        timestamp = datetime.now(timezone.utc).timestamp()

        crypto_data = fetch_crypto_data()
        save_to_s3(crypto_data, timestamp)

        return {
            "statusCode": 200,
            "body": json.dumps({
                "message": "Data saved successfully",
            }),
            "wf_timestamp": timestamp
        }
    
    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }