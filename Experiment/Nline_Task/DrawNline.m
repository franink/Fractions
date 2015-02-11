function [] = DrawNline(left_end, right_end, lineLength, lineSZ, jitter, ppc_adjust, win, color, x1, x2, yline, center, winRect, cursor)
%Draws a numberline with specified endpoint labels and line length.
% Optional jitter can be added and it also provides the screen window
% pointer and color of line as parameters. Importantly,
%Psychtoolbox must already be initialized and the Window must be open. Also
%note this program does not close the screen so if it is run by itself sca
%or similar should be called to close the window.


Screen('TextSize',win, 30);
Screen('TextStyle',win, 1);

if cursor == 0
    HideCursor;
end
zeroBox = Screen('TextBounds', win, left_end);
oneBox = Screen('TextBounds', win, right_end);
zeroBox = CenterRectOnPoint(zeroBox, x1, yline + 40);
oneBox = CenterRectOnPoint(oneBox, x2, yline + 40);

zX=zeroBox(RectLeft); oX = oneBox(RectLeft); yNum=oneBox(RectTop);

Screen('Drawline', win,color, x1, yline, x2, yline, round(5*ppc_adjust)); %instead of color he had [0 0 200 255]
Screen('Drawline', win, color, x1, yline - lineSZ, x1, yline + lineSZ, round(5*ppc_adjust));
Screen('Drawline', win, color, x2, yline - lineSZ, x2, yline + lineSZ, round(5*ppc_adjust));

Screen('DrawText', win, left_end, zX, yNum, color);
Screen('DrawText', win, right_end, oX, yNum, color);

%Screen('Flip', win);
end

