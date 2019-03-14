# Reformat Freesurfer's subcortical volume measurement files to CSV

import re
import sys
import os
import pandas

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

