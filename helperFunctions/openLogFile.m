function fileID = openLogFile()
% This function opens a csv log file to store the data collected during
% the experiment:
global formatSpec
Filename = sprintf('PhotodiodeStressTest%s.csv', datestr(now,'mm-dd-yyyy HH-MM'));

% Checking if the data dir exists:
dataDir = fullfile(pwd,'Data');
if ~exist(dataDir, 'dir')
    mkdir(dataDir)
end

% Opening the csv file to store the data in:
fileID = fopen(fullfile(dataDir,Filename),'w');

% Preparing the headers:
fprintf(fileID, 'Date, FlipRate, EventNumber, Onset, Event\n');

% Setting the format of the data to save:
formatSpec = '%s, %s, %d, %.5f, %s\n';

end

