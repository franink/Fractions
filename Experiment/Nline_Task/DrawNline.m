function [] = DrawNline(left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, y, center, winRect, cursor)
%Draws a numberline with specified endpoint labels and line length.
% Optional jitter can be added and it also provides the screen window
% pointer and color of line as parameters. Importantly,
%Psychtoolbox must already be initialized and the Window must be open. Also
%note this program does not close the screen so if it is run by itself sca
%or similar should be called to close the window.

% winRect = Screen('Rect', win);
% y = round(winRect(4)/2);
% center = winRect(3)/2;
% 
% ppc_adjust = 23/38;
% 
% lineLength = round(lineLength*ppc_adjust);
% lineSZ = round(20*ppc_adjust);
% 
% rng shuffle
% jitter = jitter*randi([-300 300]);
% jitter = round(jitter*ppc_adjust);% Here position of line is jittered
% 
% x1 = round(center - lineLength/2 + jitter); % Here position of line is jittered
% x2 = round(center + lineLength/2 + jitter);% Here position of line is jittered
Screen('TextSize',win, 30);
Screen('TextStyle',win, 1);

if cursor == 0
    HideCursor;
end
zeroBox = Screen('TextBounds', win, left_end);
oneBox = Screen('TextBounds', win, right_end);
zeroBox = CenterRectOnPoint(zeroBox, x1, y + 40);
oneBox = CenterRectOnPoint(oneBox, x2, y + 40);

zX=zeroBox(RectLeft); oX = oneBox(RectLeft); yNum=oneBox(RectTop);

Screen('Drawline', win,color, x1, y, x2, y, round(5*ppc_adjust)); %instead of color he had [0 0 200 255]
Screen('Drawline', win, color, x1, y - lineSZ, x1, y + lineSZ, round(5*ppc_adjust));
Screen('Drawline', win, color, x2, y - lineSZ, x2, y + lineSZ, round(5*ppc_adjust));

Screen('DrawText', win, left_end, zX, yNum, color);
Screen('DrawText', win, right_end, oX, yNum, color);

%Screen('Flip', win);
end

