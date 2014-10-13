function segs = slic(I, k, m)
% Implementation of the SLIC algorithm [1]
% Ref: [1] "SLIC superpixels comapred to state-of-the-art superpixel
%           methods", PAMI, 2012.

%Add lib to path
%addpath('lib');

%Problem parameters
residualThreshold = 5;
h = size(I,1);
w = size(I,2);
N = w*h;
S = round(sqrt(N/k));

%Convert image to LAB space
[L,a,b] = rgb2lab(I);

%generate grid for initial cluster centers
%Nw: number of grid points along the width
%Nh: number of grid points along the height
%These values are obtained by solving Nw/Nh = w/h and Nw*Nh = k
Nw = round(sqrt(k*w/h));
Nh = round(sqrt(k*h/w));
xgv = round(linspace(1+S/2,w-S/2,Nw));
ygv = round(linspace(1+S/2,h-S/2,Nh));
[Ygrid,Xgrid] = meshgrid(xgv,ygv);
realK = numel(xgv) * numel(ygv);

%compute gradients and move cluster centers to smallest gradient


%run algorithm
residue = inf;
distances = inf(size(L));
segs = zeros(size(L));
clusterX = zeros(realK,1);
clusterY = zeros(realK,1);
for i = 1:realK
    clusterX(i) = Xgrid(i);
    clusterY(i) = Ygrid(i);
end

step = 1;
while residue > residualThreshold
    
    %ASSIGNMENT 
    
    %for each cluster center
    for cluster = 1:realK
        cX = clusterX(cluster);
        cY = clusterY(cluster);
        
        %for each pixel in the 2S x 2S surrounding
        %{
        for x = cX - S : cX + S
            for y = cY - S : cY + S
                if(x>0 && y>0 && x<=h && y<=w)
                    %compute distance
                    dc_square = (L(x,y)-L(cX,cY))^2 + (a(x,y)-a(cX,cY))^2 + (b(x,y)-b(cX,cY))^2;
                    ds_square = (x - cX)^2 + (y - cY)^2;
                    distanceToCluster = sqrt( dc_square + ds_square*(m^2)/(S^2) );
                    if distanceToCluster < distances(x,y)
                        distances(x,y) = distanceToCluster;
                        segs(x,y) = cluster;
                    end
                end
            end
        end
        %}
        
        %for each pixel in the 2S x 2S surrounding
        x0 = max(1,cX - S);
        y0 = max(1,cY - S);
        x1 = min(h,cX + S);
        y1 = min(w,cY + S);
        dc_square = (L(x0:x1,y0:y1)-L(cX,cY)).^2 + (a(x0:x1,y0:y1)-a(cX,cY)).^2 + (b(x0:x1,y0:y1)-b(cX,cY)).^2;
        ds_square = (repmat(x0:x1,y1-y0+1,1)' - cX).^2 + (repmat(y0:y1,x1-x0+1,1) - cY).^2;
        distanceToCluster = sqrt( dc_square + ds_square*(m^2)/(S^2) );
        
        oldDistances = distances(x0:x1,y0:y1);
        idx = distanceToCluster < oldDistances;
        oldDistances(idx) = distanceToCluster(idx);
        distances(x0:x1,y0:y1) = oldDistances;
        
        oldSegs = segs(x0:x1,y0:y1);
        oldSegs(idx) = cluster;
        segs(x0:x1,y0:y1) = oldSegs;
        
    end
    
    
    %UPDATE
    
    residue = 0;
    
    %for each cluster center
    for cluster = 1:realK
        
        oldX = clusterX(cluster);
        oldY = clusterY(cluster);
        
        %compute new cluster centers
        idx = segs==cluster;
        totalElements = sum(idx(:));
        
        posX = repmat(1:h,w,1)';
        xValues = idx.*posX;
        newX = round(sum(xValues(:))/totalElements);
        clusterX(cluster) = newX;
        
        posY = repmat(1:w,h,1);
        yValues = idx.*posY;
        newY = round(sum(yValues(:))/totalElements);
        clusterY(cluster) = newY;
    
        %compute L2 residual error
        residue = residue + sqrt( (oldX-newX)^2 + (oldY-newY)^2 );
        
    end
    
    fprintf('step %i - residue is %d\n', step, residue);
    step = step + 1;
    
end


%POST PROCESSING
window = 2;
newSegs = zeros(size(segs));
for i = 1:numel(segs)
    [x,y] = ind2sub(size(segs),i);
    x0 = max(1,x-window);
    y0 = max(1,y-window);
    x1 = min(h,x+window);
    y1 = min(w,y+window);
    region = segs(x0:x1,y0:y1);
    newSegs(i) = mode(region(:));
end

segs = newSegs;

end