function showMessage(message)
global gray w text
Screen('FillRect', w, gray);
DrawFormattedText(w, message, 'center', 'center',  text.Color);
drawPhotodiodBlock ('off')
Screen('Flip', w);
end