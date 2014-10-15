clear all; addpath('lib'); addpath('lib/fastkmeans');
load('datapaths.mat'); % load data paths


filterBank = createFilterBank();


%% extract visual words for iCoseg
impath = 'data/iCoseg';
dicpath = 'dictionaries/iCoseg';
outdir = genDir('visualwords/iCoseg');

count = 1;
for iCls = 1:icoseg.lcls
	%imlist = icoseg.trainimgs{iCls};
    imlist = icoseg.testimgs{iCls};
    
    category = icoseg.cls{iCls};
    
    load([dicpath,'/',category,'/dictionary.mat']);
    
    for iIm = 1:numel(imlist)
        
		fprintf('iCoseg %i - %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		savepath = genDir(fullfile(outdir, category));
		[path,name,ext] = fileparts(imlist{iIm});
		savename = fullfile(savepath,[name,'.mat']);
		
        I = imread(fullfile(impath, category, imlist{iIm}));
        visualWord = getVisualWords(I, filterBank, dictionary);
        save(savename, 'visualWord');
            
    end
    
    count = count + 1;
end


%% extract visual words for msrc
impath = 'data/msrc';
dicpath = 'dictionaries/MSRC';
outdir = genDir('visualwords/MSRC');

count = 1;
for iCls = 1:msrc.lcls
	%imlist = msrc.trainimgs{iCls};
    imlist = msrc.testimgs{iCls};
    
    category = msrc.cls{iCls};
    
    load([dicpath,'/',category,'/dictionary.mat']);
    
    for iIm = 1:numel(imlist)
        
		fprintf('MSRC %i - %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		savepath = genDir(fullfile(outdir, category));
		[path,name,ext] = fileparts(imlist{iIm});
		savename = fullfile(savepath,[name,'.mat']);
		
        I = imread(fullfile(impath, category, imlist{iIm}));
        visualWord = getVisualWords(I, filterBank, dictionary);
        save(savename, 'visualWord');
            
    end
    
    count = count + 1;
end
