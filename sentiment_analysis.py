import spacy
import re
from nltk.sentiment.vader import SentimentIntensityAnalyzer
import nltk
nltk.download('vader_lexicon')
nltk.download('punkt_tab')


sentence = "Solana is cool but Ethereum is trash. I like Bitcoin though. But Still Solana make me nervous."
cryptos = ["solana", "ethereum", "bitcoin"]

analyzer = SentimentIntensityAnalyzer()

# Découper la phrase autour des conjonctions contrastives
parts = re.split(r"\bbut\b|\bhowever\b|\balthough\b|\bwhereas\b|[;,.]\s*", sentence.lower())

results = {}

for part in parts:
    print(part)
    for crypto in cryptos:
        if crypto in part:
            score = analyzer.polarity_scores(part)
            results[crypto] = score

print(results)