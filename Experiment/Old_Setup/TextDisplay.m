function [] = TextDisplay( TextCell, win, color )
%TextDisplay displays text on the screen, eg, to give user instructions in
%an experiment. Each line of text must be stored in a cell. Importantly,
%Psychtoolbox must already be initialized and the Window must be open. Also
%note this program does not close the screen so if it is run by itself sca
%or similar should be called to close the window.

%Text size is 20, style is 1, color is black
Screen('TextSize',win, 20);
Screen('TextStyle',win,1);
%color = BlackIndex(Window);

%Iterate through TextCell and draw text into backbuffer
for ii = 1:length(TextCell)
bbox = Screen('TextBounds', win, TextCell{ii});
bbox = CenterRect(bbox, Screen('Rect', win));
x=bbox(RectLeft); y=bbox(RectTop) - (15*length(TextCell));
Screen('DrawText', win, TextCell{ii}, x, y+(ii-1)*30, color);
end

%flip text onto screen
%Screen('Flip',Window);

end
