function [block_p_points, p_move, p_slow, p_wrong] = ControlSlow(stim, time, points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, junk, testX, p_move, p_slow, p_wrong)
%plots a line starting at x1, finishing at x2, with cursor starting on
%either left (lrStart = 0) or right (lrStart = 1) side.

    clearMouseInput;

    FlushEvents;
    click = 0;
    

    %set variables
    mouse_pos = -1;
    correct =-1;
    response = -1;
    RT = -1;
    error = -1;
    %time_left = 1;
    time_fix = 0.005;
    time_on = time - time_fix;
    Click = -1;
    RTHold = -1;
    draw = 1;

    
    probe = stim{1}; % Control is already string
    probeMag = stim{2};
    probeLine = stim{3};% syllable printed on the line

    %initialize log
    trialResponse = {mouse_pos correct response RT error RTHold Click probeLine};
    
    if probeLine == probe;
        correct = probeMag;
        Click =1;
    else
        correct = 0;
        Click = 0;
    end;
    % Log changes to control variables
    trialResponse{2} = correct;
    trialResponse{7} = Click;
    
    
        

    %yline = round(winRect(4)/2);

    HideCursor;
    
    % Cursor appears in random position within a fixed +/- range
    displacement = JitterCursor();
    %trialResponse{1} = 0.5 + displacement; %Cursor will always appear outside of nline range.
%     trialResponse{1} = probeMag + displacement; %Cursor will always appear +/- 20-40 from correct position.
    % Only works if also nline has extended endpoints
%     trialResponse{1} = 0.9*rand + 0.1; %If rand 0 cursonr starts at 0.1 if rand 1 starts at 0.9
    trialResponse{1} = 0.5; %Fixed position

    %Extended endpoints
    extension = lineLength/2;
    xStart = x1; %- extension;
    xEnd = x2; %+ extension;
    
    MouseStartPosX = round(trialResponse{1}*(x2-x1) + x1); %Mouse starts in random position
    SetMouse(MouseStartPosX,yline,win);

    Screen('TextSize',win, 30);
    Screen('TextStyle',win, 1);

    t_start = GetSecs;
    t_end = t_start + time_on;
    mouseResp = 0;
    
    %Remove the hold cue
    %Draw numberline
    DrawNline(left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, 1);
    %Draw probe
    DrawProbeBox('.', win, [0 255 0], yline, center, jitter, winRect);
    Screen('Flip', win);
    
    block_p_points = points;
    test = 0;
    
    % Wait for subject to move mouse before displaying cursor
    %[xPos_old, yPos_old] = GetMouse(win);
    while ~test;
        [xPos, yPos, click] = GetMouse(win);
        click = sum(click);
        %if or(xPos_old ~=xPos, yPos_old ~= yPos);
        if click == 1;
            test = 1;
        end;
        if GetSecs >= t_end - 0.001;
            test = 1;
            draw = 0;
        end;
    end;
    
    % Measure RT from the moment the hold signal is released until mouse is
    % moved
    RTHold = GetSecs - t_start;
    trialResponse{6} = RTHold;   
    
    clearMouseInput;

    FlushEvents;
    click = 0;
    
    while ~mouseResp;
        [xPos, yPos, click] = GetMouse(win);
        if ~isempty(click) || GetSecs >= t_end;
           if GetSecs >= t_end;
                %sprintf('timeout');
                time_left = 0;
                trialResponse{3} = 0;
                if junk;
                    trialResponse{5} = 0;
                else
                    trialResponse{5} = 1;
                    p_slow = p_slow + 1;
                end
                if abs(trialResponse{5}) <= 0.1;
                    block_p_points = points + 1;
                end
                if testX == 1;
                    block_p_points = points;
                    p_move = p_move + 1;
                end
                mouseResp = 1;
           else

                if xPos < xStart;
                    xPos = xStart;
                end

                if xPos > xEnd;
                    xPos = xEnd;
                end

                click = sum(click);

                if click == 1;
                    trialResponse{4} = GetSecs - t_start;
                    trialResponse{3} = (xPos - x1)/(x2-x1);
                    if junk; % if catch trial do something if not catch trial do something else
                        trialResponse{5} = 1;
                    else
                        trialResponse{5} = trialResponse{3} - correct;
                    end
                    if abs(trialResponse{5}) <= 0.1;
                        block_p_points = points + 1;
                    else
                        p_wrong = p_wrong + 1;
                    end
                    if testX == 1;
                        block_p_points = points;
                        p_move = p_move + 1;
                    end
                    mouseResp = 1;
                end



                %Draw numberline
                DrawNline(left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, 1);
                %Draw probe
                DrawProbeBox('.', win, [0 255 0], yline, center, jitter, winRect);
%                 Screen('DrawText', win, probe, probeLeft, probeTop, color);

                if draw == 1;
                    %Draw cursor line
                    lineSZc = round(35*ppc_adjust);
                    Screen('Drawline', win, [0 0 0 0], xPos, yline - lineSZc/1.5, xPos, yline + lineSZc/1.5, round(5*ppc_adjust));                
                
                    %Draw arrow for junk trials and/or syllable for control
                    %task
                    Screen('TextSize',win, 30);
                    Screen('TextStyle',win, 1);
                    pBox = Screen('TextBounds', win, probeLine);
                    pBox = CenterRectOnPoint(pBox, round(probeMag*(x2-x1) + x1), yline + 30);
                    pX=pBox(RectLeft);
                    yNum=pBox(RectTop);
                    Screen('DrawText', win, probeLine, pX, yNum, [0 0 0]);
                    %DrawArrow(round(correct*(x2-x1) + x1),y,win,ppc_adjust);
                end
                
                Screen('Flip', win);
           end
        end
    end
    
    WaitTill(t_end);
    %This is if I want fixation to be included
    % fix_on = time_fix + time_left*(time_on - trialResponse{4});
    % DrawCenteredNum('X',win,color,fix_on);
    % Screen('Flip', win);
end
