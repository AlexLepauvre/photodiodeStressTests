function runPhotodiodeStressTest(flashIterations, LumDecrement, PhotodiodeSize, debug)
% This function runs a photodiode stress test: the photodiode is flashed
% decrementally fast, to see whether the photodiode can keep up with the
% flashes. We start by flashing it every frame, then every second frame and
% so on, to see where it starts to be able to keep up. Additionally, the
% luminance of the flashed squared is decreased in a stepwise fashion to
% see below which luminance the gain is too low to discriminate from noise
% Author: Alex Lepauvre
% Date: 28/10/2020
% -------------------------------------------------------------------------
% Inputs:
% - flashIterations: how often should the photodiode be flashed on and off
% - LumDecrement: coefficient of luminance decrement, number between 0 and
% 1. If set to 0.25, the photodiode will be presented at 100%, 75%, 50% and
% 25% successively
% - debug: if set to 1, the experiment will be ran in windowed mode, sync
% test will be skipped. If not given, set to 0 automatically
% - PhotodiodeSize: Size of the photodiode in pixels
% -------------------------------------------------------------------------
% Outputs:
% - log files as csvs
%% Houskeeping:
sca
clc
clearvars -except LumDecrement PhotodiodeSize debug
close all

%% Setting things up:
% Setting global variables:
global compKbDevice DIOD_SIZE
addpath .\helperFunctions
compKbDevice = -1;

% Checking the numbers of inputs and setting defaults if needed:
if nargin == 4
    DIOD_SIZE = PhotodiodeSize;
elseif nargin == 3
    DIOD_SIZE = PhotodiodeSize;
    debug = 0;
elseif nargin == 2
    debug = 0;
    DIOD_SIZE = 200;
elseif nargin == 1
    debug = 0;
    DIOD_SIZE = 200;
    LumDecrement = 0.25;
elseif nargin == 0
    debug = 0;
    DIOD_SIZE = 200;
    LumDecrement = 0.25;
    flashIterations = 1000;
end

% Computing values of the photodiode luminance according to the number of
% requested increments coefficients:
DIOD_ON_COLOUR = [];
ctr= 1;
for i = LumDecrement:LumDecrement:1
    DIOD_ON_COLOUR(ctr) = round(255*i); % Color of the photodiode when on
    ctr = ctr + 1;
end
% Setting the color of the photodiode when turning it off:
DIOD_OFF_COLOUR = 0;

% Initializing PTB:
initPTB(debug)

% Setting the messages to the experimenter:
INTRO_MESSAGE = 'Welcome to the Photodiode stress test! \n Make sure that the photodiode is plugged in \n Make sure that the photodiode covers the photodiode square\n\n Press any key to proceed';

% Creating and opening the file where the data will be saved:
fileID = openLogFile();

%% Starting experiment:
% Showing the instructions:
showMessage(INTRO_MESSAGE)
KbWait(compKbDevice,3);

%% Staring the test:
try
    % Looping through the difference luminance values for the photodiode:
    for i = 1:length(DIOD_ON_COLOUR)
        
        % Setting the color of the photodiode for that iteration
        diodeColor = DIOD_ON_COLOUR(end-(i-1));
        
        %% Each frame flips:
        % Starting by flipping every frame:
        for ii = 1:flashIterations
            % Turning the photodiode on
            onset = showPhotodiodBlock(diodeColor);
            % Saving the data to the log
            logInfo(fileID, 'OneFrame', onset, ii, 'On')
            % Then off
            onset = showPhotodiodBlock(DIOD_OFF_COLOUR);
            % Saving the data to the log
            logInfo(fileID, 'OneFrame', onset, ii, 'Off')
            % Rinse and repeat
        end
        
        % To mark transition to the next flipping pattern, letting the
        % photodiode off by pausing as is for 5 secs:
        WaitSecs(5)
        
        %% Every second frames flips:
        % Starting by flipping every second frames:
        for ii = 1:flashIterations
            % Turning the photodiode on
            onset = showPhotodiodBlock(diodeColor);
            showPhotodiodBlock(diodeColor);
            logInfo(fileID, 'TwoFrames', onset, ii, 'On')
            % Then off
            onset = showPhotodiodBlock(DIOD_OFF_COLOUR);
            showPhotodiodBlock(DIOD_OFF_COLOUR);
            logInfo(fileID, 'TwoFrames', onset, ii, 'Off')
            % Rinse and repeat
        end
        
        % To mark transition to the next flipping pattern, letting the
        % photodiode off by pausing as is for 5 secs:
        WaitSecs(5)
        
        %% Every three frames flips:
        % Starting by flipping every three frames:
        for ii = 1:flashIterations
            % Turning the photodiode on
            onset = showPhotodiodBlock(diodeColor);
            showPhotodiodBlock(diodeColor);
            showPhotodiodBlock(diodeColor);
            logInfo(fileID, 'ThreeFrames', onset, ii, 'On')
            % Then off
            onset = showPhotodiodBlock(DIOD_OFF_COLOUR);
            showPhotodiodBlock(DIOD_OFF_COLOUR);
            showPhotodiodBlock(DIOD_OFF_COLOUR);
            logInfo(fileID, 'ThreeFrames', onset, ii, 'Off')
            % Rinse and repeat
        end
    end
    
    %% Terminating the experiment:
    % Closing PTB:
    sca
    % Closing the log file:
    fclose(fileID);
catch ME % Catching potential errors
    % Closing PTB:
    sca
    % Closing the log file:
    fclose(fileID);
    % Rethrowing whatever error occured
    rethrow(ME)
end
