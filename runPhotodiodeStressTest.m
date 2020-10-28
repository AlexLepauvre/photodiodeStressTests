function runPhotodiodeStressTest(LumDecrement, debug)
% This function runs a photodiode stress test: the photodiode is flashed
% decrementally fast, to see whether the photodiode can keep up with the
% flashes. We start by flashing it every frame, then every second frame and
% so on, to see where it starts to be able to keep up. Additionally, the
% luminance of the flashed squared is decreased in a stepwise fashion to
% see below which luminance the gain is too low to discriminate from noise
% Author: Alex Lepauvre
% Date: 28/10/2020

%% Setting things up:
global refRate compKbDevice DIOD_SIZE
addpath .\helperFunctions
compKbDevice = -1;

% Colors of the photodiode:
DIOD_ON_COLOUR = [];
ctr= 1;
for i = LumDecrement:LumDecrement:1
    DIOD_ON_COLOUR(ctr) = round(255*i); % Color of the photodiode when on
    ctr = ctr + 1;
end
DIOD_OFF_COLOUR = 0;
DIOD_SIZE = 900;

% Initializing PTB:
initPTB(debug)

% Setting the messages to the experimenter:
INTRO_MESSAGE = 'Welcome to the Photodiode Stress test! \n Make sure that the photodiode is plugged in \n Make sure that the photodiode covers the photodiode square\n\n Press any key to proceed';

% Setting number of flash iterations: 
flashIterations = ceil(30/(refRate));

% Preparing the saving of information:
fileID = openLogFile();

%% Showing the instructions:
showMessage(INTRO_MESSAGE)
KbWait(compKbDevice,3);

%% Staring the test:
% Looping through the difference luminance values for the photodiode:
for i = 1:length(DIOD_ON_COLOUR)

    diodeColor = DIOD_ON_COLOUR(end-(i-1));

    % Starting by flipping every frame:
    for ii = 1:flashIterations
        % Turning the photodiode on
        onset = showPhotodiodBlock(diodeColor);
        logInfo(fileID, 'OneFrame', onset, ii, 'On')
        % Then off
        onset = showPhotodiodBlock(DIOD_OFF_COLOUR);
        logInfo(fileID, 'OneFrame', onset, ii, 'Off')
        % Rinse and repeat
    end
    
    % To mark transition to the next flipping pattern, letting the
    % photodiode off by pausing as is for 5 secs:
    WaitSecs(5)
    
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
end
