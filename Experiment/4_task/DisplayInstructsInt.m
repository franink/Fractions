
Instruct = {};


Instruct{1} = {'The following experiment has 4 sections. Each section is',
               'reasonably short. In total, the experiment should last',
               'approximately 70 minutes.',
               ' ',
               'At the beginning of each section you will receive',
               'instructions specific to that section.' 
               ' ',
               'Read these instructions carefully',
               'and make sure you understand them.',
               ' ',
               'Please PRESS ANY BUTTON to go on to the next screen.'};
            

for ii = 1:length(Instruct);
%     %This is the code if we want to use mouse instead of keyboard
%     clearMouseInput;
%     TextDisplay(Instruct{ii}, win, color);
%     Screen('Flip', win);
%     WaitSecs(0.5);GetClicks(win,0);
    %This is the code if we want to use keyboard instead of mouse to move
    %screen
    %clear keyboard, display screen four, wait for z or / to be pressed
    KbReleaseWait;
    keyResp = 0;
    TextDisplay(Instruct{ii}, win, color);
    Screen('Flip', win);
    WaitSecs(0.5);
    WaitTill({'1' '2' '3' '4' '6' '7' '8' '9'});
end
