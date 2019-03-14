% For REDCap, we need labels to be unique across all forms

files = {
	'BA_exvivo-area.csv'
	'BA_exvivo-thickness.csv'
	'BA_exvivo-volume.csv'
	'amygdalar-nuclei.T1.v21.stats.csv'
	'aparc-area.csv'
	'aparc-thickness.csv'
	'aparc-volume.csv'
	'aparc.DKTatlas-area.csv'
	'aparc.DKTatlas-thickness.csv'
	'aparc.DKTatlas-volume.csv'
	'aparc.a2009s-area.csv'
	'aparc.a2009s-thickness.csv'
	'aparc.a2009s-volume.csv'
	'aparc.pial-area.csv'
	'aparc.pial-thickness.csv'
	'aparc.pial-volume.csv'
	'aseg.csv'
	'brainstem.v12.stats.csv'
	'hipposubfields.T1.v21.MMAP.stats.csv'
	'hipposubfields.T1.v21.MMHBT.stats.csv'
	'hipposubfields.T1.v21.stats.csv'
	'thalamic-nuclei.v10.T1.stats.csv'
	};

clear F
labels = cell(0,1);
for f = 1:length(files)
	F{f} = readtable(['out/' files{f}]);
	labels = [labels F{f}.Properties.VariableNames];
end

[u,iu] = unique(labels);

dups = labels(~ismember((1:length(labels)),iu))';

dupfiles = [];
for d = dups'
	[~,q] = system(['grep -l ' d{1} ' out/*csv']);
	dupfiles = [dupfiles q];
end
D = strsplit(dupfiles,'\n')';
D = unique(D)


	