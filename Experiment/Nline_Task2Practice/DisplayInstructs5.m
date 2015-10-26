Instruct = {};

Instruct{1} = {'In the following trials you will be asked to mark a',
               'number line to indicate the magnitude of a number.',
               'The procedures of this task are exactly the same as for',
               'the previous task.'
               ' ',
               'The only difference is that the number line will now span',
               'from -100 to 100.',
               'During the experiment, this task will be called: -100 to 100 task.',
               ' ',
               'Please PRESS BUTTON to go on to the next screen.'};
 
Instruct{2} = {'In the following screens you will see 4 practice trials',
               ' ',
               'Please PRESS BUTTON to begin the practice trials.'};

for ii = 1:length(Instruct)
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