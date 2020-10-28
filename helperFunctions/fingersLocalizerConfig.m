% This function initialize the parameters of the finger localizer, The
% variable in caps are the ones that will be passed back to the main
% function, while the small ones are bounded to this function only!

function fingersLocalizerConfig(hand,SUBID)
%% IN
global ScreenWidth ScreenHeight w refRate

%% OUT
% Timings: 
global BUTTON_OFFSET_DELAY
% Responses:
global ABORTKEY FINGERS RESPKEYS
% Stimuli:
global CIRCLESCOORDINATES CIRCLESCOLORS GRAY STIMRADIUSINPIXELS
% Trial matrix:
global TRIALTABLE
% Photodiode
global DIOD_ON_COLOUR DIOD_OFF_COLOUR xDiode yDiode DIOD_SIZE PHOTODIODEDURATION
% Instructions  
global INTROTEXT text CONGRATULATIONTEXT INSTRUCTIONS1TEXT INSTRUCTIONS2TEXT INSTRUCTIONS3TEXT INSTRUCTIONS4TEXT INSTRUCTIONS5TEXT INSTRUCTIONS6TEXT READYMESSAGE
% Saving parameters
global LOGFILENAME CODEFILE LOGFILENAMEMAT

%% Timing parameters:
% In here you will find the parameters regarding the duration of the
% different stimuli:
MeanITI = 0.550; % Change here to change the duration between the trials
MinITI = 0.400;
MaxITI = 0.700;
BUTTON_OFFSET_DELAY = 0.2; % Time before the button disappears
% Need to convert that to be multiple of the refresh rate:
BUTTON_OFFSET_DELAY = ((round((BUTTON_OFFSET_DELAY*1000)/refRate))*refRate)/1000;

%% Response params
% In here, you will find  the parameters regarding keys to press for
% responses
KbName('UnifyKeyNames');
OneKey      =  KbName('1!'); %
TwoKey      =  KbName('2@');
ThreeKey    =  KbName('3#');
FourKey    =  KbName('4$');
FiveKey      =  KbName('5%');
SixKey      =  KbName('6^');
SevenKey    =  KbName('7&');
EightKey     =  KbName('8*');
ABORTKEY    =  KbName('ESCAPE'); % ESC aborts experiment

% Depending on the hand that is used, different fingers for different keys:
switch hand
    case 'both'
        FINGERS = {'leftMiddle' 'LeftIndex' 'rightIndex' 'rightMiddle'};
        RESPKEYS = [OneKey TwoKey ThreeKey FourKey];
    case 'right'
        FINGERS = {'rightThumb' 'rightIndex' 'rightMiddle' 'rightRing'};
        RESPKEYS = [EightKey SixKey ThreeKey FourKey];
    case 'left'
        FINGERS = {'leftRing' 'leftMiddle' 'leftIndex' 'leftThumb'};
        RESPKEYS = [EightKey SixKey ThreeKey FourKey];
end


%% Stimuli parameters
% In here, you will find the parameters controlling the different aspects
% of the stimuli: size, position, colors...
% Creating color names vector to know which to present:
colorNames = {'white' 'yellow' 'blue' 'pink'};

GRAY = [125 125 125];
% These colors match the response box colors:
white  = [255,255,255];
yellow = [255,255,0];
blue   = [0,0,255];
pink   = [255,128,128];


% Setting the circles size and position
circlesRelativeSize = 0.1; % Change here to make the circles bigger or smaller
circlesXPositionRef = 0.5; % Change here to change the centerization of the stimuli in the XAXIS
circlesYPositionRef = 0.5; % Change here to set the stimuli higher or lower

% Here, I calculate the size of the stimulus in pixels for ease of
% positioning down the line
STIMRADIUSINPIXELS = circlesRelativeSize * ScreenWidth;

% Setting the centers of the circles:
% We have n stimuli which we want to have spaced out from 0.2 to 0.8 on the
% screen. Here I calculate the center of each:
stimuliXCenters = [0.2:0.8/length(colorNames):0.8]*ScreenWidth;
stimuliYCenters = repmat(circlesYPositionRef,1,length(colorNames))*ScreenHeight;

% Setting the borders of the stimuli
circlesX1Positions = (stimuliXCenters - STIMRADIUSINPIXELS/2);
circlesX2Positions = (stimuliXCenters + STIMRADIUSINPIXELS/2);
circlesY1Position = (stimuliYCenters - STIMRADIUSINPIXELS/2);
circlesY2Position = (stimuliYCenters + STIMRADIUSINPIXELS/2);

% Combining the coordinates of all the circles into one to pass on to the
% drawing function down the line:
CIRCLESCOORDINATES = [circlesX1Positions; circlesY1Position; circlesX2Positions; circlesY2Position];

% Setting the circle colors
CIRCLESCOLORS = [white' yellow' blue' pink'];

%% Trials Matrix
% Finally, deciding on the number to present and in which order
keysRepetitions = 20; % Change here if you want each button to be repeated more or less ofeter
keysToPressInParts = []; % Pre allocation

% Then, for each key, I add n events
for i = 1:4
    keysToPressInParts(:,i) = [repmat(1,keysRepetitions/4,1);repmat(2,keysRepetitions/4,1);...
        repmat(3,keysRepetitions/4,1);repmat(4,keysRepetitions/4,1)];
end


% We need to shuffle that until we don't have twice the same:
Constraint2 = 1;
while Constraint2
    for i = 1:4
        Constraint1 = 1;
        while Constraint1
            % Now shuffling the row:
            keysToPressInParts(:,i) = keysToPressInParts(randperm(size(keysToPressInParts,1)),i);
            
            % Checking if the constraint is met. If not, we go for another loop
            Constraint1 = verifyConstraint(keysToPressInParts(:,i));
        end
    end
    keysToPress = reshape(keysToPressInParts,[size(keysToPressInParts,1)*size(keysToPressInParts,2) 1]);
    Constraint2 = verifyConstraint(keysToPress);
end

% Corresponding fingers:
% Each key corresponds to a finger:
for i = 1 : length(keysToPress)
    fingersToPress{i,1} = upper(FINGERS(keysToPress(i)));
end

% Stimuli duration:
% Generating a uniform distribution with the parameters above:
% The trick is to make them multiples of the refresh rate
minITIFactor = round((MinITI*1000)/refRate);
maxITIFactor = round((MaxITI*1000)/refRate);

% Then drawing a random distribution which is rounded:
ITIs = round(unifrnd(minITIFactor,maxITIFactor,length(keysToPress),1));

% Then, storing the ITS
ITIduration = (ITIs*refRate)/1000;

% Participant ID:
SubID = cellstr(repmat(SUBID,length(keysToPress),1));

% Response time:
respTime = nan(length(keysToPress),1);

% responseFinger:
responseFinger = num2cell(nan(length(keysToPress),1));


% stimOnset:
stimOnset = nan(length(keysToPress),1);
stimOffset = nan(length(keysToPress),1);

% Creating the trial table:
TRIALTABLE = table(SubID,keysToPress,fingersToPress,ITIduration,stimOnset,stimOffset,respTime,responseFinger);

%% Triggers parameters:
% Here you will find all the paramters regarding the photodiode trigger:
DIOD_SIZE = 900; % Size of the photodiode trigger in pixels
DIOD_ON_COLOUR = 255; % Color of the photodiode when on
DIOD_OFF_COLOUR= 0;
corner = [ScreenWidth; ScreenHeight]; % Coordinates of the corner of the screen
xDiode = transpose(corner) - [DIOD_SIZE/2 DIOD_SIZE/2]; % Getting the x coordinates of the photodiode
yDiode = transpose(corner); % Getting the Y coordinates of the photodiode
PHOTODIODEDURATION = 3; % In frames

%% Text parameters:
% Here you will find the instructions:
% Creating the text messages to be presented:
IntroText = 'Welcome to the study.\n\n Many thanks for your participation.';
Instructions1Text = 'You will see circles of the same color as the\n \n buttons on the response device in front of you.';
Instructions2Text = 'One after the other, the circles will get filled.';
Instructions3Text = 'Your task will be to press the button of the corresponding color.';
Instructions4Text = 'So for example, if you see that the yellow dot gets bigger,\n \n you should press the yellow button on the device.';
Instructions5Text = 'Try to keep looking at the center of the screen during the task.';
Instructions6Text = 'Press any button to continue';
ReadyMessage = 'Press any button to start.';
CongratulationText = 'Well done! The finger localizer task is now over. Thanks a lot!';

% Converting them to doubles:
INTROTEXT = double(IntroText);
INSTRUCTIONS1TEXT = double(Instructions1Text);
INSTRUCTIONS2TEXT = double(Instructions2Text);
INSTRUCTIONS3TEXT = double(Instructions3Text);
INSTRUCTIONS4TEXT = double(Instructions4Text);
INSTRUCTIONS5TEXT = double(Instructions5Text);
INSTRUCTIONS6TEXT = double(Instructions6Text);


READYMESSAGE = double(ReadyMessage);
CONGRATULATIONTEXT = double(CongratulationText);

% Setting the parameters for the visual aspect of the text:
fontType = 'David'; % Font of the text
fontSize = 50; % general text size
fontColor = 0; % black;
screenScaler = ScreenWidth/1920; % Setting screen scaler to adapt text size to different screen sizes
Screen('TextFont',w, fontType); % Setting the font type
Screen('TextStyle', w, 0); % Text style
Screen('TextSize', w, round(fontSize*screenScaler)); % Text size
text.Color = fontColor; %black

%% Saving parameters:
% Here I set the path and names of where the data should get saved:
dataFolder = 'DATA';
xlFormat = '.csv';
matformat = '.mat';
path = pwd;
LOGFILENAME = fullfile(path,dataFolder,SUBID,[SUBID '_FingersLocalizer_LOG' xlFormat]);
LOGFILENAMEMAT = fullfile(path,dataFolder,SUBID,[SUBID '_FingersLocalizer_LOG' matformat]);
CODEFILE = fullfile(path,dataFolder,SUBID,[SUBID '_Code']);

% Creating the folders:
if ~exist(fullfile(path,dataFolder))
    mkdir(fullfile(path,dataFolder))
end
if exist(fullfile(path,dataFolder,SUBID))
    sca
    error('The subject you are trying to run already exist')
else
    mkdir(fullfile(path,dataFolder,SUBID))
end


end