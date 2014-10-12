% CV Fall 2014 - Provided Code
% Test DSIFT 
%
% Created by Wen-Sheng Chu (Sep-20-2014)

addpaths;
I = imread('data/iCoseg/Christ/601731816_01fdecd5b3.jpg');

tic;
[f,d] = dsift(I);
fprintf('Finished computing DSIFT in %.2f secs\n', toc);