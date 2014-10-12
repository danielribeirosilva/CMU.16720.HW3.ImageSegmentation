function wordmap = getVisualWords(I, filterBank, dictionary)
% CV Fall 2014 - Provided Code
%
% Generate wordmaps
%
% Created by Ishan Mirsa 

%Getting the filter responses
filterResponses = extractFilterResponses(I,filterBank);

%Number of columns of the image
imsize = size(I);

%Getting the euclidean distance to every dictionary word 
DMatrix = pdist2(filterResponses,dictionary);

%Chosing the closest one
[C,wordVector] = min(DMatrix,[],2);

%Building the output matrix
wordmap = vec2mat(wordVector,imsize(1))'; 


