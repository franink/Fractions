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

debug.active += ["SLC"]

path = '/Volumes/LaCie/fMRI/Fractions'
os.chdir(path)
#subjects = ['s_01010', 's_01003', 's_01008','s_01009', 's_01004', 's_01005','s_01006','s_01007']
            
subjects = ['s_01010', 's_01003']

LABELS = ['1-6', '2-9', '5-21', '4-16', '6-24', '2-6', '9-27', '12-22',
          '6-9', '2-3', '15-21', '5-7', '3-4', '7-8']

targets = ['Fraction', 'Numerator', 'Denominator', 'Sum', 'Difference']
            

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

##ROI Still need to make it
#for s in subjects:
#    subjpath = path + '/' + s + '/2ndLevel_AllCond.gfeat'
#    print subjpath
#    os.chdir(subjpath)
#    for MODEL in targets:
#        # pick a specific mask
#        ds = fmri_dataset('all_positivebetas.nii.gz',mask='mask.nii.gz')
#
#        # define the comparison
#        dsmetric = CustomCorrMeasure(squareform(x[MODEL]), use_rank=True)
#
#        sl = sphere_searchlight(dsmetric, radius=3)
#
#        sl.nproc = 4
#
#        sl_map = sl(ds)
#
#        # save it out
#        filename = '/Volumes/LaCie/fMRI/lottery/Searchlight_Ranked_Positive/'+MODEL+'_SL_'+s+'.nii.gz'
#        print filename
#        map2nifti(ds,sl_map.samples).to_filename(filename)

#Searchlight
for s in subjects:
    subjpath = path + '/' + s + '/2ndLevel_AllCond.gfeat'
    print subjpath
    os.chdir(subjpath)
    for MODEL in targets:
        # pick a specific mask
        ds = fmri_dataset('all_betas.nii.gz',mask='mask.nii.gz')

        # define the comparison
        dsmetric = CustomCorrMeasure(squareform(x[MODEL]), use_rank=True)

        sl = sphere_searchlight(dsmetric, radius=3)

        sl.nproc = 4

        sl_map = sl(ds)

        # save it out
        filename = '/Volumes/LaCie/fMRI/Fractions/Searchlight_Ranked/'+MODEL+'_SL_'+s+'.nii.gz'
        print filename
        map2nifti(ds,sl_map.samples).to_filename(filename)

