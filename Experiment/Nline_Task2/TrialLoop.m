function [trialTiming, trialResults] = TrialLoop(stim, points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, task, start_t, end_ITI, end_consider, end_hold, end_decision, slow, wrong, badpress)
%Controls all stages of a single trial
% This includes ITI, probe box, probe, hold signal, and decision
 
    
    trialTiming = {0 0 0 0 0};
    trialTiming(1) = {GetSecs - start_t}; %ITI_onset_real
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    DrawProbeBox('.', win, [0 0 0], yline, center, jitter, winRect);
    Screen('Flip', win);
    WaitTill(end_ITI-0.5); %This should be variable and is jittered ITI - 0.5
    
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    DrawProbeBox(' ', win, color, yline, center, jitter, winRect);
    Screen('Flip', win);
    WaitTill(end_ITI); % Last 500ms of the ITI
    
    trialTiming(2) = {GetSecs - start_t}; %Consider_onset_real
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    DrawProbeBox(stim{1}, win, color, yline, center, jitter, winRect);
%     if task == 1;
%         DrawProbeBox(stim(1), win, color, yline, center, jitter, winRect);
%     end;
%     if task == 2;
%         DrawProbeBox(stim(1), win, color, yline, center, jitter, winRect);
%     end;
%     if task == 3;
%         DrawProbeBox(stim{1}, win, color, yline, center, jitter, winRect);
%     end;
    Screen('Flip', win);
    WaitTill(end_consider); % Probe time

    trialTiming(3) = {GetSecs - start_t}; %hold_onset_real
    FlushEvents;
    HideCursor;
    while GetSecs < end_hold;
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
        DrawProbeBox('.', win, [255 0 0], yline, center, jitter, winRect);
        Screen('Flip', win);
    end
    
    trialTiming(4) = {GetSecs - start_t}; %Decision_onset_real
%     if task ==1;
%         trialResults = NumLineSlow_Abs([stim(1), stim(2)], points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, end_decision, slow, wrong, badpress); %decision
%     end;
%     if task ==2;
%         trialResults = NumLineSlow_Abs([stim(1), stim(2)], points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, end_decision, slow, wrong, badpress); %decision
%     end;
%     if task ==3;
%         trialResults = ControlSlow_Abs([stim(1), stim(2), stim(3), stim(4)], points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, end_decision, slow, wrong, badpress); %decision
%     end;

    trialResults = NumLineSlow_Abs([stim(1), stim(2)], points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, end_decision, slow, wrong, badpress); %decision
    
    WaitTill(end_decision - 0.001);
    trialTiming(5) = {GetSecs - start_t};
    
end

