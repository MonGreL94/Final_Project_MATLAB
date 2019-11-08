% This code implemented a “normalized-cut” segmentation using color and texture information

% This code segment an image using color, texture and spatial data
% RGB color is used as an color data
% Four texture features are used: 1. mean 2. variance 3. skewness 4. kurtosis
% Normalized Cut (inherently uses spatial data)
% ncut parameters are "SI" Color similarity, "ST" Texture similarity, "SX" Spatial similarity, "r" Spatial threshold (less than r pixels apart), "sNcut" The smallest Ncut value (threshold) to keep partitioning, and "sArea" The smallest size of area (threshold) to be accepted as a segment 

% an implementation by "Naotoshi Seo" with a small modification is used for “normalized-cut” segmentation, available online at: "http://note.sonots.com/SciSoftware/NcutImageSegmentation.html", It is sensitive in choosing parameters.

% Alireza Asvadi
% Department of ECE, SPR Lab
% Babol (Noshirvani) University of Technology
% http://www.a-asvadi.ir
% 2013
%% clear command windows
clc
clear all
close all
tic
%% initialize
Im = imread('checkerboard.jpg');
[nRow, nCol, ~] = size(Im);
Im_size = 100;
Im = Im(nRow / 2 - Im_size: nRow / 2 + Im_size, nCol / 2 - Im_size: nCol / 2 + Im_size, :);
[nRow,nCol,dim] = size(Im);              % Image row & col
N  = nRow*nCol;                          % Number of pixels
Vx = reshape(Im,N,dim);                  % Vertices of Graph
% figure(); imshow(Im);
%% Texture
m    = 1;                                % window width for texture extraction is 2*m+1
ST   = 10;                               % texture similarity
dim2 = 4;                                % number of texture features
In = im2double(rgb2gray(Im));
T = zeros(nRow,nCol,dim2);               % initialize variance image
for i = 1:nRow                           % central pixel (in image coordinate)                              
    for j = 1:nCol   
Vi  = (i-floor(m)):(i+floor(m));         %% neighbourhood pixels (in image coordinate)
Vj  = ((j-floor(m)):(j+floor(m)));
Vi  = Vi(Vi>=1 & Vi<=nRow);              % keep pixels that are inside image
Vj  = Vj(Vj>=1 & Vj<=nCol);
blk = In(Vi,Vj);                         %% image block
T(i,j,1) = mean(blk(:));                 % mean
T(i,j,2) = var(blk(:));                  % variance
T(i,j,3) = skewness(blk(:));             % skewness
T(i,j,4) = kurtosis(blk(:));             % kurtosis
    end
end
T(:,:,1) = (T(:,:,1)-min(min(T(:,:,1))))/(max(max(T(:,:,1)))-min(min(T(:,:,1))));
T(:,:,2) = (T(:,:,2)-min(min(T(:,:,2))))/(max(max(T(:,:,2)))-min(min(T(:,:,2))));
T(:,:,3) = (T(:,:,3)-min(min(T(:,:,3))))/(max(max(T(:,:,3)))-min(min(T(:,:,3))));
T(:,:,4) = (T(:,:,4)-min(min(T(:,:,4))))/(max(max(T(:,:,4)))-min(min(T(:,:,4))));
T = uint8(255*T);                        % normalization
% figure(); imshow(T)
%% Compute weight matrix W
r  = 1.5;                                % Spatial threshold (less than r pixels apart)
SI = 5;                                  % Color similarity
SX = 6;                                  % Spatial similarity
sNcut = 0.22;                            % The smallest Ncut value (threshold) to keep partitioning 
sArea = 30;                              % The smallest size of area (threshold) to be accepted as a segment
W = sparse(N,N);                         % initialize W
F = reshape(Im,N,1,dim);                 % Image pixel values in column vector
G = reshape(T,N,1,dim2);                 % Image variance values in column vector
X = cat(2,repmat((1:nRow)',1,nCol),repmat((1:nCol),nRow,1));
X = reshape(X,N,1,2);                    % Location in image coordinate in 2 * column vector
for Ic = 1:nCol                          % central pixel (in image coordinate)                              
    for Ir = 1:nRow    
Vc = (Ic-floor(r)):(Ic+floor(r));        %% neighbourhood pixels (in image coordinate)
Vr = ((Ir-floor(r)):(Ir+floor(r)))';
Vc = Vc(Vc>=1 & Vc<=nCol);               % keep pixels that are inside image
Vr = Vr(Vr>=1 & Vr<=nRow);
VN = length(Vc)*length(Vr);
I = Ir +(Ic-1)*nRow;                     %% central pixel (linear indexing)                   
V = repmat(Vr,1,length(Vc))+repmat((Vc-1)*nRow,length(Vr),1);
V = reshape(V,length(Vc)*length(Vr),1);  % neighbourhood pixels (linear indexing)
XV = X(V,1,:);                           %% neighbourhood pixel locations in column vector
XI = repmat(X(I,1,:),length(V),1);
DX = XI-XV;                              % difference
DX = sum(DX.*DX,3);                      % squared euclid distance
constraint = find(sqrt(DX)<=r);          % constraint
V = V(constraint);
DX = DX(constraint);
FV = F(V,1,:);                           %% neighbourhood pixel values in column vector
FI = repmat(F(I,1,:),length(V),1);       % central variance pixel values repeated in column vector
DF = FI-FV;                              % difference
DF = sum(DF.*DF,3);                      % squared euclid distance
GV = G(V,1,:);                           %% neighbourhood variance pixel values in column vector
GI = repmat(G(I,1,:),length(V),1);       % central pixel values repeated in column vector
DG = GI-GV;                              % difference
DG = sum(DG.*DG,3);                      % squared euclid distance
W(I, V) = exp(-DF/(SI*SI)) .* exp(-DX/(SX*SX)) .* exp(-DG/(ST*ST));
    end
end
%% NcutPartition
Seg = (1:N)';                            % the first segment has whole nodes. [1 2 3 ... N]'
id = 'ROOT';                             % recursively repartition
d = sum(W, 2);                           % Compute D
D = spdiags(d, 0, N, N);                 % diagonal matrix
warning off;                             % let me stop warning
[U,S] = eigs(D-W, D, 2, 'sm');           % Solve generalized eigensystem (D -W)*S = S*D*U
U2 = U(:, 2);                            % 2nd smallest
t = mean(U2);                            % Bipartition the graph at point that Ncut is minimized.
t = fminsearch('NcutValue', t, [], U2, W, D);
A = find(U2 > t);
B = find(U2 <= t);

x = (U2 > t);
x = (2 * x) - 1;
d = diag(D);
k = sum(d(x > 0)) / sum(d);
b = k / (1 - k);
y = (1 + x) - b * (1 - x);
ncut = (y' * (D - W) * y) / ( y' * D * y );
%% recursive 2-way repartition
if (length(A) < sArea || length(B) < sArea) %|| ncut > sNcut
    Seg{1}   = Seg;
    Id{1}   = id;   % for debugging
    Ncut{1} = ncut; % for debugging
    return;
end
[SegA IdA NcutA] = NcutPartition(Seg(A), W(A, A), sNcut, sArea, [id '-A']); % Seg segments of A
[SegB IdB NcutB] = NcutPartition(Seg(B), W(B, B), sNcut, sArea, [id '-B']); % Seg segments of B
Seg  = [SegA SegB];                      % concatenate cell arrays
Id   = [IdA IdB];
Ncut = [NcutA NcutB];
%% show
Io   = zeros(size(Im),'uint8');
for k=1:length(Seg)
 [r, c] = ind2sub(size(Im),Seg{k});
 for i=1:length(r)
 Io(r(i),c(i),1:dim) = uint8(round(mean(Vx(Seg{k}, :))));
 end
end
figure()
subplot(121); imshow(Im); title('Original'); 
subplot(122); imshow(Io);  title(['ncut',': ',num2str(length(Seg))]);

% needs:
% NcutPartition
% NcutValue
toc
