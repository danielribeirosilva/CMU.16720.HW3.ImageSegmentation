clear all; addpath('lib'); addpath('lib/fastkmeans');
load('datapaths.mat'); % load data paths

%Number of dictionary words
K = 125;

alpha = 100;

%% extract dictionaries for iCoseg
impath = 'data/iCoseg';
outdir = genDir('siftDictionaries/iCoseg');

count = 1;
for iCls = 1:icoseg.lcls
    
	imlist = icoseg.trainimgs{iCls};
    category = icoseg.cls{iCls};
    
    fprintf('\n# processing iCoseg category %s: %i / %i\n', category, count, icoseg.lcls);
    fprintf('computing sift features...\n');
    
    %concat all sift features from images
    imgPaths = cell(numel(imlist),1);
    allFeatures = [];
    for iIm = 1:numel(imlist)
        
        %image data
        [path,name,ext] = fileparts(imlist{iIm});
        imgPath = fullfile([impath,'/',category],[name,ext]);
        I = imread(imgPath);
        
        %sift features
        [~,d] = dsift(I);
        
        % Random permutation of the features
        randind = randperm(size(d,2));
    
        allFeatures = [allFeatures d(:,randind(1:alpha))];
    end
    
    %compute dictionary
    fprintf('computing dictionary...\n');
    siftDictionary = fastkmeans(double(allFeatures'),K);
    
    %save dictionary
    savepath = genDir(fullfile(outdir, category));
    savename = fullfile(savepath,['siftDictionary','.mat']);
    save(savename, 'siftDictionary');
    
    count = count + 1;
end


%% extract dictionaries for MSRC
impath = 'data/MSRC';
outdir = genDir('siftDictionaries/MSRC');

count = 1;
for iCls = 1:msrc.lcls
    
	imlist = msrc.trainimgs{iCls};
    category = msrc.cls{iCls};
    
    fprintf('\n# processing MSRC category %s: %i / %i\n', category, count, msrc.lcls);
    fprintf('computing sift features...\n');
    
    %concat all sift features from images
    imgPaths = cell(numel(imlist),1);
    allFeatures = [];
    for iIm = 1:numel(imlist)
        
        %image data
        [path,name,ext] = fileparts(imlist{iIm});
        imgPath = fullfile([impath,'/',category],[name,ext]);
        I = imread(imgPath);
        
        %sift features
        [~,d] = dsift(I);
        
        % Random permutation of the features
        randind = randperm(size(d,2));
    
        allFeatures = [allFeatures d(:,randind(1:alpha))];
    end
    
    %compute dictionary
    fprintf('computing dictionary...\n');
    siftDictionary = fastkmeans(double(allFeatures'),K);
    
    %save dictionary
    savepath = genDir(fullfile(outdir, category));
    savename = fullfile(savepath,['siftDictionary','.mat']);
    save(savename, 'siftDictionary');
    
    count = count + 1;
end