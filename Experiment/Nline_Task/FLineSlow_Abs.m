function trialResponse = NumLineSlow_Abs(fract, win, lineLength, jitter, color, end_decision, points)

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
%set variables to -1 to catch missing trials and errors
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.05; %Allows code to exit to keep experiment on time
Num_probe = -1;
Denom_probe = -1;
probeMag = -1;
mouse_pos = -1;
error = -1;


%Initialize log
trialResponse = {correct response RT Error points mouse_pos};



if ctch;

    Num_probe = fract(4);
    Denom_probe = fract(5);
    fractMag = fract(1)/fract(2);
    probeMag = fract(4)/fract(5);
    correct = probeMag
    probe = [num2str(Num_probe) '/' num2str(Denom_probe)]
    
    
    trialResponse{1} = Num_probe;
    trialResponse{2} = Denom_probe;
    trialResponse{3} = probeMag;
    trialResponse{4} = correct;
    
    lineSZ = round(20*ppc_adjust);

    winRect = Screen('Rect', win);

    y = round(winRect(4)/2);
    center = winRect(3)/2;
    
    x1 = round(center - lineLength/2 + jitter); % Here position of line is jittered
    x2 = round(center + lineLength/2 + jitter);% Here position of line is jittered
    
    %Find out where mark should be placed
    %correct = correct/25;
    %trialResponse{2} = correct;

    HideCursor;
    t_start = GetSecs;

    StartCursor = 0.8*rand + 0.1; %If rand 0 cursonr starts at 0.1 if rand 1 starts at 0.9

    MouseStartPosX = round(StartCursor*(x2-x1) + x1);

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
    
    %Draw frame
    winRect = Screen('Rect', win);
    Screen('FrameRect', win, [255 255 255 255], winRect, 30);
    Screen('Flip', win, 0, 1);

    % t_start = GetSecs;
    % t_end = t_start + time_on;
    mouseResp = 0;

    while ~mouseResp;
        [xPos, yPos, click] = GetMouse(win);
        if ~isempty(click) || GetSecs >= end_decision - time_fix;
           if GetSecs >= end_decision - time_fix;
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
                    trialResponse{6} = GetSecs - t_start;
                    trialResponse{5} = (xPos - x1)/(x2-x1);
                    trialResponse{7} = trialResponse{5} - correct;
                    if abs(trialResponse{7}) <= 0.1;
                        trialResponse{8} = points + 1;
                    end
                    mouseResp = 1;
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

end
