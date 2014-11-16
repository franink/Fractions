Instruct = {};

Instruct{1} = {'END OF PRACTICE',
               ' ',
               'If you have any questions please ask now',
               ' ',
               'Please PRESS ANY BUTTON when you are ready to begin the experiment'};


for ii = 1:length(Instruct)
    %clear keyboard, display screen four, wait for z or / to be pressed
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
end
    


