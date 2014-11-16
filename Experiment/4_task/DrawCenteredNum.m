function [] = DrawCenteredNum(Fract, Window, color, time)
%TextDisplay displays text on the screen, eg, to give user instructions in
%an experiment. Each line of text must be stored in a cell. Importantly,
%Psychtoolbox must already be initialized and the Window must be open. Also
%note this program does not close the screen so if it is run by itself sca
%or similar should be called to close the window.
%Fract is replaced by an 'X" as fixation

winRect = Screen('Rect', Window);
w = winRect(RectRight);
h = winRect(RectBottom);

textSz = 50;

%Text size is 20, style is 1, color is black
Screen('TextSize',Window, 45);
Screen('TextStyle',Window,1);
%color = [0 0 200 255];

%Iterate through TextCell and draw text into backbuffer
fbox11 = Screen('TextBounds', Window, Fract); % This is the test number (I have not created this numbers yet)
fbox11 = CenterRectOnPoint(fbox11, w/2,h/2);

x11 = fbox11(RectLeft);
y11 = fbox11(RectTop);
xlim1 = fbox11(RectRight);


Screen('DrawText', Window, Fract, x11, y11, color);
Screen('Flip',Window);
wakeup = WaitSecs(time);


end