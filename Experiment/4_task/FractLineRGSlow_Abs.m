function trialResponse = FractLineRGSlow_Abs(fract, win, lineLength, jitter, color, end_decision, ctch, points, LR)

% Version for real experiment in absolute time (unlike practice trials)
%Draws a numberline and a mark in the position of probe fraction, 
%waits for a response or for time and logs
%responses and stim used
%only appears if the trial has catch = 1

ppc_adjust = 23/38;

lineLength = round(lineLength*ppc_adjust);

% Jitter horizontal position of numberline
rng shuffle
jitter = jitter*randi([-300 300]);
jitter = round(jitter*ppc_adjust);% Here position of line is jittered

%set variables to -1 to catch missing trials and errors
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.05; %Allows code to exit to keep experiment on time
Num_probe = -1;
Denom_probe = -1;
probeMag = -1;

%Initialize log
trialResponse = {Num_probe Denom_probe probeMag correct response RT Acc points};


if ctch;
    Num_probe = fract(4);
    Denom_probe = fract(5);
    fractMag = fract(1)/fract(2);
    probeMag = fract(4)/fract(5);
    
    %Decide what is correct response
    if LR == 0; %This is for counterbalncing hand response
        if probeMag > fractMag;
            correct = 1;
        end;
        if probeMag < fractMag;
            correct = 0;
        end;           
    end;
    
    if LR == 1;
        if probeMag > fractMag;
            correct = 0;
        end;
        if probeMag < fractMag;
            correct = 1;
        end;
    end;
    
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

    HideCursor;
    t_start = GetSecs;

    Screen('TextSize',win, 25);
    Screen('TextStyle',win, 1);

    yTextPos = 2*round(rand) - 1;

    zeroBox = Screen('TextBounds', win, '0');
    oneBox = Screen('TextBounds', win, '1');
    zeroBox = CenterRectOnPoint(zeroBox, x1, y + yTextPos*40);
    oneBox = CenterRectOnPoint(oneBox, x2, y + yTextPos*40);

    zX=zeroBox(RectLeft); oX = oneBox(RectLeft); yNum=oneBox(RectTop);

    %Draw number line
    Screen('Drawline', win,color, x1, y, x2, y, round(5*ppc_adjust)); %instead of color he had [0 0 200 255]
    Screen('Drawline', win, color, x1, y - lineSZ, x1, y + lineSZ, round(5*ppc_adjust));
    Screen('Drawline', win, color, x2, y - lineSZ, x2, y + lineSZ, round(5*ppc_adjust));
    %Add '0' and '1' to endpoints
    Screen('DrawText', win, '0', zX, yNum, color);
    Screen('DrawText', win, '1', oX, yNum, color);


    % Draw line mark at probe position
    probe_XPos = x1 + (x2-x1)*probeMag;
    Screen('Drawline', win, [0 0 0 0], probe_XPos, y - lineSZ/1.5, probe_XPos, y + lineSZ/1.5, round(5*ppc_adjust));

    Screen('Flip', win);
    
    t_start = GetSecs;
        KbReleaseWait;
        time = end_decision-time_fix;
        [key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'});
        if~isempty(key);
            trialResponse{5} = str2double(key);
            trialResponse{6} = secs - t_start;
            %Let participants know their response was recorded by flipping
            %the screen
            t_remain = time - secs;
            Screen('Flip', win);
            %Draw number line
            Screen('Drawline', win,color, x1, y, x2, y, round(5*ppc_adjust)); %instead of color he had [0 0 200 255]
            Screen('Drawline', win, color, x1, y - lineSZ, x1, y + lineSZ, round(5*ppc_adjust));
            Screen('Drawline', win, color, x2, y - lineSZ, x2, y + lineSZ, round(5*ppc_adjust));
            %Add '0' and '1' to endpoints
            Screen('DrawText', win, '0', zX, yNum, color);
            Screen('DrawText', win, '1', oX, yNum, color);
            % Draw line mark at probe position
            probe_XPos = x1 + (x2-x1)*probeMag;
            Screen('Drawline', win, [0 0 0 0], probe_XPos, y - lineSZ/1.5, probe_XPos, y + lineSZ/1.5, round(5*ppc_adjust));
            Screen('Flip', win);
            
            left = {'1' '2' '3' '4'};
            right = {'6' '7' '8' '9'};
            if ismember(key, left);
                response = 0;
            end
            if ismember(key, right);
                response = 1;
            end
            trialResponse{7} = correct==response;
            if trialResponse{7} == 1;
                trialResponse{8} = trialResponse{8} + 1;
            end
        end
    
    
    %This is if I want fixation to be included
    % fix_on = time_fix + time_left*(time_on - trialResponse{4});
    % DrawCenteredNum('X',win,color,fix_on);
    % Screen('Flip', win);
end

end
