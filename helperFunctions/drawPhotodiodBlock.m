%DRAWPHOTODIOD
% draws the photodiod black squere in the corner.
function drawPhotodiodBlock(DiodeColor)
global w ScreenWidth ScreenHeight DIOD_SIZE 

% Computing diode position:
corner = [ScreenWidth; ScreenHeight];
xDiode = transpose(corner) - [DIOD_SIZE/2 DIOD_SIZE/2];
yDiode = transpose(corner);

% Drawing photodiode square to back buffer:
Screen('FillRect', w, DiodeColor, [xDiode yDiode]);

end