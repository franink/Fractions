function trialResponse = FractLineRGSlow_Abs(fract, win, lineLength, jitter, color, end_decision, ctch, points)

%plots a line starting at x1, finishing at x2, and ac ursor in 'probe' location
%only appears if the trial has catch = 1

ppc_adjust = 23/38;

lineLength = round(lineLength*ppc_adjust);

rng shuffle
jitter = jitter*randi([-300 300]);
jitter = round(jitter*ppc_adjust);% Here position of line is jittered

%set variables
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.05;
Num_probe = -1;
Denom_probe = -1;
probeMag = -1;


trialResponse = {Num_probe Denom_probe probeMag correct response RT Acc points};


if ctch;
    Num_probe = fract(4);
    Denom_probe = fract(5);
    fractMag = fract(1)/fract(2);
    probeMag = fract(4)/fract(5);
    
    if probeMag > fractMag;
        correct = 1;
    end;
    if probeMag < fractMag;
        correct = 0;
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
        [key, secs] = WaitTill((end_decision-time_fix), {'1' '2' '3' '4' '6' '7' '8' '9'}, 0); %wait seconds even if there is a press
        if~isempty(key);
            trialResponse{5} = str2double(key);
            trialResponse{6} = secs - t_start;
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
