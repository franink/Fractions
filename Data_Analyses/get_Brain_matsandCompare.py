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

LABELS = ['1-6', '2-9', '5-21', '4-16', '6-24', '2-6', '9-27', '12-22',
          '6-9', '2-3', '15-21', '5-7', '3-4', '7-8']

# set up the various targets
targets = ['FRACTION', 'NUM', 'DENOM', 'SUM', 'DIFFERENCE']

# and set up tasks
tasks = ['sum','comp','nline','dots']

#and set up subjects
SUBNUM = ['s_01010', 's_01003']
#SUBNUM = ['s_01010']

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
    pl.xticks(range(len(mtx)), labels, rotation=-45)
    pl.yticks(range(len(mtx)), labels)
    pl.title(title)
    pl.clim((0,1))
    pl.colorbar()

brain_mat_dict = {}
for ROI in ROIS:
    brain_mat_dict[ROI] = []
    for s in SUBNUM:
        print s
        subjpath = path + '/' + s + '/2ndLevel_AllCond.gfeat'
        print subjpath
        #os.chdir(subjpath)
        print ROI
        for TASK in tasks:
            brain_task = subjpath + '/' + TASK + '_allT.nii.gz'
            mat_name = s+' '+TASK+' '+ROI+' DSM'
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

#fou = open('Brain_mats_IPS.mat', 'w')
#scipy.io.savemat(fou, mdict = field_name_dict)
#fou.close()

## Rest of code is for doing this for multiple brain ROI's from atlas
#roi_names = {'Area0': 'Frontal_Pole',
#             'Area1': 'Insular_Cortex',
#             'Area2': 'Superior_Frontal_Gyrus',
#             'Area3': 'Middle_Frontal_Gyrus',
#             'Area4': 'Inferior_Frontal_Gyrus1',
#             'Area5': 'Inferior_Frontal_Gyrus2',
#             'Area6': 'Precentral_Gyrus',
#             'Area7': 'Temporal_Pole',
#             'Area8': 'Superior_Temporal_Gyrus_Ant',
#             'Area9': 'Superior_Temporal_Gyrus_Pos',
#             'Area10': 'Middle_Temporal_Gyrus_Ant',
#             'Area11': 'Middle_Temporal_Gyrus_Pos',
#             'Area12': 'Inferior_Temporal_Gyrus_Ant',
#             'Area13': 'Inferior_Temporal_Gyrus_TempOcc',             
#             'Area14': 'Inferior_Temporal_Gyrus_Pos',
#             'Area15': 'Inferior_Temporal_Gyrus_TempOcc',
#             'Area16': 'Postcentral_Gyrus',
#             'Area17': 'Superior_Parietal_Lobule',
#             'Area18': 'Supramarginal_Gyrus_Ant',
#             'Area19': 'Supramarginal_Gyrus_Pos',
#             'Area20': 'Angular_Gyrus',
#             'Area21': 'Lateral_Occipital_Cortex_Sup',
#             'Area22': 'Lateral_Occipital_Cortex_Inf',
#             'Area23': 'Intracalcarine_Cortex',
#             'Area24': 'Frontal_Medial_Cortex',
#             'Area25': 'Juxtapositional_Lobule',
#             'Area26': 'Subcallosal_Cortex',
#             'Area27': 'Paracingulate_Gyrus',
#             'Area28': 'Paracingulate_Gyrus',
#             'Area29': 'ACC',
#             'Area30': 'PCC',
#             'Area31': 'Cuneal_Cortex',
#             'Area32': 'OFC',
#             'Area33': 'Parahippocampal_Gyrus_Ant',
#             'Area34': 'Parahippocampal_Gyrus_Pos',
#             'Area35': 'Lingual_Gyrus',
#             'Area36': 'Temporal_Fusiform_Cortex_Ant',
#             'Area37': 'Temporal_Fusiform_Cortex_Pos',
#             'Area38': 'Temporal_Occipital_Fusiform_Cortex',
#             'Area39': 'Occipital_Fusiform_Gyrus',
#             'Area40': 'Frontal_Opercular_Cortex',
#             'Area41': 'Central_Opercular_Cortex',
#             'Area42': 'Parietal_Opercular_Cortex',
#             'Area43': 'Planum_Polare',
#             'Area44': 'Heschls_Gyrus',
#             'Area45': 'Planum_Temporale',
#             'Area46': 'Supracalcarine_Cortex',
#             'Area47': 'Occipital_Pole',
#             'SubArea10': 'Left_Accumbens',
#             'SubArea15': 'Right_Causate',
#             'SubArea16': 'Right_Putamen',
#             'SubArea17': 'Right_Pallidum',
#             'SubArea18': 'Right_Hippocampus',
#             'SubArea19': 'Right_Amygdala',
#             'SubArea20': 'Right_Accumbens',
#             'SubArea4': 'Left_Caudate',
#             'SubArea5': 'Left_Putamen',
#             'SubArea6': 'Left_Putamen',
#             'SubArea8': 'Left_Hippocampus',
#             'SubArea9': 'Left_Amygdala',
#             'IPS': 'IPS'}
#areas_names = []
#for area in field_names:
#    areas_names.append(roi_names[area])
#field_name_dict2 = {}
#for name in range(0, len(field_names)):
#    field_name_dict2[areas_names[name]] = brain_mat_dict[ROIS[name]]
#fou = open('Corrected2_Positivebrain_mats.mat', 'w')
#scipy.io.savemat(fou, mdict = field_name_dict2)
#fou.close()
