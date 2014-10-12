% CV Fall 2014 - Provided Code
% Batch superpixels generation
%
% Created by Wen-Sheng Chu (Sep-20-2014)

clear all; addpath('lib');
load('datapaths.mat'); % load data paths

% init slic parameters (adjust here to make your own superpixels)
k = 300;
m = 4;

%% extract superpixels for iCoseg
impath = 'data/iCoseg';
outdir = genDir('segments/iCoseg');

for iCls = 1:icoseg.lcls
	imlist = icoseg.allimgs{iCls};
	for iIm = 1:numel(imlist)
		fprintf('\n# processing %s\n\n', imlist{iIm});
		savepath = genDir(fullfile(outdir, icoseg.cls{iCls}));
		
		[path,name,ext] = fileparts(imlist{iIm});
		savename = fullfile(savepath,[name,'.mat']);
		
% 		if exist(savename,'file')
% 			continue;
% 		else
			I = imread(fullfile(impath, icoseg.cls{iCls}, imlist{iIm}));
			segs = uint32(slic(I,k,m));
			save(savename, 'segs');
% 		end
	end
end

%% extract superpixels for msrc
impath = 'data/msrc';
outdir = genDir('segments/MSRC');

for iCls = 1:msrc.lcls
	imlist = msrc.allimgs{iCls};
	for iIm = 1:numel(imlist)
		fprintf('\n# processing %s\n\n', imlist{iIm});
		savepath = genDir(fullfile(outdir, msrc.cls{iCls}));
		
		[path,name,ext] = fileparts(imlist{iIm});
		savename = fullfile(savepath,[name,'.mat']);
		
% 		if exist(savename,'file')
% 			continue;
% 		else
			I = imread(fullfile(impath, msrc.cls{iCls}, imlist{iIm}));
			segs = uint32(slic(I,k,m));
			save(savename, 'segs');
% 		end
	end
end
