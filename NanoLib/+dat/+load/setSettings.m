function [nanoLib,userNanoLib]=setSettings()

% get path
nanoLib = uigetdir(pwd,'Set NanoLib path');
if ~ischar(nanoLib)
    error('Chose a directory for NanoLib');
end

userNanoLib = uigetdir(pwd,'Set NanoLib USER library path');
if ~ischar(userNanoLib)
    userNanoLib = 'none';
end

% save
fn = sprintf('%s%s%s',nanoLib,'/+dat/+load/','datSettings.txt');
fileID = fopen(fn,'w');
fprintf(fileID,'%s\t%s\n','nanoLib',nanoLib);
fprintf(fileID,'%s\t%s\n','userNanoLib',userNanoLib);
fclose(fileID);