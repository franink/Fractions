"""
Representation Similarity Analysis Excitement!
"""
import os
import pandas as pd
import numpy as np
from scipy.spatial.distance import cdist
from scipy.stats.stats import rankdata
from scipy import io
import copy

filepath = '/Users/frankkanayet/Dropbox/FractionExperiment'
os.chdir(filepath)
fracts = pd.read_csv('fraction_list_14.csv', names = ['num', 'denom'])

# set up the various targets
LABELS = ['1/6', '2/9', '5/21', '4/16', '6/24', '2/6', '9/27', '12/22', '6/9',
          '2/3', '15/21', '5/7', '3/4', '7/8']
n_values = len(LABELS)

NUM = []
DENOM = []
FRACTION = []
DIFFERENCE = []
SUM = []
for frac in range(n_values):
    NUM.append(np.array([fracts.iloc[frac]['num'],1]))
    DENOM.append(np.array([fracts.iloc[frac]['denom'],1]))
    FRACTION.append(np.array([float(fracts.iloc[frac]['num'])/float(fracts.iloc[frac]['denom']),1]))
    DIFFERENCE.append(np.array([fracts.iloc[frac]['num']- fracts.iloc[frac]['denom'],1]))
    SUM.append(np.array([fracts.iloc[frac]['num']+ fracts.iloc[frac]['denom'],1]))

MATS = ['NUM', 'DENOM', 'FRACTION', 'DIFFERENCE', 'SUM']
MAT_DICT = {}
MAT_DICT['NUM'] = NUM
MAT_DICT['DENOM'] = DENOM
MAT_DICT['FRACTION'] = FRACTION
MAT_DICT['DIFFERENCE'] = DIFFERENCE
MAT_DICT['SUM'] = SUM

model_mats = {}
for MAT in MAT_DICT.keys():
    tmp = []
    print MAT    
    mat = cdist(MAT_DICT[MAT], MAT_DICT[MAT])
    model_mats[MAT] = mat

for MAT in model_mats.keys():
    M_name = 'RANK_'+MAT
    print M_name
    model_mats[M_name] = rankdata(model_mats[MAT])
    model_mats[M_name] = np.reshape(model_mats[M_name],(n_values, n_values))
    
fou = open('/Volumes/LaCie/fMRI/Fractions/Rank_model_mats.mat', 'w')
io.savemat(fou, mdict = model_mats)
fou.close()