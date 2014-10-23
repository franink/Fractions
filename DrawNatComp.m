function [] = DrawNatStim(LNum, RNum, Window, color)
%TextDisplay displays text on the screen, eg, to give user instructions in
%an experiment. Each line of text must be stored in a cell. Importantly,
%Psychtoolbox must already be initialized and the Window must be open. Also
%note this program does not close the screen so if it is run by itself sca
%or similar should be called to close the window.

winRect = Screen('Rect', Window);
w = winRect(RectRight);
h = winRect(RectBottom);

textSz = 50;

%Text size is 20, style is 1, color is ...
Screen('TextSize',Window, textSz);
Screen('TextStyle',Window,1);
%color = [0 0 200 255];

%Draw two little numbers on the screen...
fbox11 = Screen('TextBounds', Window, num2str(LNum));
fbox11 = CenterRectOnPoint(fbox11, w/4,h/2);

x11 = fbox11(RectLeft);
y11 = fbox11(RectTop);
xlim1 = fbox11(RectRight);

Screen('DrawText', Window, num2str(LNum), x11, y11, color);

fbox12 = Screen('TextBounds', Window, num2str(RNum));
fbox12 = CenterRectOnPoint(fbox12, 3*w/4,h/2);

x12=fbox12(RectLeft);
y12=fbox12(RectTop);
xlim2 = fbox12(RectRight);

Screen('DrawText', Window, num2str(RNum), x12, y12, color);


end