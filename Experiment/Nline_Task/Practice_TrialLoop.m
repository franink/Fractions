function [block_p_points] = Practice_TrialLoop(stim, block_p_points, decision_time, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, y, center, winRect, iti, hold, junk)
%Controls all stages of a single trial
% This includes ITI, probe box, probe, hold signal, and decision
DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, y, center, winRect, 0);
Screen('Flip', win);
WaitSecs(iti-0.5); %This should be variable and is jittered ITI - 0.5

DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, y, center, winRect, 0);
DrawProbeBox(' ', win, color, y, center, jitter, winRect);
Screen('Flip', win);
WaitSecs(0.5); % Last 500ms of the ITI

DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, y, center, winRect, 0);
DrawProbeBox(stim(1), win, color, y, center, jitter, winRect);
Screen('Flip', win);
WaitSecs(0.5); % Probe time

DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, y, center, winRect, 0);
DrawProbeBox('XXX', win, color, y, center, jitter, winRect);
Screen('Flip', win);
WaitSecs(hold); % Hold time this is variable jittered time 

block_p_points = NumLineSlow(stim, decision_time, block_p_points, left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, y, center, winRect, junk); %decision


end

