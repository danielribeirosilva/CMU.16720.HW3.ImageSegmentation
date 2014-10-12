function [P, IoU, classes] = evaluateDataset(resultDir, dbname, dbinfo)
% CV F14 - Provided Code
%
% Evaluation of a dataset
%
% Credit: Ce Liu, from http://people.csail.mit.edu/mrub/ObjectDiscovery/

classes  = dbinfo.cls;
nClasses = length(classes);

P   = zeros(1, nClasses);
IoU = zeros(1, nClasses);

for i = 1:nClasses
    class = classes{i};
    disp(class);
    
    maskDir = fullfile(resultDir, dbname, class);
    gtDir = fullfile('data', dbname, class, 'GroundTruth');
    
    [P(i), IoU(i)] = evaluateClass(maskDir, gtDir, dbinfo.testimgs{i});
end

