
Instruct = {};

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
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    GetClicks(win,0);
end