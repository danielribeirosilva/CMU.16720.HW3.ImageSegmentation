function [P, IoU, classes] = evaluateDatasetUns(resultDir, datasetname, datasetinfo)
% CV F14 - Provided Code
%
% Evaluation of a dataset (unsupervised)
%
% Credit: Ce Liu, from http://people.csail.mit.edu/mrub/ObjectDiscovery/

classes = datasetinfo.cls;
nClasses = length(classes);

P   = zeros(1, nClasses);
IoU = zeros(1, nClasses);

for i = 1:nClasses
    class = classes{i};
    disp(class);
    
    maskDir = fullfile(resultDir, datasetname, class);
    gtDir = fullfile('data', datasetname, class, 'GroundTruth');
    
    [P(i), IoU(i)] = evaluateClassUns(maskDir, gtDir, datasetinfo.allimgs{i});
end

