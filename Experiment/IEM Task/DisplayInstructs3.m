
Instruct = {};

pts_txt = sprintf('You have earned %d points in this section', 30);
block_pts_txt = sprintf('In total, you have earned %d points', 40);
error_txt = sprintf('Too soon: %d    Too slow: %d    Wrong position: %d    Should not press: %d', 9, 10, 11, 12);

Instruct{1} = {'REST BREAK',
               ' ',
               pts_txt,
               ' ',
               block_pts_txt,
               ' ',
               ' ',
               ' ',
               error_txt,
               ' ',
               ' ',
              'CLICK MOUSE to continue the experiment.'};

                               

for ii = 1:length(Instruct);
    clearMouseInput;
    TextDisplay(Instruct{ii}, win, p.textColor);
    Screen('Flip', win);
    WaitSecs(0.5);
    GetClicks(win,0);
end