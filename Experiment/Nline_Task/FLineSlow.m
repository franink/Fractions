function block_p_points = NumLineSlow(fract, win, lineLength, jitter, color, time, points)
%plots a line starting at x1, finishing at x2, with cursor starting on
%either left (lrStart = 0) or right (lrStart = 1) side.

%trialResponse format is [startPos, RT, propLine)

    ppc_adjust = 23/38;

    lineLength = round(lineLength*ppc_adjust);

    rng shuffle
    jitter = jitter*randi([-300 300]);
    jitter = round(jitter*ppc_adjust);% Here position of line is jittered

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
    time_fix = 0.01;
    time_on = time - time_fix;

    %initialize log
    %trialResponse = {correct response RT Acc p_points};

    fractMag = fract(1)/fract(2);
    probeMag = fract(4)/fract(5);

    trialResponse = {mouse_pos correct response RT error};

    correct = probeMag;
    
    lineSZ = round(20*ppc_adjust);

    winRect = Screen('Rect', win);

    y = round(winRect(4)/2);
    center = winRect(3)/2;
    
   % yprobe = round(winRect(4)/4); % This is to signal number to be placed

    x1 = round(center - lineLength/2 + jitter); % Here position of line is jittered
    x2 = round(center + lineLength/2 + jitter);% Here position of line is jittered
    
    
    HideCursor;
    
    trialResponse{1} = 0.8*rand + 0.1; %If rand 0 cursonr starts at 0.1 if rand 1 starts at 0.9

    MouseStartPosX = round(trialResponse{1}*(x2-x1) + x1);

    SetMouse(MouseStartPosX,y,win);

    Screen('TextSize',win, 25);
    Screen('TextStyle',win, 1);

    %yTextPos = 2*round(rand) - 1; this was to show probe up or down
    yTextPos = 1;

    zeroBox = Screen('TextBounds', win, '0');
    oneBox = Screen('TextBounds', win, '1');
    zeroBox = CenterRectOnPoint(zeroBox, x1, y + yTextPos*40);
    oneBox = CenterRectOnPoint(oneBox, x2, y + yTextPos*40);
    
    yprobe = y - 100;
    probeBox = Screen('TextBounds', win, probe);
    probeBox = CenterRectOnPoint(probeBox, center + jitter, yprobe);
    probeLeft = probeBox(RectLeft);
    probeTop = probeBox(RectTop);
    
    zX=zeroBox(RectLeft); oX = oneBox(RectLeft); yNum=oneBox(RectTop);

    t_start = GetSecs;
    t_end = t_start + time_on;
    mouseResp = 0;
    
    

    while ~mouseResp;
        [xPos, yPos, click] = GetMouse(win);
        if ~isempty(click) || GetSecs >= t_end;
           if GetSecs >= t_end;
                %sprintf('timeout');
                time_left = 0;
                mouseResp = 1;
           else

                if xPos < x1;
                    xPos = x1;
                end

                if xPos > x2;
                    xPos = x2;
                end

                click = sum(click);

                if click == 1;
                    trialResponse{4} = GetSecs - t_start;
                    trialResponse{3} = (xPos - x1)/(x2-x1);
                    trialResponse{5} = trialResponse{3} - correct;
                    if abs(trialResponse{5}) <= 0.1;
                        block_p_points = points + 1;
                    %mouseResp = 1;
                end


                Screen('Drawline', win,color, x1, y, x2, y, round(5*ppc_adjust)); %instead of color he had [0 0 200 255]
                Screen('Drawline', win, color, x1, y - lineSZ, x1, y + lineSZ, round(5*ppc_adjust));
                Screen('Drawline', win, color, x2, y - lineSZ, x2, y + lineSZ, round(5*ppc_adjust));

                Screen('DrawText', win, '0', zX, yNum, color);
                Screen('DrawText', win, '1', oX, yNum, color);
                
                Screen('DrawText', win, probe, probeLeft, probeTop, color);
                
                Screen('Drawline', win, [0 0 0 0], xPos, y - lineSZ/1.5, xPos, y + lineSZ/1.5, round(5*ppc_adjust));

                Screen('Flip', win);
           end

        end
    end

    %This is if I want fixation to be included
    % fix_on = time_fix + time_left*(time_on - trialResponse{4});
    % DrawCenteredNum('X',win,color,fix_on);
    % Screen('Flip', win);
end
