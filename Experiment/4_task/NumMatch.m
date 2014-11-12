function [ compResults ] = NumMatch(Fract, Window, color)
%Decide if second number matches one of the original numbers



correct = -1;
response = -1;
accuracy = -1;

compResults = {Fract(3) correct response 0 accuracy}; %I still need to think about what I will log and if I can put names



if or(Fract(1) == Fract(3), Fract(2) == Fract(3));
    correct = 1;
else
    correct = 0;
end

compResults{2} = correct;

winRect = Screen('Rect', Window);
w = winRect(RectRight);
h = winRect(RectBottom);

textSz = 50;

%Text size is 20, style is 1, color is black
Screen('TextSize',Window, 45);
Screen('TextStyle',Window,1);
%color = [0 0 200 255];

%Iterate through TextCell and draw text into backbuffer
fbox11 = Screen('TextBounds', Window, num2str(Fract(3)));
fbox11 = CenterRectOnPoint(fbox11, w/2,h/2);

x11 = fbox11(RectLeft);
y11 = fbox11(RectTop);
xlim1 = fbox11(RectRight);

Screen('DrawText', Window, num2str(Fract(3)), x11, y11, color);
Screen('Flip',Window);

KbReleaseWait;
keyResp = 0;
t_start = GetSecs;
while ~keyResp
    [~, secs, keyCode, ~]  = KbCheck;   
    keypress = find(keyCode==1, 1);
    if ~isempty(keypress);
        if keypress == 29 %they press z
                keyResp = 1;
                response = 0;
                compResults{3} = response;   
                compResults{4} = secs - t_start;
                compResults{5} = correct==response;
        end
        
        if keypress == 56 %they press /
                keyResp = 1;
                response = 1;
                compResults{3} = response;
                compResults{4} = secs - t_start;
                compResults{5} = correct==response;
        end
    end
end
end