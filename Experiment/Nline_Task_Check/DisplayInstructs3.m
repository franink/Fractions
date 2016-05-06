
Instruct = {};

pts_txt = sprintf('You have earned %d points in this section', block_points);
block_pts_txt = sprintf('In total, you have earned %d points', points);
error_txt = sprintf('Too soon: %d    Too slow: %d    Wrong position: %d    Should not press: %d', move, slow, wrong, badpress);

Instruct{1} = {'REST BREAK',
               ' ',
               ' ',
               ' ',
              'CLICK MOUSE to continue the experiment.'};

                               

for ii = 1:length(Instruct);
    clearMouseInput;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    GetClicks(win,0);
end