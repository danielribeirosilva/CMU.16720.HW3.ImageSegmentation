% CV Fall 2014 - Provided Code
% Test SLIC 
%
% Created by Wen-Sheng Chu (Sep-20-2014)

addpath('lib');
I = imread('data/iCoseg/Christ/601731816_01fdecd5b3.jpg');

k = 300;
m = 5;
segs = slic(I, k, m);

%% visualize
bmap = seg2bmap(segs);
Iout = imoverlay(I,bmap);

figure; 
subplot(131); imshow(I);
subplot(132); imshow(Iout);
subplot(133); imshow(seg2im(segs));
