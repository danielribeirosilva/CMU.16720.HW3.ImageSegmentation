clear all; addpath('lib'); addpath('lib/fastkmeans');
load('datapaths.mat'); % load data paths

%Number of dictionary words
K = 125;

%% extract dictionaries for iCoseg
impath = 'data/iCoseg';
outdir = genDir('siftDictionaries/iCoseg');

count = 1;
for iCls = 1:icoseg.lcls
    
	imlist = icoseg.trainimgs{iCls};
    category = icoseg.cls{iCls};
    
    fprintf('\n# processing iCoseg category %s: %i / %i\n', category, count, icoseg.lcls);
    
    %concat all sift features from images
    imgPaths = cell(numel(imlist),1);
    allFeatures = [];
    for iIm = 1:numel(imlist)
        [path,name,ext] = fileparts(imlist{iIm});
        imgPath = fullfile([impath,'/',category],[name,ext]);
        I = imread(imgPath);
        [~,d] = dsift(I);
        allFeatures = [allFeatures d];
    end
    
    %compute dictionary
    siftDictionary = fastkmeans(double(allFeatures'),K);
    
    %save dictionary
    savepath = genDir(fullfile(outdir, category));
    savename = fullfile(savepath,['siftDictionary','.mat']);
    save(savename, 'siftDictionary');
    
    count = count + 1;
end