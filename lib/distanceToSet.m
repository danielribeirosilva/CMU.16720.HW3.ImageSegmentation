function histInter = distanceToSet(textonHist, histograms, distType)
% CV F14 - Provided Code
%
% Compute the distance between a textonHist and a set of histograms
% Input:
%    textonHist:    K x 1 histogram with K histogram bins
%    histograms:    K x T matrix containing T histograms (from T training
%                   images)
% Output:
%    histInter:     The distance of histogram intersection
%
% Created by Wen-Sheng Chu (Sep-20-2014)

T = size(histograms,2);

repHist = repmat(textonHist, [1,T]);

if ~exist('distType','var')
  distType = 'l2';
end

switch distType
  case 'l2' % 2-norm
    histInter = sqrt(sum((repHist - histograms).^2, 1));
  otherwise
    msg = sprintf('Does not support distance type "%s"\n', distType); 
    error(msg);
end