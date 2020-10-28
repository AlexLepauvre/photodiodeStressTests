function logInfo(fileID, FlipRate, onset, eventNumber, event)
% This function writes the info of events to the log:
global formatSpec

% Writing the data to the log (format spec sets things in the right format):
fprintf(fileID, formatSpec, datestr(now,'mm/dd/yy'), FlipRate, eventNumber, onset, event);

end