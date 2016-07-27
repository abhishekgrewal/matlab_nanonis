%---------------------------------------------
%   This files tries to fit the variation on median and std
%   on a SEM image to distance
%
%   TODO
%
%---------------------------------------------

close all;
clear all;

%% load datas
file5=loadSxM.loadProcessedSxM('Data/March/2015-03-02/image005.sxm');
file6=loadSxM.loadProcessedSxM('Data/March/2015-03-02/image006.sxm');
file7=loadSxM.loadProcessedSxM('Data/March/2015-03-02/image007.sxm');
file8=loadSxM.loadProcessedSxM('Data/March/2015-03-02/image008.sxm');
%%
fit((1:size(file5.channels(3).median,1))',file5.channels(3).median,'exp2');
%%
X=1:size(file7.channels(1).median,1);
Y=file7.channels(1).median.';
%%
file5.header.scan_dir
file6.header.scan_dir
file7.header.scan_dir
file8.header.scan_dir
%%
figure
hold all
plot(file5.channels(3).median)
plot(flip(file6.channels(3).median))
plot(file7.channels(3).median)
plot(flip(file8.channels(3).median))
legend('5','6','7','8')

%%
figure
hold all
plot(log(file5.channels(3).median))
plot(log(file5.channels(5).median))
plot(log(file5.channels(7).median))
plot(log(file5.channels(9).median))
legend('0','1','2','3')

%%
figure
hold all
offset=1.58*10^-10;
plot(real(log(file5.channels(1).median+offset)))
plot(real(log(flip(file6.channels(1).median+offset))))
plot(real(log(file7.channels(1).median+offset)))
plot(real(log(flip(file8.channels(1).median+offset))))
legend('5','6','7','8')



%%
figure
hold all
plot(file5.channels(3).std)
plot(flip(file6.channels(3).std))
plot(file7.channels(3).std)
plot(flip(file8.channels(3).std))
legend('5','6','7','8')
%%

%%
figure
hold all
offset=0;
plot(real(log(file5.channels(3).median+offset)))
plot(real(log(flip(file6.channels(3).median+offset))))
plot(real(log(file7.channels(3).median+offset)))
plot(real(log(flip(file8.channels(3).median+offset))))
legend('5','6','7','8')
%%
close all