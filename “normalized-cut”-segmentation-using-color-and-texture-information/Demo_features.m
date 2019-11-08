% This code demonstrate color and texture feature map used in
% “normalized-cut” segmentation using color and texture information

% 3 color features are:
% 1. red
% 2. green
% 3. blue
% 4 texture features are:
% 1. mean
% 2. variance
% 3. skewness
% 4. kurtosis 

% texture extration coded differently in here for educationl purpose

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
Im = imread('1.jpg');
[nRow,nCol,dim] = size(Im);              % Image row & col
N  = nRow*nCol;                          % Number of pixels
Vx = reshape(Im,N,dim);                  % Vertices of Graph
% figure(); imshow(Im); %disp(Im)
%% texture
m    = 3;
dim2 = 4;
Ig = im2double(rgb2gray(Im));
T  = zeros(nRow,nCol,dim2);               % initialize variance image
T(:,:,1) = reshape(mean(im2col(...       % mean
           padarray(Ig,[m,m],'replicate'),[2*m+1,2*m+1],'sliding')),size(Ig));
T(:,:,2) = reshape(var(im2col(...        % variance
           padarray(Ig,[m,m],'replicate'),[2*m+1,2*m+1],'sliding')),size(Ig));
T(:,:,3) = reshape(skewness(im2col(...   % skewness
           padarray(Ig,[m,m],'replicate'),[2*m+1,2*m+1],'sliding')),size(Ig));       
T(:,:,4) = reshape(kurtosis(im2col(...   % kurtosis
           padarray(Ig,[m,m],'replicate'),[2*m+1,2*m+1],'sliding')),size(Ig));
T(:,:,1) = (T(:,:,1)-min(min(T(:,:,1))))/(max(max(T(:,:,1)))-min(min(T(:,:,1))));
T(:,:,2) = (T(:,:,2)-min(min(T(:,:,2))))/(max(max(T(:,:,2)))-min(min(T(:,:,2))));
T(:,:,3) = (T(:,:,3)-min(min(T(:,:,3))))/(max(max(T(:,:,3)))-min(min(T(:,:,3))));
T(:,:,4) = (T(:,:,4)-min(min(T(:,:,4))))/(max(max(T(:,:,4)))-min(min(T(:,:,4))));
T = uint8(255*T);                        % normalization
X = cat(2,repmat((1:nRow)',1,nCol),repmat((1:nCol),nRow,1));
%% show
figure()
subplot(241); imshow(T(:,:,1)); title('Tex: mean')        % Tex: mean 
subplot(242); imshow(T(:,:,2)); title('variance')         %      variance
subplot(243); imshow(T(:,:,3)); title('skewness')         %      skewness
subplot(244); imshow(T(:,:,4)); title('kurtosis')         %      kurtosis 

subplot(245);   imshow(Im(:,:,1)); title('Col: red')      % Col: red
subplot(2,4,6); imshow(Im(:,:,2)); title('green')         %      green
subplot(2,4,7); imshow(Im(:,:,3)); title('blue')          %      blue
subplot(2,4,8); imshow(Im);        title('[orginal]')     %      org

toc
