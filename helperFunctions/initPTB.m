
function initPTB(debug)
%% OUT 
global ScreenWidth ScreenHeight center w refRate gray

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

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Do a simply calculation to calculate the luminance value for grey. This
% will be half the luminace values for white
gray            =   [125,125,125];
% Open an on screen window using PsychImaging and color it grey.
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'TextRenderer', 1);
% WINDOW_RESOLUTION = [100 100 600 900];
% Opening a gray window:
if debug
    WINDOW_RESOLUTION = [10 10 900 400];
    [w, wRect] =  Screen('OpenWindow',screenNumber, gray,WINDOW_RESOLUTION);
else
    % Opening a gray window fullscreen:
    [w, wRect]  =  Screen('OpenWindow',screenNumber, gray);
end

% Getting the dimensions of the window:
ScreenWidth     =  wRect(3);
ScreenHeight    =  wRect(4);
center          =  [ScreenWidth/2; ScreenHeight/2];

hz = Screen('NominalFrameRate', w);
disp(hz);
refRate = hz.^(-1);

end