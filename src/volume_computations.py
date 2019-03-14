# Reformat Freesurfer's subcortical volume measurement files to CSV

import re
import sys
import os
import pandas
import numpy

statsdir = sys.argv[1]
outdir = sys.argv[2]

fnames = [
    'hipposubfields.lh.T1.v21.stats',
    'hipposubfields.rh.T1.v21.stats',
    'amygdalar-nuclei.lh.T1.v21.stats',
    'amygdalar-nuclei.rh.T1.v21.stats',
    'thalamic-nuclei.lh.v10.T1.stats',
    'thalamic-nuclei.rh.v10.T1.stats',
    'brainstem.v12.stats'
    ]
    
rx = re.compile('.+?\.(lh|rh)\..+')

for fname in fnames:

    X = pandas.read_csv(os.path.join(statsdir,fname),
        sep=' ',header=None,skiprows=1,skipinitialspace=True)

    hemi = rx.search(fname)
    if hemi is None:
        hemi = ''
    else:
        hemi = hemi.groups(0)[0] + '_'

    X = pandas.DataFrame(X[3].values.reshape(1,X[3].size),columns=X[4])
    
    X.rename(columns=lambda x: hemi + x.lower()
                                       .replace('-','_')
                                       .replace('(','_')
                                       .replace(')','_')
                                       .replace(' ','_'), 
             inplace=True)
    
    X.to_csv(os.path.join(outdir,fname+'.csv'),index=False)


# Read hippocampus info and compute MM volumes
anterior = [
    'presubiculum_head',
    'subiculum_head',
    'ca1_head',
    'ca3_head',
    'ca4_head',
    'gc_ml_dg_head',
    'molecular_layer_hp_head'
]
posterior = [
    'hippocampal_tail',
    'presubiculum_body',
    'subiculum_body',
    'ca1_body',
    'ca3_body',
    'ca4_body',
    'gc_ml_dg_body',
    'molecular_layer_hp_body'
]
for hemi in ('lh','rh'):

    X = pandas.read_csv(os.path.join(outdir,
        'hipposubfields.'+hemi+'.T1.v21.stats.csv'))

    y = numpy.concatenate((X[[hemi + '_' + x for x in anterior]].sum(1).values,
                           X[[hemi + '_' + x for x in posterior]].sum(1).values))

    Y = pandas.DataFrame( y.reshape(1,2),
        columns=[hemi+'_anterior_hippocampus',
                 hemi+'_posterior_hippocampus'] )
                 
    Y.to_csv(os.path.join(outdir,'hipposubfields.'+hemi+'.T1.v21.MMAP.stats.csv'),
        index=False)


# Repeat for MMHBT
head_ca = [
    'subiculum_head',
    'ca1_head',
    'ca3_head',
    'molecular_layer_hp_head'
]
head_dg = [
    'ca4_head',
    'gc_ml_dg_head'
]
head_subiculum = [
    'presubiculum_head'
]
body_ca = [
    'subiculum_body',
    'ca1_body',
    'ca3_body',
    'molecular_layer_hp_body'
]
body_dg = [
    'ca4_body',
    'gc_ml_dg_body'
]
body_subiculum = [
    'presubiculum_body'
]
tail = [
    'hippocampal_tail'
]
for hemi in ('lh','rh'):

    X = pandas.read_csv(os.path.join(outdir,
        'hipposubfields.'+hemi+'.T1.v21.stats.csv'))

    y = numpy.concatenate((X[[hemi + '_' + x for x in head_ca]].sum(1).values,
                           X[[hemi + '_' + x for x in head_dg]].sum(1).values,
                           X[[hemi + '_' + x for x in head_subiculum]].sum(1).values,
                           X[[hemi + '_' + x for x in body_ca]].sum(1).values,
                           X[[hemi + '_' + x for x in body_dg]].sum(1).values,
                           X[[hemi + '_' + x for x in body_subiculum]].sum(1).values,
                           X[[hemi + '_' + x for x in tail]].sum(1).values ))

    Y = pandas.DataFrame( y.reshape(1,7),
        columns=[hemi+'_head_ca',
                 hemi+'_head_dg',
                 hemi+'_head_subiculum',
                 hemi+'_body_ca',
                 hemi+'_body_dg',
                 hemi+'_body_subiculum',
                 hemi+'_hippocampal_tail'] )
                 
    Y.to_csv(os.path.join(outdir,'hipposubfields.'+hemi+'.T1.v21.MMHBT.stats.csv'),
        index=False)
