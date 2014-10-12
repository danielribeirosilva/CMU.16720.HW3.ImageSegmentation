function outDirName = genDir(inDirName)
% CV F14 - Provided Code
%
% Create a directory if the inDirName does not exist as a dir 
%
% Created by Wen-Sheng Chu (Sep-20-2014)

outDirName = inDirName;
if ~exist(inDirName, 'dir')
  mkdir(inDirName);
end