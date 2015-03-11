function [maskUp, maskDown] = getMask(data, prctUp, prctDown,varargin)%fn, varargin
%getMask creates a mask for the detection of pattern. It will filter the
%datas using FFT, flatten the datas with a sliding mean and take a
%threshold to cut the datas
%   prctUp and -Down specify the fraction of pixel that should be kept in
%   the mask
%   Can add a 'plotFFT' to plot the fourrier transform

%% Settings

radius = 20;%Radius of the circle in the fourrier plane
scanFrac = 4;%Fraction of the image on which the sliding averaging is done
stdCut = 2;%Number of STDev kept on the data
zoomFT=8;%Zoom on the FFT Graph


%%

%Remove extreme values
range = [-1 1]*stdCut*std(data(:));
low = data < range(1);
data(low)=range(1);
high = data > range(2);
data(high) = range(2);

%Fourrier transform
fTrans=fft2(data);

%Create matrix for easy radius computation
m = 1:size(fTrans,1);
m=m.';
n = 1:size(fTrans,2);

%real part of c is first dim, imaginary is 2nd
c=m*ones(size(n))+1i*(ones(size(m))*n);

%Calculate a circle around the corners
indx = abs(c-c(1,1)) < radius;
indx = indx | (abs(c-c(1,end)) < radius);
indx = indx | (abs(c-c(end,1)) < radius);
indx = indx | (abs(c-c(end,end)) < radius);


%Extract interesting part
redFTrans = complex(zeros(size(fTrans)));
redFTrans(indx)=fTrans(indx);

%Retrieve filtered data
filtered=real(ifft2(redFTrans));

%calculate sliding mean
sldArea=size(data)/scanFrac;
normalMtx=flip(sldArea)*sldArea.'/size(sldArea,2);%X*Y
slidingmean=convolve2(filtered,ones(sldArea)/normalMtx,'symmetric');

%Get flattened data
flatData= filtered-double(slidingmean);

%Compute high mask
threshold = prctile(flatData(:),prctUp);
keep = flatData > threshold;
maskUp = zeros(size(flatData));
maskUp(keep)=1;

%Compute low mask
threshold = prctile(flatData(:),prctDown);
keep = flatData < threshold;
maskDown = zeros(size(flatData));
maskDown(keep)=1;

%% Plot Fourrier transform plane

    function ret = swapSquares(data, sizeSq)
        ret=zeros(2*sizeSq);
        ret(1:sizeSq(1), 1: sizeSq(2))= data(end-sizeSq(1)+1:end,end-sizeSq(2)+1:end );
        ret(1:sizeSq(1), end-sizeSq(2)+1: end)=data(end-sizeSq(1)+1:end, 1: sizeSq(2));
        ret(end-sizeSq(1)+1:end, 1: sizeSq(2))=data(1:sizeSq(1), end-sizeSq(2)+1: end);
        ret(end-sizeSq(1)+1:end, end-sizeSq(2)+1: end)=data(1:sizeSq(1), 1: sizeSq(2));
    end

% read the data if requested
if nargin > 0
    cmd = varargin{1};
    
    if strcmp(cmd,'plotFFT')
        %Compute the quarter size
        sizeSq = size(data)/zoomFT;
        %Reorder fourrier data
        dis = swapSquares(abs(fTrans),sizeSq);
        
        %Plot
        figure
        imagesc(dis);
        axis image
        title('Fourrier plane and selected area')
        %apply index mask
        applyMask(swapSquares(indx,sizeSq),[0 size(dis,1)],[0 size(dis,2)],[1,0,0],.2)
    end
    
end


figure
imagesc(flatData);
axis image

%{
%Compute removed part
redFTrans = complex(zeros(size(fTrans)));
redFTrans(~indx)=fTrans(~indx);
noise=real(ifft2(redFTrans));

%Plot removed part
figure
imagesc(noise,range);
axis image

figure
imagesc(filtered);
axis image

figure
imagesc(double(slidingmean))
axis image


%}

end
