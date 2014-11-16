function trialResponse = FractLineRGSlow(fract, win, lineLength, jitter, color, time)

%plots a line starting at x1, finishing at x2, with cursor starting on
%either left (lrStart = 0) or right (lrStart = 1) side.

%trialResponse format is [startPos, RT, propLine)

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
time_fix = 0;
time_on = time - time_fix;

trialResponse = {correct response RT Acc points};

fractMag = fract(1)/fract(2);
probeMag = fract(4)/fract(5);

if probeMag > fractMag;
    correct = 1;
end;
if probeMag < fractMag;
    correct = 0;
end;

trialResponse{1} = correct;

trialResponse{2} = correct;

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
probe_XPos = x1 + (x2-x1)*probe;
Screen('Drawline', win, [0 0 0 0], probe_XPos, y - lineSZ/1.5, probe_XPos, y + lineSZ/1.5, round(5*ppc_adjust));

Screen('Flip', win);

t_start = GetSecs;
time = time+t_start
KbReleaseWait;
[key, secs] = WaitTill(time, {'1' '2' '3' '4' '6' '7' '8' '9'}, 0); %wait seconds even if there is a press
if~isempty(key);
    trialResponse{2} = key;
    trialResponse{3} = secs - t_start;
    left = {'1' '2' '3' '4'};
    right = {'6' '7' '8' '9'};
    if ismember(key, left);
        response = 0;
    end
    if ismember(key, right);
        response = 1;
    end
    trialResponse{4} = correct==response;
    if trialResponse{4} == 1;
        trialResponse{5} = trialResponse{5} + 1;
    end
end


end
