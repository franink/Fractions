function [trialTiming, trialResults] = TrialLoop(stim, points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, Center, winRect, junk, task, start_t, end_ITI, end_consider, end_hold, end_decision, move, slow, wrong, badpress, speed, p)
%Controls all stages of a single trial
% This includes ITI, probe box, probe, hold signal, and decision
 
    
    trialTiming = {0 0 0 0 0};
    trialTiming(1) = {GetSecs - start_t}; %ITI_onset_real
    yprobe = yline - 250;
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
    Screen('Flip', win);
    WaitTill(end_ITI); % Last 500ms of the ITI
    
    trialTiming(2) = {GetSecs - start_t}; %Consider_onset_real
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
    
    
    stimRect = [Center - p.radPix, yprobe - p.radPix,...
                Center + p.radPix, yprobe + p.radPix];
    
    Left = [Center, yprobe];        
    frmCnt=1; %frame count
    while frmCnt<=p.stimExposeCon % if we want multiple exposure durations, add that here
        if GetSecs >= end_consider;
            break
        end
        Screen('DrawTexture',win,stim(p.flickerSequCon(1,frmCnt)),Screen('Rect',stim(p.flickerSequCon(1,frmCnt))),stimRect);
        Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, Left, 0); %change fixation point
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
        Screen('DrawingFinished', win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        Screen('Flip', win);
        frmCnt = frmCnt + 1;
    end
    
    WaitTill(end_consider); % Probe time

    trialTiming(3) = {GetSecs - start_t}; %hold_onset_real
    % Check that mouse is not moved during 'XXX'
    clearMouseInput;
    FlushEvents;
    HideCursor;
    testX = 0;
    [xPos_fix, yPos_fix] = GetMouse(win);
    while GetSecs < end_hold;
        [xPos, yPos] = GetMouse(win);
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
        Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, Left, 0); %change fixation point
        Screen('Flip', win);
        if or(abs(xPos_fix - xPos) > 10, abs(yPos_fix - yPos) > 10);
            testX = 1;
        end
    end
    
    trialTiming(4) = {GetSecs - start_t}; %Decision_onset_real
    trialResults = NumLineSlow_Abs(stim, points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, Center, winRect, junk, testX, end_decision, move, slow, wrong, badpress, speed, p); %decision
    WaitTill(end_decision - 0.001);
    trialTiming(5) = {GetSecs - start_t};
    
end

