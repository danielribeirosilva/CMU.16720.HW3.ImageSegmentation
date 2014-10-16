clear all; addpath('lib'); addpath('lib/fastkmeans');
load('datapaths.mat'); % load data paths

%% extract dictionaries for iCoseg
impath = 'data/iCoseg';
outdir = genDir('dictionaries/iCoseg');

count = 1;
for iCls = 1:icoseg.lcls
	imlist = icoseg.trainimgs{iCls};
    
    category = icoseg.cls{iCls};
    savepath = genDir(fullfile(outdir, category));
    savename = fullfile(savepath,['dictionary','.mat']);
    
    fprintf('\n# processing iCoseg category %s: %i / %i\n', category, count, icoseg.lcls);
    
    %create image paths for dictionary
    imgPaths = cell(numel(imlist),1);
    for iIm = 1:numel(imlist)
        [path,name,ext] = fileparts(imlist{iIm});
        imgPaths{iIm} = fullfile([impath,'/',category],[name,ext]);
    end
    
    [~,dictionary] = getFilterBankAndDictionary(imgPaths);
    
    save(savename, 'dictionary');
    
    count = count + 1;
end


%% extract dictionaries for msrc
impath = 'data/msrc';
outdir = genDir('dictionaries/MSRC');

count = 1;
for iCls = 1:msrc.lcls
	imlist = msrc.trainimgs{iCls};
    
    category = msrc.cls{iCls};
    savepath = genDir(fullfile(outdir, category));
    savename = fullfile(savepath,['dictionary','.mat']);
    
    fprintf('\n# processing msrc category %s: %i / %i\n', category, count, msrc.lcls);
    
    %create image paths for dictionary
    imgPaths = cell(numel(imlist),1);
    for iIm = 1:numel(imlist)
        [path,name,ext] = fileparts(imlist{iIm});
        imgPaths{iIm} = fullfile([impath,'/',category],[name,ext]);
    end
    
    [~,dictionary] = getFilterBankAndDictionary(imgPaths);
    
    save(savename, 'dictionary');
    
    count = count + 1;
end
