function [filterBank,dictionary] = getFilterBankAndDictionary(trainFiles)
% CV Fall 2014 - Provided Code
%
% Get FilterBank and Dictionary
%
% Created by Wen-Sheng Chu and Ishan Misra (Sep-20-2014)

% Number of files
nIm = numel(trainFiles);

% Getting the filter bank
filterBank = createFilterBank();

%Number of responses sampled per image for kmeans
alpha = 100;

%Number of dictionary words
K = 125;

%Descriptors for k-means (alpha*T)
responses = cell(nIm,1);

% Replace "for" with "parfor" for parallel computing
fprintf('Computing responses...\n');
parfor iIm = 1:nIm
	
	fprintf('\timage #%d/%d\n', iIm, nIm);
   
    % Current images
    image_aux = imread(trainFiles{iIm});
    
    % Getting the image response
    filterResponses = extractFilterResponses(image_aux,filterBank);
    
    % Random permutation of the descriptors
    randind = randperm(size(filterResponses,1));
    
    % Getting the first alpha responses and adding them to the selected set;
    responses{iIm} = filterResponses(randind(1:alpha),:);
    
end
responses = vertcat(responses{:});

fprintf('Creating %d-word dictionary...\n', K);
%[~,dictionary] = kmeans(responses,K,'EmptyAction','drop');

dictionary = fastkmeans(responses,K);