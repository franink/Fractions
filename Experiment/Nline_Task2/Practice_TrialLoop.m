function [block_p_points, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(stim, block_p_points, decision_time, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, iti, hold, junk, task, p_slow, p_wrong, p_badpress)
%Controls all stages of a single trial
% This includes ITI, probe box, probe, hold signal, and decision
 
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    Screen('Flip', win);
    WaitSecs(iti-0.5); %This should be variable and is jittered ITI - 0.5
    
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    DrawProbeBox(' ', win, color, yline, center, jitter, winRect);
    Screen('Flip', win);
    WaitSecs(0.5); % Last 500ms of the ITI
    
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    if task == 1;
        DrawProbeBox(stim(1), win, color, yline, center, jitter, winRect);
    end;
    if task == 2;
        DrawProbeBox(stim{1}, win, color, yline, center, jitter, winRect);
    end;
    Screen('Flip', win);
    WaitSecs(0.5); % Probe time

    FlushEvents;
    HideCursor;
    start_t = GetSecs;
    while GetSecs < start_t + hold;
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
        DrawProbeBox('.', win, [255 0 0], yline, center, jitter, winRect);
        Screen('Flip', win);
    end
    
%     WaitSecs(hold); % Hold time this is variable jittered time
    
    if task ==1;
        [block_p_points, p_slow, p_wrong, p_badpress] = NumLineSlow(stim, decision_time, block_p_points, left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, p_slow, p_wrong, p_badpress,speed); %decision
    end;
    if task ==2;
        [block_p_points, p_slow, p_wrong, p_badpress] = ControlSlow(stim, decision_time, block_p_points, left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, p_slow, p_wrong, p_badpress,speed); %decision
    end;

end

