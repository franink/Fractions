# -*- coding: utf-8 -*-
"""
Created on Wed Aug  1 19:41:39 2012

@author: frankkanayet
"""

from mvpa2 import cfg
from mvpa2.suite import *
import numpy as np
import pylab as pl
import glob
import os
import scipy.io
from scipy.io import loadmat
from scipy.spatial.distance import squareform,pdist
from scipy.stats import rankdata,pearsonr

#Laptop
path = '/Volumes/LaCie/fMRI/Fractions'
#Desktop
path = '/fMRI/Fractions'
os.chdir(path)

LABELS = ['Sum_0', 'Sum_1', 'Comp_0', 'Comp_1', 'Nline_0', 'Nline_1', 'Dots_0', 'Dots_1']

# set up the various targets
targets = ['FRACTION', 'NUM', 'DENOM', 'SUM', 'DIFFERENCE']

# and set up tasks
tasks = ['sum','comp','nline','dots']

#and set up subjects
SUBNUM = ['s_01010', 's_01003']
#SUBNUM = ['s_01010']

#Runs
RUNS = ['0', '1']

nr = len(SUBNUM)


#ROIS = glob.glob('ROI/*_25.nii.gz')
#ROIS.sort()
ROIS = ['ROI/IPS_L_12mSphere.nii.gz', 'ROI/IPS_R_12mSphere.nii.gz']
#ROIS = ['/fMRI/lottery/ROI/Area20.nii.gz']

field_names = []
#for ROI in ROIS:
#    roi = ROI.index('_')
#    field_names.append(ROI[4:roi])
# previous has to be commented out for IPS
# next has to be uncommented for IPS
for ROI in ROIS:
    roi = ROI.index('1')
    field_names.append(ROI[4:roi-1])        


# fix the DSMeasure
# This is the newest version but I need to learn how to extract the brain DSM from this
#class CustomCorrMeasure(Measure):
#    def __init__(self, ind_data, use_rank=True):
#        Measure.__init__(self)
#        self._ind_data = ind_data
#        self._use_rank = use_rank
#        if self._use_rank:
#            # rank the ind data
#            self._ind_data = rankdata(self._ind_data)
#    def __call__(self, dataset):
#        # calc dist for neural data
#        ndist = pdist(dataset.samples, metric='correlation')
#        # rank it
#        if self._use_rank:
#            ndist = rankdata(ndist)
#        # compare it
#        r,p = pearsonr(ndist, self._ind_data)
#        # convert to z
#        return np.arctan(r)
# little helper function to plot dissimilarity matrices
def plot_mtx(mtx, labels, title):
    pl.figure()
    pl.imshow(mtx, interpolation='nearest')
    pl.xticks(range(len(mtx)), labels, rotation=-90)
    pl.yticks(range(len(mtx)), labels)
    pl.title(title)
    pl.clim((0,1))
    pl.colorbar()

brain_mat_dict = {}
for ROI in ROIS:
    brain_mat_dict[ROI] = []
    for s in SUBNUM:
        print s
        subjpath = path + '/' + s
        print subjpath
        #os.chdir(subjpath)
        print ROI
        brain_task = subjpath + '/2ndLevel_MainEffectsSMOOTH_Runs.gfeat/all_cons.nii.gz'
        mat_name = s+' '+ROI[4:9]+'Cons DSM'
        print brain_task
        
        # define dataset and pick a specific mask (here target is irrelevant)
        ds = fmri_dataset(brain_task, mask=ROI)
        
        
        # define the comparison
        dsm = measures.rsa.PDist(square=True)
        
        res = dsm(ds)
        
        plot_mtx(res, LABELS, mat_name)
                    
        #Grab the square brain matrix
        brain_mat = dsm(ds).samples
        
        #brain_mat = rankdata(brain_map) right now I am not using this but probably should
        # check if previous step is correct before using
        brain_mat_dict[ROI].append(brain_mat)

field_name_dict = {}
for name in range(0, len(field_names)):
    field_name_dict[field_names[name]] = brain_mat_dict[ROIS[name]]

