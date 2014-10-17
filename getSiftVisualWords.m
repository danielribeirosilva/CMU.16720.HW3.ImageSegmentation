function wordmap = getSiftVisualWords(I, siftDictionary)


%Getting the sift features
[~,d] = dsift(I);

%Number of columns of the image
imsize = size(I);

%Getting the euclidean distance to every dictionary word 
DMatrix = pdist2(double(d'),siftDictionary);

%Chosing the closest one
[~,wordVector] = min(DMatrix,[],2);

%Building the output matrix
wordmap = vec2mat(wordVector,imsize(1))'; 


