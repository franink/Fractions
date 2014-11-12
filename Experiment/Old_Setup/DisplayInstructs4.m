Instruct = {};

Instruct{1} = {'END OF PRACTICE',
               ' ',
               'If you have any questions please ask now',
               ' ',
               'Please click MOUSE when you are ready to begin the experiment'};


for ii = 1:length(Instruct)
    %clear keyboard, display screen four, wait for z or / to be pressed
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    GetClicks(win,0);
end
    


