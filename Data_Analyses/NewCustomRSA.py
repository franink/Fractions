"""
Representation Similarity Analysis Excitement!
"""

import os
import pprocess
from mvpa2.suite import *
from scipy.io import loadmat
from scipy.spatial.distance import squareform,pdist
from scipy.stats import rankdata,pearsonr
import numpy as np

if __debug__:
    from mvpa2.base import debug
    debug.active += ["SVS", "SLC"]
    
#debug.active += ["SLC"]

path = '/Volumes/LaCie/fMRI/Fractions'
os.chdir(path)
#subjects = ['s_01010', 's_01003', 's_01008','s_01009', 's_01004', 's_01005','s_01006','s_01007']
            
subjects = ['s_01010', 's_01003']

LABELS = ['1-6', '2-9', '5-21', '4-16', '6-24', '2-6', '9-27', '12-22',
          '6-9', '2-3', '15-21', '5-7', '3-4', '7-8']

targets = ['FRACTION', 'NUM', 'DENOM', 'SUM', 'DIFFERENCE']
            

class CustomCorrMeasure(Measure):
    def __init__(self, ind_data, use_rank=True):
        Measure.__init__(self)
        self._ind_data = ind_data
        self._use_rank = use_rank
        if self._use_rank:
            # rank the ind data
            self._ind_data = rankdata(self._ind_data)
    def __call__(self, dataset):
        # calc dist for neural data
        ndist = pdist(dataset.samples, metric='correlation')
        # rank it
        if self._use_rank:
            ndist = rankdata(ndist)
        # compare it
        r,p = pearsonr(ndist, self._ind_data)
        # convert to z
        return np.arctan(r)
        
# load mat
x = loadmat('Rank_model_mats.mat')

tasks = ['sum','comp','nline','dots']


#Searchlight
for s in subjects:
    print s
    subjpath = path + '/' + s + '/2ndLevel_AllCond.gfeat'
    print subjpath
    os.chdir(subjpath)
    for MODEL in targets:
        print MODEL
        for TASK in tasks:
            brain_task = TASK + '_allT.nii.gz'
            print brain_task
            # pick a specific mask
            ds = fmri_dataset(brain_task,mask='mask.nii.gz')
    
            # define the comparison
            dsmetric = CustomCorrMeasure(squareform(x[MODEL]), use_rank=True)
    
            sl = sphere_searchlight(dsmetric, radius=3)
    
            sl.nproc = 4
    
            sl_map = sl(ds)
    
            # save it out
            filename = '/Volumes/LaCie/fMRI/Fractions/Searchlight_Ranked/'+MODEL+'_SL_'+TASK+'_'+s+'.nii.gz'
            print filename
            map2nifti(ds,sl_map.samples).to_filename(filename)

