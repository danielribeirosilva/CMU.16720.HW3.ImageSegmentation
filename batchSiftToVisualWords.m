clear all; addpath('lib'); addpath('lib/fastkmeans');
load('datapaths.mat'); % load data paths



%% extract visual words for iCoseg
impath = 'data/iCoseg';
dicpath = 'siftDictionaries/iCoseg';
outdir = genDir('siftvisualwords/iCoseg');

count = 1;
for iCls = 1:icoseg.lcls
    imlist = icoseg.allimgs{iCls};
    
    category = icoseg.cls{iCls};
    
    load([dicpath,'/',category,'/siftDictionary.mat']);
    
    for iIm = 1:numel(imlist)
        
		fprintf('iCoseg %i - %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		savepath = genDir(fullfile(outdir, category));
		[path,name,ext] = fileparts(imlist{iIm});
		savename = fullfile(savepath,[name,'.mat']);
		
        I = imread(fullfile(impath, category, imlist{iIm}));
        siftVisualWord = getSiftVisualWords(I, siftDictionary);
        save(savename, 'siftVisualWord');
            
    end
    
    count = count + 1;
end


%% extract visual words for msrc
impath = 'data/msrc';
dicpath = 'siftDictionaries/MSRC';
outdir = genDir('siftvisualwords/MSRC');

count = 1;
for iCls = 1:msrc.lcls
    imlist = msrc.allimgs{iCls};
    
    category = msrc.cls{iCls};
    
    load([dicpath,'/',category,'/siftDictionary.mat']);
    
    for iIm = 1:numel(imlist)
        
		fprintf('MSRC %i - %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		savepath = genDir(fullfile(outdir, category));
		[path,name,ext] = fileparts(imlist{iIm});
		savename = fullfile(savepath,[name,'.mat']);
		
        I = imread(fullfile(impath, category, imlist{iIm}));
        siftVisualWord = getSiftVisualWords(I, siftDictionary);
        save(savename, 'siftVisualWord');
            
    end
    
    count = count + 1;
end