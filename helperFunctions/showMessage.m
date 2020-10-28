function showMessage(message)
% This function draws messages on the screen
% Inputs: message: String containing the message to be presented
global gray w text
% Drawing gray background
Screen('FillRect', w, gray);
% Drawing the text to the back buffer:
DrawFormattedText(w, message, 'center', 'center',  text.Color);
% Drawing the photodiode square to black to let the experimenter know where
% to clip it
drawPhotodiodBlock(0)

% Flipping the screen:
Screen('Flip', w);
end