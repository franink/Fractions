# -*- coding: utf-8 -*-
"""
Created on Fri Aug 10 00:46:30 2012

@author: frankkanayet
"""
import scipy.io
import numpy as np
import scipy.stats
from scipy.spatial.distance import squareform,pdist
import os

path = '/Volumes/LaCie/fMRI/Fractions'
os.chdir(path)

#subjects used
SUBNUM = ['s_01010', 's_01003']

LABELS = ['1-6', '2-9', '5-21', '4-16', '6-24', '2-6', '9-27', '12-22',
          '6-9', '2-3', '15-21', '5-7', '3-4', '7-8']

# set up the various targets
targets = ['FRACTION', 'NUM', 'DENOM', 'SUM', 'DIFFERENCE']

# and set up tasks
tasks = ['sum','comp','nline','dots']

## Load Model Mats
models = scipy.io.loadmat('/Volumes/LaCie/fMRI/Fractions/Rank_model_mats.mat')

## Load BrainMats
brains = {}
#brains = scipy.io.loadmat('/Volumes/LaCie/fMRI/lottery/Corrected2_SmallPositivebrain_mats.mat')
## Next line for whole brain instead of ROI
#wholebrain = scipy.io.loadmat('/Volumes/LaCie/fMRI/lottery/Corrected2_SmallPositiveWholebrain_mats.mat')
ips2 = scipy.io.loadmat('/Volumes/LaCie/fMRI/Fractions/Brain_mats_IPS.mat')
brains = {}
## loop over each area and do a correlation with each model matrix and store the 8 brain-model
## correlation in a dictionary Dict['area'] = [r1, r2, r3,etc
#brains.pop('__globals__')
#brains.pop('__header__')
#brains.pop('__version__')
ips2.pop('__globals__')
ips2.pop('__header__')
ips2.pop('__version__')
models.pop('__globals__')
models.pop('__header__')
models.pop('__version__')
#wholebrain.pop('__globals__')
#wholebrain.pop('__header__')
#wholebrain.pop('__version__')

brains['IPS_L'] = ips2['IPS_L']
brains['IPS_R'] = ips2['IPS_R']
#brains['Whole_Brain'] = wholebrain['Whole_Brain']
#for MODEL in models:
#    models[MODEL] = models[MODEL].flatten()
brainsNEW = {}
for ROI in brains:
    brainsNEW[ROI] = {}
    for SUB in range (0, len(SUBNUM)):
        for TASK in range (0, len(tasks)):
            ind = (SUB*4)+TASK
            mat_name = tasks[TASK]+'_'+SUBNUM[SUB]
            brainsNEW[ROI][mat_name] = []
            brainsNEW[ROI][mat_name] = brains[ROI][ind]


for MODEL in models:
    print MODEL
    #extract upper triangle
    models[MODEL] = squareform(models[MODEL])
    #print 'model', models[MODEL].shape
    
    
for ROI in brainsNEW:
    for SUB in SUBNUM:
        for TASK in tasks:
            mat_name = TASK+'_'+SUB
            #extract upper triangle
            brainsNEW[ROI][mat_name] = squareform(brainsNEW[ROI][mat_name])


CorrelationDict = {}
for ROI in brainsNEW:
    CorrelationDict[ROI] = {}
    for MODEL in models:
        CorrelationDict[ROI][MODEL] = {}
        #models[MODEL] = models[MODEL].flatten()
        for SUB in brainsNEW[ROI]:
            CorrelationDict[ROI][MODEL][SUB] = []
            tmp_results = []
            print SUB
            print MODEL
            print ROI
            #brainsNEW[ROI][SUB] = brainsNEW[ROI][SUB].flatten()
            print models[MODEL].shape
            print brainsNEW[ROI][SUB].shape
            tmp_rho, tmp_p = scipy.stats.spearmanr(models[MODEL],brainsNEW[ROI][SUB])
            print tmp_rho
            ##transforms rho's to fisher Z...
            tmp_z = 0.5*np.log((1 + tmp_rho)/(1 - tmp_rho))
            print tmp_z
            tmp_results.append((tmp_rho, tmp_z, tmp_p))
            #print tmp_results
            CorrelationDict[ROI][MODEL][SUB].append((tmp_rho, tmp_z, tmp_p))


fou = open('/Volumes/LaCie/fMRI/Fractions/IPS_Brains-model_correlations.mat', 'w')
#fou = open('Corrected_WholebrainsIPS2-model_correlations.mat', 'w')
scipy.io.savemat(fou, mdict = CorrelationDict)
fou.close()
## Now I have to implement either paired t-tests for number vs value, or implement
## a repeated measures ANOVE 2x2x2(valuevsnumber, log vs lin, abs vs negative).

## Paired Ttest implementation

#tTestResultsDict = {}
#for ROI in CorrelationDict:
#    tTestResultsDict[ROI] = {}
#    for MODEL1 in models:
#        for MODEL2 in models:
#            if MODEL2 != MODEL1:
#                name = MODEL1+'-'+MODEL2
#                tTestResultsDict[ROI][name] = []
#                model_1 = []
#                model_2 = []
#                for SUB in range(0, len(CorrelationDict[ROI][MODEL1])):
#                    model_1.append(CorrelationDict[ROI][MODEL1][SUB][1])
#                    model_2.append(CorrelationDict[ROI][MODEL2][SUB][1])
#                t, p = scipy.stats.stats.ttest_rel(model_1,model_2)
#                tTestResultsDict[ROI][name].append((t,p))
#
#fou = open('/Volumes/LaCie/fMRI/lottery/Corrected2_SmallPositivemodel-model_tTests.mat', 'w')
##fou = open('Corrected_model-model_tTests_Wholebrain.mat', 'w')
#scipy.io.savemat(fou, mdict = tTestResultsDict)
#fou.close()