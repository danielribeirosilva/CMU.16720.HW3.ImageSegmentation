clear all; addpath('lib'); addpath('lib/fastkmeans');
load('datapaths.mat'); % load data paths

%parameters
dicSize = 150;


%dataset
%{
dataset = 'MSRC';
groundTruthFormat = '.bmp';
numberOfCategories = msrc.lcls;
trainImages = msrc.trainimgs;
testImages = msrc.testimgs;
categoryNames = msrc.cls;
%}


dataset = 'iCoseg';
groundTruthFormat = '.png';
numberOfCategories = icoseg.lcls;
trainImages = icoseg.trainimgs;
testImages = icoseg.testimgs;
categoryNames = icoseg.cls;


%paths
impath = ['data/',dataset];
visualwordpath = ['siftvisualwords/',dataset];
superpixelspath = ['superpixels/',dataset];
trainoutputpath = genDir(['train_dsift/',dataset]);
testoutputpath = genDir(['supervised/results_dsift/',dataset]);


%% TRAINING



%for each category
count = 1;
for iCls = 1:numberOfCategories
    
	imlist = trainImages{iCls};
    category = categoryNames{iCls};
    
    trainHistograms = [];
    trainLabels = [];
    
    for iIm = 1:numel(imlist)
        
		fprintf('Category %i - Image %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		
        [path,name,ext] = fileparts(imlist{iIm});
        
        %load superpixels (segs)
        load([superpixelspath,'/',category,'/',name,'.mat']);
        
        %load visual word (siftVisualWord)
        load([visualwordpath,'/',category,'/',name,'.mat']);
		
        %load ground truth
        groundtruthfile = [impath,'/',category,'/GroundTruth/',name,groundTruthFormat];
        Itruth = imread(groundtruthfile);
        
        
        %adjust images 
        Itruth = Itruth(3:end-1,3:end-1);
        segs = segs(3:end-1,3:end-1);
        
        %iterave over each superpixel
        for iSp = 1:max(segs(:))
            
            %only keep superpixels that have +90% back- or foreground
            ItruthSp = Itruth(segs==iSp);
            avgGround = mean(ItruthSp(:));
            if avgGround>0.9
                label = 1;
            elseif avgGround<0.1
                label = 0;
            else
                continue;
            end
            
            %visual word for super pixel
            Spviswords = siftVisualWord(segs==iSp);
            
            %compute normalized histogram
            h = hist(Spviswords,1:dicSize);
            h = h ./ sum(h(:));
            
            %update trining data
            trainHistograms = [trainHistograms h'];
            trainLabels = [trainLabels label];
            
        end %end of superpixels
            
    end  %end of image
    
    %save training data for category
    savepath = genDir(fullfile(trainoutputpath, category));
    savename = fullfile(savepath,'/trainingData.mat');
    save(savename, 'trainHistograms', 'trainLabels');
    
    count = count + 1;
    
end  %end of category




%% TESTING


%for each category
count = 1;
for iCls = 1:numberOfCategories
    
	imlist = testImages{iCls};
    category = categoryNames{iCls};
    
    %load training data (trainHistograms and trainLabels)
    load([trainoutputpath,'/',category,'/trainingData.mat']);
    
    
    %for each test image
    for iIm = 1:numel(imlist)
        
		fprintf('Category %i - Image %i/%i - processing %s\n', count, iIm, numel(imlist), imlist{iIm});
		
        [path,name,ext] = fileparts(imlist{iIm});
        
        %load superpixels (segs)
        load([superpixelspath,'/',category,'/',name,'.mat']);
        
        %load visual word (siftVisualWord)
        load([visualwordpath,'/',category,'/',name,'.mat']);
        
        %adjust images 
        Itruth = Itruth(3:end-1,3:end-1);
        segs = segs(3:end-1,3:end-1);
        
        %create base for prediction image
        predictedSeg = zeros(size(segs));
        
        
        %iterave over each superpixel
        for iSp = 1:max(segs(:))
            
            %visual word for super pixel
            Spviswords = siftVisualWord(segs==iSp);
            
            %compute normalized histogram
            h = hist(Spviswords,1:dicSize);
            h = h ./ sum(h(:));
            
            %compute distance to training examples
            histInter = distanceToSet(h, trainHistograms);
            
            %get closest gradient (k-NN with k=1)
            [~,pos] = max(histInter);
            predictedLabel = trainLabels(pos);
            
            %label superpixel
            predictedSeg(segs==iSp) = predictedLabel;
            
            
        end %end of superpixels
        
        
        %readjust size
        predictedSegOriginalSize = zeros(size(predictedSeg,1)+3,size(predictedSeg,2)+3);
        predictedSegOriginalSize(3:end-1,3:end-1) = predictedSeg;
        
        %save predicted segmentation
        savepath = genDir(fullfile(testoutputpath, category));
        savename = fullfile(savepath,[name,'.png']);
        imwrite(predictedSegOriginalSize, savename);
            
    end  %end of images
    
    count = count + 1;
    
end  %end of category


