import re
import os
import sys
import pandas

outdir = sys.argv[1]


##############################################################################
# Subfields files - join lh and rh
for fbase in [
    'hipposubfields.lh.T1.v21.stats.csv',
    'hipposubfields.lh.T1.v21.MMAP.stats.csv',
    'hipposubfields.lh.T1.v21.MMHBT.stats.csv',
    'thalamic-nuclei.lh.v10.T1.stats.csv',
    'amygdalar-nuclei.lh.T1.v21.stats.csv'
    ]:

    L = pandas.read_csv(os.path.join(outdir,fbase))
    R = pandas.read_csv(os.path.join(outdir,fbase.replace('.lh.','.rh.')))

    Y = pandas.concat((L,R),axis=1)
    Y.to_csv(os.path.join(outdir,fbase.replace('.lh.','.')),index=False)

    os.remove(os.path.join(outdir,fbase))
    os.remove(os.path.join(outdir,fbase.replace('.lh.','.rh.')))


##############################################################################
# aseg file - replace some characters in region labels
fname = os.path.join(outdir,'aseg.csv')
X = pandas.read_csv(fname)
X.rename(columns=lambda x: x.lower()
                            .replace('-','_')
                            .replace('&','')
                            .replace('3rd','third')
                            .replace('4th','fourth')
                            .replace('5th','fifth'),
         inplace=True)
X.drop(labels=X.columns[0],axis=1,inplace=True)
X.to_csv(fname,index=False)


##############################################################################
# parc files - drop extra fields and replace characters in region labels.
# Also rename with atlas info
rx = re.compile('(.+)-(area|thickness|volume)\.csv')
for fbase in [
    'aparc-area.csv',
    'aparc-thickness.csv',
    'aparc-volume.csv',
    'aparc.DKTatlas-area.csv',
    'aparc.DKTatlas-thickness.csv',
    'aparc.DKTatlas-volume.csv',
    'aparc.a2009s-area.csv',
    'aparc.a2009s-thickness.csv',
    'aparc.a2009s-volume.csv',
    'aparc.pial-area.csv',
    'aparc.pial-thickness.csv',
    'aparc.pial-volume.csv',
    'BA_exvivo-area.csv',
    'BA_exvivo-thickness.csv',
    'BA_exvivo-volume.csv'
    ]:

    r = rx.search(fbase)
    tag = r.groups(0)[0].lower().replace('.','_') + '_'

    L = pandas.read_csv(os.path.join(outdir,'lh-'+fbase))
    L.drop(labels=[L.columns[0],'BrainSegVolNotVent','eTIV'],axis=1,inplace=True)
    L.rename(columns=lambda x: tag + x.lower()
                                      .replace('-','_')
                                      .replace('&',''),
             inplace=True)
         
    R = pandas.read_csv(os.path.join(outdir,'rh-'+fbase))
    R.drop(labels=[R.columns[0],'BrainSegVolNotVent','eTIV'],axis=1,inplace=True)
    R.rename(columns=lambda x: tag + x.lower()
                                      .replace('-','_')
                                      .replace('&',''),
             inplace=True)

    Y = pandas.concat((L,R),axis=1)
    Y.to_csv(os.path.join(outdir,fbase),index=False)

    os.remove(os.path.join(outdir,'lh-'+fbase))
    os.remove(os.path.join(outdir,'rh-'+fbase))
    