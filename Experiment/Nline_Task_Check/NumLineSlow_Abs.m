function trialResponse = NumLineSlow_Abs(stim, points, left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, Center, winRect, junk, testX, end_decision, move, slow, wrong, badpress, speed, p)

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
    Click = -1;
    RTHold = -1;
    draw = 1;
    mousetrack = [];
    
    %checkerboar location
    yprobe = yline - 250;
    Left = [Center, yprobe];
    
    %probe = num2str(stim{1});
    probeMag = 50;

    %Initialize log
    trialResponse = {mouse_pos correct response RT error RTHold Click testX points move slow wrong badpress mousetrack};

    correct = probeMag;
    
    if junk ==1;
        Click = 0;
        correct = 0;
    else
        Click = 1;
    end;
    % Log changes to control variables
    trialResponse{2} = correct;
    trialResponse{7} = Click;
    
    HideCursor;
    
    displacement = JitterCursor();
%     trialResponse{1} = 0.5 + displacement; %Cursor will always appear outside of nline range.
%     trialResponse{1} = probeMag + displacement; %Cursor will always appear +/- 20-40 from correct position.
    % Only works if also nline has extended endpoints
%     trialResponse{1} = 0.9*rand + 0.1; %If rand 0 cursonr starts at 0.1 if rand 1 starts at 0.9
    trialResponse{1} = 0.5; %Fixed position

    %Extended endpoints
    extension = lineLength/2;
    xStart = x1; % - extension;
    xEnd = x2; % + extension;
    
    MouseStartPosX = round(trialResponse{1}*(x2-x1) + x1); %Mouse starts in random position
%     MouseStartPosX = round(0.5*(x2-x1) + x1) %Mouse position in center of line this can change
    SetMouse(MouseStartPosX,yline,win);
    

    Screen('TextSize',win, 30);
    Screen('TextStyle',win, 1);

    t_start = GetSecs;
    mouseResp = 0;
      
%     %Draw frame
%     winRect = Screen('Rect', win);
%     Screen('FrameRect', win, [255 255 255 255], winRect, 30);
%     Screen('Flip', win, 0, 1);

%Remove the hold cue
    %Draw numberline
    DrawNline(left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 1);
    %Draw probe
    Screen('DrawDots', win, [0,0], p.fixSizePix, [0 255 0], Left, 0); % green fixation
    Screen('Flip', win);
    
    test = 0;
    % Wait for subject to click mouse before displaying cursor
    %[xPos_old, yPos_old] = GetMouse(win);
    while ~test;
        [xPos, yPos, click] = GetMouse(win);
        click = sum(click);
        %if or(xPos_old ~=xPos, yPos_old ~= yPos);
        if click == 1;
            test = 1;
        end;
        if GetSecs >= end_decision - 0.001;
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
    SetMouse(MouseStartPosX,yline,win);
    mousetrack = [(MouseStartPosX - x1)/(x2-x1)];
    %xPos = MouseStartPosX;
    
    stimRect = [Center - p.radPix, yprobe - p.radPix,...
                Center + p.radPix, yprobe + p.radPix];
    
    frmCnt=1; %frame count
    while frmCnt<=p.stimExposeDec % if we want multiple exposure durations, add that here
        if GetSecs >= end_decision - time_fix;
            break
        end
        %sprintf('timeout');
        time_left = 0;
        trialResponse{3} = 0;
        if junk;
            trialResponse{5} = 0;
        else
            trialResponse{5} = 1;
            trialResponse{11} = slow + 1;
        end
        if abs(trialResponse{5}) <= 0.05;
            trialResponse{9} = points + 1;
        end
        if testX == 1;
            trialResponse{9} = points;
            trialResponse{10} = move + 1;
        end
        
        Screen('DrawTexture',win,stim(p.flickerSequDec(1,frmCnt)),Screen('Rect',stim(p.flickerSequDec(1,frmCnt))),stimRect);
        Screen('DrawDots', win, [0,0], p.fixSizePix, p.fixColor, Left, 0); %change fixation point
        DrawNline(left_end, right_end, lineLength, lineSZ, 0, ppc_adjust, win, color, x1, x2, yline, Center, winRect, 0);
        Screen('DrawingFinished', win); % Tell PTB that no further drawing commands will follow before Screen('Flip')
        Screen('Flip', win);
        frmCnt = frmCnt + 1;
    end
                

    %This is if I want fixation to be included
    % fix_on = time_fix + time_left*(time_on - trialResponse{4});
    % DrawCenteredNum('X',win,color,fix_on);
    % Screen('Flip', win);
end

