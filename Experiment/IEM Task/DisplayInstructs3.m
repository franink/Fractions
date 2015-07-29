
Instruct = {};

correct_txt = sprintf('You have answered %d trials correctly', p.hits + p.correctRejections);
errors_txt = sprintf('You have answered %d trials incorrectly', p.misses + p.falseAlarms);

Instruct{1} = {'REST BREAK',
               ' ',
               correct_txt,
               ' ',
               ' ',
               errors_txt,
               ' ',
               ' ',
               ' ',
              'PRESS BUTTON when you are ready to continue the experiment.'};

                               

for ii = 1:length(Instruct);
    %This is the code if we want to use mouse instead of keyboard
%     clearMouseInput;
%     TextDisplay(Instruct{ii}, win, p.textColor);
%     Screen('Flip', win);
%     WaitSecs(0.5);
%     GetClicks(win,0);
    
    %This is the code if we want to use keyboard instead of mouse to move
    %screen
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, p.textColor);
    Screen('Flip', win);
    WaitSecs(0.5);
    %WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
    WaitTill({'1'});
end