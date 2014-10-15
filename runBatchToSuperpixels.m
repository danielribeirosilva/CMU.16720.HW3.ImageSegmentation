% CV Fall 2014 - Provided Code
% Batch superpixels generation
%
% Created by Wen-Sheng Chu (Sep-20-2014)

clear all; addpath('lib');
load('datapaths.mat'); % load data paths

% init slic parameters (adjust here to make your own superpixels)
k = 300;
m = 10;

%% extract superpixels for iCoseg
impath = 'data/iCoseg';
outdir = genDir('segments/iCoseg');

cont_icoseg = 0;
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
        cont_icoseg = cont_icoseg + 1;
        fprintf('iCoseg: %i \n',cont_icoseg);
	end
end

%% extract superpixels for msrc
impath = 'data/msrc';
outdir = genDir('segments/MSRC');

cont_msrc = 0;
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
        cont_msrc = cont_msrc + 1;
        fprintf('MSRC: %i \n',cont_msrc);
	end
end
