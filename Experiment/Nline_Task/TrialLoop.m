function trialResults = TrialLoop(stim, points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, task, iti_end, consider_end, hold_end, decision_end)
%Controls all stages of a single trial
% This includes ITI, probe box, probe, hold signal, and decision
 
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    Screen('Flip', win);
    WaitTill(iti_end-0.5); %This should be variable and is jittered ITI - 0.5
    
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
    DrawProbeBox(' ', win, color, yline, center, jitter, winRect);
    Screen('Flip', win);
    WaitTill(iti_end); % Last 500ms of the ITI
    
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
    WaitTill(consider_end); % Probe time

    % Check that mouse is not moved during 'XXX'
    clearMouseInput;
    FlushEvents;
    HideCursor;
    testX = 0;
    [xPos_fix, yPos_fix] = GetMouse(win);
    while GetSecs < hold_end;
        [xPos, yPos] = GetMouse(win);
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, center, winRect, 0);
        DrawProbeBox('XXX', win, color, yline, center, jitter, winRect);
        Screen('Flip', win);
        if or(abs(xPos_fix - xPos) > 10, abs(yPos_fix - yPos) > 10);
            testX = 1;
        end
    end
    
%     WaitSecs(hold); % Hold time this is variable jittered time
    
    if task ==1;
        trialResults = NumLineSlow_Abs([stim{1}, stim{2}], points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, testX, decision_end); %decision
    end;
    if task ==2;
        trialResults = NumLineSlow_Abs([stim{1}, stim{2}], points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, testX, decision_end); %decision
    end;
    if task ==3;
        trialResults = ControlSlow_Abs(stim, points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, testX, decision_end); %decision
    end;
    WaitTill(decision_end - 0.005);

end

