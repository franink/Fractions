function [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(stim, block_p_points, decision_time, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, iti, hold, junk, task, p_move, p_slow, p_wrong, p_badpress, speed)
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

    % Check that mouse is not moved during 'XXX'
    clearMouseInput;
    FlushEvents;
    HideCursor;
    testX = 0;
    [xPos_fix, yPos_fix] = GetMouse(win);
    start_t = GetSecs;
    while GetSecs < start_t + hold;
        [xPos, yPos] = GetMouse(win);
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
        DrawProbeBox('.', win, [255 0 0], yline, center, jitter, winRect);
        Screen('Flip', win);
        if or(abs(xPos_fix - xPos) > 10, abs(yPos_fix - yPos) > 10);
            testX = 1;
        end
    end
    
%     WaitSecs(hold); % Hold time this is variable jittered time
    
    if task ==1;
        [block_p_points, p_move, p_slow, p_wrong, p_badpress] = NumLineSlow(stim, decision_time, block_p_points, left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, testX, p_move, p_slow, p_wrong, p_badpress,speed); %decision
    end;
    if task ==2;
        [block_p_points, p_move, p_slow, p_wrong, p_badpress] = ControlSlow(stim, decision_time, block_p_points, left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, testX, p_move, p_slow, p_wrong, p_badpress,speed); %decision
    end;

end

