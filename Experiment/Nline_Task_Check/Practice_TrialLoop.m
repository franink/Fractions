function [block_p_points, p_move, p_slow, p_wrong, p_badpress] = Practice_TrialLoop(stim, block_p_points, decision_time, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, Center, winRect, iti, hold, junk, task, p_move, p_slow, p_wrong, p_badpress, speed, p)
%Controls all stages of a single trial
% This includes ITI, probe box, probe, hold signal, and decision
 
    yprobe = yline - 250;
    DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
    Screen('Flip', win);
    WaitSecs(iti-0.5); %This should be variable and is jittered ITI - 0.5
    
    stimRect = [Center - p.radPix, yprobe - p.radPix,...
                Center + p.radPix, yprobe + p.radPix];
    
    Left = [Center, yprobe];        
    frmCnt=1; %frame count
    while frmCnt<=p.stimExposeCon % if we want multiple exposure durations, add that here
        Screen('DrawTexture',win,stim(p.flickerSequCon(1,frmCnt)),Screen('Rect',stim(p.flickerSequCon(1,frmCnt))),stimRect);
        Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, Left, 0); %change fixation point
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
        Screen('DrawingFinished', win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        Screen('Flip', win);
        frmCnt = frmCnt + 1;
    end
    
    % Check that mouse is not moved during 'XXX'
    clearMouseInput;
    FlushEvents;
    HideCursor;
    testX = 0;
    [xPos_fix, yPos_fix] = GetMouse(win);
    start_t = GetSecs;
    while GetSecs < start_t + hold;
        [xPos, yPos] = GetMouse(win);
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
        Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, Left, 0); %change fixation point
        Screen('Flip', win);
        if or(abs(xPos_fix - xPos) > 10, abs(yPos_fix - yPos) > 10);
            testX = 1;
        end
    end
    
%     WaitSecs(hold); % Hold time this is variable jittered time
    
    if task ==1;
        [block_p_points, p_move, p_slow, p_wrong, p_badpress] = NumLineSlow(stim, decision_time, block_p_points, left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, junk, testX, p_move, p_slow, p_wrong, p_badpress,speed,p); %decision
    end;
    
end

