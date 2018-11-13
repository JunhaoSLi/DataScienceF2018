import tensorflow as tf
from tensorflow import keras
import numpy as np
import string
import csv

def main(): 
with open("allegations_with_labels.csv") as csvfile:
    recent_complaints_array = np.array(list(csv.reader(csvfile)))[1:]

summaries = recent_complaints_array[:, 1]
labels = recent_complaints_array[:, 2]

table = str.maketrans({key: None for key in string.punctuation})
normalized_summaries = [s.translate(table).lower().split() for s in summaries]

all_summary_words = set([word for summary in normalized_summaries for word in summary])
words_map = {word: i for i, word in enumerate(all_summary_words)} 
vectorized_summaries = [[words_map[word] for word in summary] for summary in normalized_summaries]


if __name__ == "__main__":
    main()
