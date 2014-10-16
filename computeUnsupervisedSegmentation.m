clear all; addpath('lib'); addpath('lib/fastkmeans');
load('datapaths.mat'); % load data paths

%parameters
dicSize = 150;


%dataset
dataset = 'MSRC';
groundTruthFormat = '.bmp';
numberOfCategories = msrc.lcls;
allImages = msrc.allimgs;
categoryNames = msrc.cls;

%{
dataset = 'iCoseg';
groundTruthFormat = '.png';
numberOfCategories = icoseg.lcls;
allImages = icoseg.allimgs;
categoryNames = icoseg.cls;
%}

%paths
impath = ['data/',dataset];
visualwordpath = ['visualwords/',dataset];
superpixelspath = ['superpixels/',dataset];
allhistogramsoutputpath = genDir(['unsupervised/allhistograms/',dataset]);
outputpath = genDir(['unsupervised/results/',dataset]);


%% HISTOGRAMS COMPUTATION


%for each category
count = 1;
for iCls = 1:numberOfCategories
    
	imlist = allImages{iCls};
    category = categoryNames{iCls};
    
    allHistograms = [];
    
    for iIm = 1:numel(imlist)
        
		fprintf('Category %i - Image %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		
        [path,name,ext] = fileparts(imlist{iIm});
        
        %load visual word (visualWord)
        load([visualwordpath,'/',category,'/',name,'.mat']);
        
        
        %iterave over each superpixel
        for iSp = 1:max(segs(:))
            
            %visual word for super pixel
            Spviswords = visualWord(segs==iSp);
            
            %compute normalized histogram
            h = hist(Spviswords,1:dicSize);
            h = h ./ sum(h(:));
            
            %update trining data
            allHistograms = [allHistograms h'];
            
        end %end of superpixels
            
    end  %end of image
    
    %save training data for category
    savepath = genDir(fullfile(allhistogramsoutputpath, category));
    savename = fullfile(savepath,'/allHistograms.mat');
    save(savename, 'allHistograms');
    
    count = count + 1;
    
end  %end of category




%% SEGMENTATION


%for each category
count = 1;
sp_count = 1;
for iCls = 1:numberOfCategories
    
	imlist = allImages{iCls};
    category = categoryNames{iCls};
    
    %load histograms (allHistograms)
    load([allhistogramsoutputpath,'/',category,'/allHistograms.mat']);
    
    %do k-means for k=2
    [centers,mincenter,mindist,q2,quality] = fastkmeans(allHistograms',2);
    
    %for each image
    for iIm = 1:numel(imlist)
        
		fprintf('Category %i - Image %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		
        [path,name,ext] = fileparts(imlist{iIm});
        
        %load superpixels (segs)
        load([superpixelspath,'/',category,'/',name,'.mat']);
        
        %create base for prediction image
        predictedSeg = zeros(size(segs));
        
        
        %iterave over each superpixel
        for iSp = 1:max(segs(:))
            
            %get corresponding cluster center
            predictedLabel = mincenter(sp_count) - 1; %centers are 1 and 2
            
            %label superpixel
            predictedSeg(segs==iSp) = predictedLabel;
            
            sp_count = sp_count + 1;
            
        end %end of superpixels
        
        %save predicted segmentation
        savepath = genDir(fullfile(outputpath, category));
        savename = fullfile(savepath,[name,'.png']);
        imwrite(predictedSeg, savename);
            
    end  %end of images
    
    count = count + 1;
    
end  %end of category


