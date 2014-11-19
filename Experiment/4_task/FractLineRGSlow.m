function block_p_points = FractLineRGSlow(fract, win, lineLength, jitter, color, time, points)

% Version for practice (relative time unlike real trials)
%Draws a numberline with a mark in the position of the probe fraction,
%waits for a response or for time and logs
%responses and stim used
%only appears if the trial has catch = 1


ppc_adjust = 23/38;

lineLength = round(lineLength*ppc_adjust);

% Jitter horizontal position of number line
rng shuffle
jitter = jitter*randi([-300 300]);
jitter = round(jitter*ppc_adjust);% Here position of line is jittered

%set variables to -1 to catch errors and missing data
correct =-1;
response = -1;
RT = -1;
Acc = -1;
time_fix = 0.01;
%time_on = time - time_fix;

%initialize log
%trialResponse = {correct response RT Acc p_points};

fractMag = fract(1)/fract(2);
probeMag = fract(4)/fract(5);

%Decide what is correct response
if probeMag > fractMag;
    correct = 1;
end;
if probeMag < fractMag;
    correct = 0;
end;

%trialResponse{1} = correct;

%trialResponse{2} = correct;

lineSZ = round(20*ppc_adjust);

winRect = Screen('Rect', win);

y = round(winRect(4)/2);
center = winRect(3)/2;

x1 = round(center - lineLength/2 + jitter); % Here position of line is jittered
x2 = round(center + lineLength/2 + jitter);% Here position of line is jittered

HideCursor;

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

tot_time = time - time_fix;
t_start = GetSecs;
time = time+t_start;
KbReleaseWait;
[key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'});
if~isempty(key);
    %trialResponse{2} = key;
    %trialResponse{3} = secs - t_start;
    
    %Let participants know that their answer was reocrded by flipping
    %the screen
    t_remain = tot_time - (secs - t_start);
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
    WaitSecs(t_remain);
    
    left = {'1' '2' '3' '4'};
    right = {'6' '7' '8' '9'};
    if ismember(key, left);
        response = 0;
    end
    if ismember(key, right);
        response = 1;
    end
    %trialResponse{4} = correct==response;
    if correct == response;
        block_p_points = points + 1;
    else
        block_p_points = points;
    end
else
    block_p_points = points;
end


end
