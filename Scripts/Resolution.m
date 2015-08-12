clear all;
close all;

%Get file name from all files
idx=36:48;
fn='Data/Aram/image0';
ext='.sxm';
fns=arrayfun(@(x) [fn num2str(x) ext],idx,'UniformOutput',false);
files=cellfun(@load.loadProcessedSxM,fns);

%Corresponding Z
Z=[25,20,18,15,12,11,10,9,8,7,6,5,4]-0.5;

%% %plot std of each line
figure;
hold all

%Keep minimum
MinSlopeLine=1000;

%Loop on files
for i=numel(files):-1:1
    file = files(i);
    
    %Extract number of electrons (~ don't know voltage meaning)
    Ne=file.channels(3).lineMean.*(file.header.scan_time(1)/file.header.scan_pixels(1));
    X=1./Ne;
    
    %Extract Variance of each line
    Y=file.channels(3).lineStd.^2;
    
    %Variance plot
    plot(X,Y,'x','DisplayName',sprintf('Z=%02.1f',Z(i)));
    
    %Extract other informations
    
    %minimum slope
    m=min(Y./X);
    if m<MinSlopeLine
        MinSlopeLine=m;
    end
    
    %Number of electrons for the image
    NImg(i)=mean(Ne);
    
    %Total image std
    STDImg(i)=std(file.channels(3).data(:));
    
    %Median value of variance
    MedianVarImg(i)=median(Y);
    
    
    
end

xlabel('1/Ne')
ylabel('Variance')
title('Variance of each line')

%Plot min line
plot(1./NImg,MinSlopeLine./NImg,'DisplayName','Minimum');

legend(gca,'show')

%% %Plot std as a function of Z
figure(101)
plot(1./Z,STDImg,'x--','DisplayName','Uncorrected')
hold all
%Plot corrected STD as a function of Z
Y=STDImg.^2-MinSlopeLine./NImg;
plot(1./Z,sqrt(Y),'x--','DisplayName','Corrected')
%Plot corrected median Var
Y=MedianVarImg-MinSlopeLine./NImg;
plot(1./Z,sqrt(Y),'x--','DisplayName','Corrected median')
%legend(gca,'show')
xlabel('1/Z [1/nm]')
ylabel('STD [au]')



%% %Plot fourrier amplitude
figure
hold all
title('Radial spectrum');

for i=numel(files):-1:1
    
    %Get data
    [radial_amplitude, radius, N(i)] =op.getRadialFFT(files(i).channels(3).data);
    
    %distance [m] to pixels
    SpP=files(i).header.scan_range(1)/files(i).header.scan_pixels(1);
    
    %Correct radius units
    radius=radius./SpP./1e9;% 1/px to 1/nm
    
    %Plot
    plot(radius,radial_amplitude,'DisplayName',sprintf('Z=%.2f',Z(i)));
    
    %Get max infos
    [MX(i),idx]=max(radial_amplitude);
    I(i)=radius(idx);
end
legend(gca,'show')
xlabel('frequency [1/nm]')
ylabel('amplitude [au]')
set(gca,'YScale','log');

%% Plot amplitude and noise for each Z

figure
plot(1./Z,MX,'x','DisplayName','Amplitude')
hold all
plot(1./Z,N,'x','DisplayName','Noise');
legend(gca,'show','Location','NorthWest')
xlabel('1/Z [1/nm]')
ylabel('amplitude [au]')

%% Plot Noise with MinSlope & straight line
figure
plot(1./NImg,N.^2,'x','DisplayName','Noise data');
hold all
plot(1./NImg,MinSlopeLine./NImg,'DisplayName',sprintf('Minimum Var ( %.3g )',MinSlopeLine));
%Take last data as point
plot(1./NImg,(N(end).^2*NImg(end))./NImg,'DisplayName',sprintf('fit ( %.3g )',(N(end).^2*NImg(end))));

legend(gca,'show','Location','NorthWest')
xlabel('1/Ne')
ylabel('Variance')

%% Plot resolution
img_size=size(files(1).channels(1).data,1);
figure
%/2 as we want the half wavelength
%+- 1 px
errorbar(Z,(1/2)./I,(1/2)./(I.^2)*1/img_size/SpP/1e9,'x')
xlabel('Z [nm]')
ylabel('half wavelength [nm]')
title('Resolution')

%% 
figure(101)
plot(1./Z,MX./sqrt(2),'x--','DisplayName','FFT Max')

legend(gca,'show','Location','NorthWest')
