import os
import pandas
import awswrangler as wr
import nltk


BUCKET_NAME = "project-data-finance-dev-eu-west-1"

def dataframe_cleanup(df):

    # Remove all columns except 'title', 'selftext' and 'id'
    df = df[['title', 'selftext', 'id']]

    # Append 'title' and 'selftext' into a new column 'text'
    df['text'] = df['title'] + '\n\n' + df['selftext']

    # In the 'text' column, remove all text effects and link insertions
    df['text'] = df['text'].str.replace(r'(\*\*|__)(.*?)\1', '', regex=True)  # Bold
    df['text'] = df['text'].str.replace(r'(\*|_)(.*?)\1', '', regex=True)  # Italic
    df['text'] = df['text'].str.replace(r'~~(.*?)~~', '', regex=True)  # Strikethrough
    df['text'] = df['text'].str.replace(r'\[(.*?)\]\(.*?\)', r'\1', regex=True)  # Links
    df['text'] = df['text'].str.replace(r'!\[.*?\]\(.*?\)', '', regex=True)  # Images
    df['text'] = df['text'].str.replace(r'&[a-zA-Z0-9#]+;', '', regex=True)  # HTML entities
    df['text'] = df['text'].str.replace(r'http\S+|www\S+|https\S+', '', regex=True)  # URLs
    df['text'] = df['text'].str.replace(r'@\w+', '', regex=True)  # Mentions
    df['text'] = df['text'].str.replace(r'#[\w-]+', '', regex=True)  # Hashtags

    # Put the 'text' column to lowercase
    df['text'] = df['text'].str.lower()

    # Remove all rows with NaN or empty values in 'text'
    df = df[df['text'].notna() & (df['text'] != '')]

    return df

def sentiment_analysis_and_counting_process(reddit_df, coinlore_df):

    # Initialize the Sentiment Intensity Analyzer
    nltk.download('vader_lexicon')
    sia = nltk.sentiment.vader.SentimentIntensityAnalyzer()

    processed_df = coinlore_df[['id', 'name', 'nameid', 'wf_timestamp']]

    # Put 'name', 'symbol' and 'name-id' to lowercase
    processed_df['name'] = processed_df['name'].str.lower()
    processed_df['nameid'] = processed_df['nameid'].str.lower()

    # Add columns "count" and "average_sentiment" to the processed_df
    processed_df['count'] = 0
    processed_df['average_sentiment'] = 0.0

    # Iterate over the rows of df
    for _, row in reddit_df.iterrows():

        # If in the 'text', there is a mention of a term from the 'processed_df' dataframe
        for _, coin_row in processed_df.iterrows():
            if coin_row['name'] in row['text'] or coin_row['nameid'] in row['text']:

                # Increment the count for that coin
                processed_df.loc[processed_df['id'] == coin_row['id'], 'count'] += 1

                # Calculate the sentiment score
                sentiment_score = sia.polarity_scores(row['text'])['compound']

                # Add the sentiment score to the average sentiment for that coin
                processed_df.loc[processed_df['id'] == coin_row['id'], 'average_sentiment'] += sentiment_score

    # Calculate the average sentiment for each coin
    processed_df['average_sentiment'] = processed_df['average_sentiment'] / processed_df['count']
    
    return processed_df

def lambda_handler(event, context):

    try:
        # Get the POSIX timestamp from the event and format it
        timestamp = event.get('wf_timestamp', None)

        if timestamp is None:
            raise ValueError('No timestamp provided')

        # Read the data from the partition
        reddit_df = wr.s3.read_parquet(
            path=f's3://{BUCKET_NAME}/reddit/raw/wf_timestamp={timestamp}',
            dataset=True,
        )

        # Read the CoinLore data from the partition
        coinlore_df = wr.s3.read_parquet(
            path=f's3://{BUCKET_NAME}/processed/wf_timestamp={timestamp}',
            dataset=True,
        )

        reddit_df = dataframe_cleanup(reddit_df)

        processed_df = sentiment_analysis_and_counting_process(reddit_df, coinlore_df)

        # Duplicate the 'wf_timestamp' column to keep after partitioning
        processed_df['wf_timestamp_partition'] = processed_df['wf_timestamp'].astype(str)

        # Write the data to the partition
        wr.s3.to_parquet(
            df=processed_df,
            path=f's3://{BUCKET_NAME}/reddit/processed/',
            dataset=True,
            partition_cols=['wf_timestamp_partition'],
            mode='append',
            index=False
        )

        return {
            "statusCode": 200,
            "body": "Data processed successfully"
        }

    except Exception as e:
        raise Exception(f"An error occurred: {str(e)}")