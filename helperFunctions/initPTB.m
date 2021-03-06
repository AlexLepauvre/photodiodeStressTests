
function initPTB(debug)
%% OUT 
global ScreenWidth ScreenHeight center w refRate gray text

%% Setting up PTB
% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = max(screens);

% Do a simply calculation to calculate the luminance value for grey. This
% will be half the luminace values for white
gray            =   [125,125,125];

% Not skipping the sync test:
Screen('Preference', 'SkipSyncTests', 0);
Screen('Preference', 'TextRenderer', 1);

% Opening a gray window:
if debug
    WINDOW_RESOLUTION = [10 10 1920/2 1080/2];
    [w, wRect] =  Screen('OpenWindow',screenNumber, gray,WINDOW_RESOLUTION);
else
    % Opening a gray window fullscreen:
    [w, wRect]  =  Screen('OpenWindow',screenNumber, gray);
end

% Getting the dimensions of the window:
ScreenWidth     =  wRect(3);
ScreenHeight    =  wRect(4);
center          =  [ScreenWidth/2; ScreenHeight/2];

% Computing the duration of each frames:
hz = Screen('NominalFrameRate', w);
disp(hz);
refRate = hz.^(-1);

%% Text parameters 
% Setting the parameters for the visual aspect of the text:
fontType = 'David'; % Font of the text
fontSize = 50; % general text size
fontColor = 0; % black;
screenScaler = ScreenWidth/1920; % Setting screen scaler to adapt text size to different screen sizes
Screen('TextFont',w, fontType); % Setting the font type
Screen('TextStyle', w, 0); % Text style
Screen('TextSize', w, round(fontSize*screenScaler)); % Text size
text.Color = fontColor; %black

end