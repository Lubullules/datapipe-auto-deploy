import os
from datetime import datetime, timezone
import pandas as pd
import awswrangler as wr

BUCKET_NAME = os.getenv("BUCKET_NAME")

def lambda_handler(event, context):

    try:
        # Get the POSIX timestamp from the event and format it
        timestamp = event.get('wf_timestamp', None)

        if timestamp is None:
            raise ValueError('No timestamp provided')
        
        timestamp = datetime.fromtimestamp(timestamp, tz=timezone.utc).strftime('%Y%m%d-%H%M%S')

        # Read the data from the partition
        df = wr.s3.read_parquet(
            path=f's3://{BUCKET_NAME}/raw/data-{timestamp}.parquet',
            dataset=False,
        )

        # Drop the 'rank' column
        df.drop(columns=['rank'], inplace=True)

        # Set '' to None and convert to float
        keys_to_float = ['price_usd', 'percent_change_24h', 'percent_change_1h', 'percent_change_7d', 'price_btc', 'market_cap_usd', 'volume24', 'volume24a', 'csupply', 'tsupply', 'msupply']
        for key in keys_to_float:
            df[key] = pd.to_numeric(df[key], errors='coerce')

        # Write the data to the partition
        wr.s3.to_parquet(
            df=df,
            path=f's3://{BUCKET_NAME}/processed/processed_data-{timestamp}.parquet',
            dataset=False,
        )

        return {
            "statusCode": 200,
            "body": "Data processed successfully"
        }

    except Exception as e:
        raise Exception(f"An error occurred: {str(e)}")