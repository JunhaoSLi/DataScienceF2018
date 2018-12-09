import os
import csv
import numpy as np

from tqdm import tqdm

from sklearn.utils import shuffle
from sklearn.model_selection import train_test_split

seed = 3535999445

def _checkpoint5(path):
    with open(path, encoding='utf_8') as f:
        f = csv.reader(f)
        statements = []
        results = []
        for i, line in enumerate(tqdm(list(f), ncols=80, leave=False)):
            statements.append(line[1])
            results.append(int(line[2]))
        return statements, results
    
def checkpoint5(data_dir, n_train=800, n_valid=199):
    statements, results = _checkpoint5(os.path.join(data_dir, 'training.csv'))
    test_statements, _ = _checkpoint5(os.path.join(data_dir, 'testing.csv'))
    tr_statements, va_statements, tr_results, va_results = train_test_split(statements, results, test_size=n_valid, random_state=seed)
    train_statements = []
    train_results = []
    for statement, result in zip(tr_statements, tr_results):
        train_statements.append(statement)
        train_results.append(result)
        
    val_statements = []
    val_results = []
    for statement, result in zip(va_statements, va_results):
        val_statements.append(statement)
        val_results.append(result)
    
    train_results = np.asarray(train_results, dtype=np.int32)
    val_results = np.asarray(val_results, dtype=np.int32)
    
    return (train_statements, train_results), (val_statements, val_results), test_statements