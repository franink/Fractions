function [] = DrawCenteredFrac(Fract, Window, color)
%Displays two numbers (Frac) as a fraction one on top of another divided by a horizontal line 
%TextDisplay displays text on the screen, eg, to give user instructions in
%an experiment. Each line of text must be stored in a cell. Importantly,
%Psychtoolbox must already be initialized and the Window must be open. Also
%note this program does not close the screen so if it is run by itself sca
%or similar should be called to close the window.

winRect = Screen('Rect', Window);
w = winRect(RectRight);
h = winRect(RectBottom);

textSz = 50;

%Text size is 20, style is 1, color is color
Screen('TextSize',Window, 40);
Screen('TextStyle',Window,1);

%Draw text into backbuffer
fbox11 = Screen('TextBounds', Window, num2str(Fract(1)));
fbox11 = CenterRectOnPoint(fbox11, w/2,h/2 - (textSz+10));

x11 = fbox11(RectLeft);
y11 = fbox11(RectTop);
xlim1 = fbox11(RectRight);

%Draw num
Screen('DrawText', Window, num2str(Fract(1)), x11, y11, color);

fbox12 = Screen('TextBounds', Window, num2str(Fract(2)));
fbox12 = CenterRectOnPoint(fbox12, w/2,h/2 + (textSz+10));

x12=fbox12(RectLeft);
y12=fbox12(RectTop);
xlim2 = fbox12(RectRight);

%Draw Denom
Screen('DrawText', Window, num2str(Fract(2)), x12, y12, color);

xL = min(x11,x12);
xR = max(xlim1, xlim2);

%Draw division line
Screen('DrawLine', Window, color, xL, h/2, xR, h/2, 3);

end